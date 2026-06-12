import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:ndaaa_chat/core/theme/app_typography.dart';
import 'package:ndaaa_chat/core/theme/app_spacing.dart';
import '../animations/custom_progress_indcator.dart';

class ImageViewer extends StatefulWidget {
  final String? imageUrl;
  final List<String>? imageUrls;
  final int initialIndex;

  const ImageViewer({
    super.key,
    this.imageUrl,
    this.imageUrls,
    this.initialIndex = 0,
  }) : assert(
         imageUrl != null || imageUrls != null,
         'Either imageUrl or imageUrls must be provided',
       );

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late PageController _pageController;
  late int _currentIndex;
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // إعداد قائمة الصور
    if (widget.imageUrls != null) {
      _images = widget.imageUrls!;
    } else {
      _images = [widget.imageUrl!];
    }

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: _images.length > 1
            ? Text(
                '${_currentIndex + 1} / ${_images.length}',
                style: AppTypography.heading6.copyWith(
                  color: Colors.white,
                ),
              )
            : null,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // معرض الصور
          Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(_images[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2.5,
                  heroAttributes: PhotoViewHeroAttributes(tag: 'image_$index'),
                );
              },
              itemCount: _images.length,
              loadingBuilder: (context, event) =>
                  const Center(child: CustomProgressIndicator()),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              pageController: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              scrollDirection: Axis.horizontal,
              reverse: isRTL, // عكس الاتجاه للعربي فقط
            ),
          ),

          // أسهم التنقل (فقط إذا كان هناك أكثر من صورة)
          if (_images.length > 1) ...[
            // السهم الأيسر (start في RTL = يمين، start في LTR = شمال)
            if (_currentIndex < _images.length - 1)
              PositionedDirectional(
                end: AppSpacing.lg,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                         Icons.chevron_right,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),

            // السهم الأيمن (end في RTL = شمال، end في LTR = يمين)
            if (_currentIndex > 0)
              PositionedDirectional(
                start: AppSpacing.lg,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),

            // مؤشر النقاط في الأسفل
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Directionality(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _images.length,
                    (index) => Container(
                      width: AppSpacing.sm,
                      height: AppSpacing.sm,
                      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentIndex
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
