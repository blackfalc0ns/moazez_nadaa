# Responsive System

The application installs `ResponsiveScope` globally in `main.dart`. Widgets can
read the current layout information without adding another `MediaQuery`:

```dart
final responsive = context.responsive;
```

## Architecture

```
app_breakpoints.dart          ← threshold constants + AppWindowClass enum
responsive_info.dart          ← immutable layout snapshot with helpers
responsive_scope.dart         ← InheritedWidget + context extension
widgets/
  adaptive_layout_builder.dart  ← structural layout switcher
  responsive_constrained_content.dart  ← max-width + padding wrapper
  responsive_grid.dart         ← auto-column-count Wrap grid
```

### Global vs. local scope

The global `ResponsiveScope` in `main.dart` wraps the entire navigator, so
`context.responsive` resolves against the **screen** size. To make decisions
against a smaller region (e.g. inside a split pane or a bottom sheet), wrap
that subtree in its own `ResponsiveScope` — the `context.responsive` extension
will find the nearest one.

## Window classes

| Class          | Width range   | Typical device                    |
|----------------|---------------|-----------------------------------|
| `compact`      | < 600         | Phone portrait                    |
| `medium`       | 600 – 840     | Small tablet / phone landscape    |
| `expanded`     | 840 – 1200    | Large tablet                      |
| `large`        | ≥ 1200        | Desktop / web                     |

Prefer layout changes at the `600`, `840`, and `1200` breakpoints over scattered
device-name checks. Feature-specific thresholds should stay inside that feature.

## Layout decisions

- **Structural changes** → `windowClass` or `select()` / `adaptive()`.
- **Master/detail** → `useTwoPaneLayout`.
- **Readable content** → `pagePadding` and `contentMaxWidth` (or
  `ResponsiveConstrainedContent`).
- **Bounded visual tweaks** → `scale()` for dimensions, `fontSize()` for text.
- **Never** disable accessibility text scaling; constrain or scroll content
  instead.

## Helpers reference

| Property / method | Purpose |
|---|---|
| `windowClass` | Coarse layout bucket (compact / medium / expanded / large). |
| `select<T>(compact:, medium?, expanded?, large?)` | Pick any typed value per class with fallback. |
| `adaptive(compact:, medium?, expanded?, large?)` | `select<double>` shorthand for numeric tokens. |
| `scale(value)` | Proportionally resize a dimension using the balanced scale. |
| `fontSize(value)` | Width-aware font size multiplier (does **not** duplicate system text scaling). |
| `pagePadding` | Recommended `EdgeInsets` that grows with the window class. |
| `contentMaxWidth` | Max readable content width per class. |
| `safeHeight` | Usable height minus safe-area padding and keyboard insets. |
| `safeArea` | Alias for `viewPadding` (status bar / notch). |
| `foldPadding` | Insets to avoid a hinge on foldable devices. |
| `hasFold` | Whether a hinge display feature is present. |
| `isTablet` | `true` when the shortest side ≥ 600. Stable across rotation. |
| `isNarrowPhone` / `isShort` | Flags for extra-small devices. |
| `useTwoPaneLayout` | Landscape + ≥ 600 wide. |

## Reusable widgets

- **`AdaptiveLayoutBuilder`**: selects compact, medium, expanded, or landscape
  UI. First match wins: landscape > expanded > medium > compact.
- **`ResponsiveConstrainedContent`**: centers content, applies adaptive width
  and padding. Wrap any page body that should stay readable on wide screens.
- **`ResponsiveGrid`**: calculates columns from available width and item
  minimums. Uses `Wrap`, so it is best for short on-screen lists. For long
  scrollable grids prefer `SliverGrid` instead.

## Design tokens

Scaling constants reference an iPhone 12/13 logical size (390 × 844). Values
are clamped to prevent extreme sizing on very small or very large devices.

```
widthScale  = clamp(width / 390,   0.82, 1.35)
heightScale = clamp(height / 844,  0.78, 1.25)
```

## Testing

```dart
// Unit tests (no widgets needed)
final info = ResponsiveInfo(
  size: const Size(390, 844),
  viewPadding: EdgeInsets.zero,
  viewInsets: EdgeInsets.zero,
  orientation: Orientation.portrait,
  textScaleFactor: 1,
  windowClass: AppWindowClass.compact,
);
expect(info.adaptive(compact: 16, medium: 24), 16);

// Widget tests — wrap in ResponsiveScope
await tester.pumpWidget(
  MaterialApp(
    home: ResponsiveScope(
      builder: (context, info) => YourWidget(info: info),
    ),
  ),
);
```

## Accessibility

- [x] System text scaling is preserved (Flutter handles it; `fontSize()`
  only adjusts for width, never overriding the user's setting).
- [x] `textScaleFactor` is tracked for future use and included in
  `updateShouldNotify`.
- [x] Foldable hinge avoidance via `hasFold` and `foldPadding`.
