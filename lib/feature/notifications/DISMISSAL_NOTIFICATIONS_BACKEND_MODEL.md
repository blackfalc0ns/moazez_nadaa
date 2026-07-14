# Dismissal Notifications Backend Model

## List

`GET /api/v1/dismissal/notifications`

```json
{
  "data": [
    {
      "id": "uuid",
      "type": "request_created | request_cancelled | request_called | request_ready | request_handed_over | request_expired",
      "sourceModule": "DISMISSAL",
      "sourceType": "dismissal_request",
      "sourceId": "request uuid",
      "title": "string",
      "body": "string",
      "priority": "normal | high | urgent | critical",
      "status": "unread | read",
      "readAt": "ISO date | null",
      "createdAt": "ISO date"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 0,
    "totalPages": 1,
    "hasNext": false
  }
}
```

## Actions

- `PATCH /api/v1/dismissal/notifications/:id/read`
- `PATCH /api/v1/dismissal/notifications/read-all`
- `POST /api/v1/dismissal/notifications/device-tokens`
- `DELETE /api/v1/dismissal/notifications/device-tokens/current`

## Permissions

- `dismissal.notifications.view`
- `dismissal.notifications.manage`
- `app.device_tokens.manage`
