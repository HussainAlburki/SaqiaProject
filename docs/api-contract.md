# Saqia API Contract (MVP)

## Auth

- `POST /auth/signup`
  - body: `{ role, name, phone, email, password }`
  - returns: `{ user, accessToken, refreshToken }`
- `POST /auth/login`
  - body: `{ email, password }`
  - returns: `{ user, accessToken, refreshToken }`
- `POST /auth/refresh`
  - body: `{ refreshToken }`
  - returns: `{ accessToken }`

## Mosques

- `GET /mosques`
  - query: `search`, `minStock`, `maxDistanceKm`
  - returns: `{ items: Mosque[] }`
- `GET /mosques/:id`
  - returns: `Mosque`

## Orders

- `POST /orders`
  - body: `{ mosqueId, packages, paymentMethod }`
  - returns: `DonationOrder`
- `GET /orders`
  - query: `role` (`donor|supplier|admin`), `status`
  - returns: `{ items: DonationOrder[] }`
- `GET /orders/:id`
  - returns: `DonationOrder`

## Delivery Proofs

- `POST /orders/:id/proofs`
  - body: `{ photos: string[], notes?: string, videoUrl?: string }`
  - returns: `{ success: true }`

## Status Codes

- `200` OK
- `201` Created
- `400` Validation error
- `401` Unauthorized
- `403` Forbidden
- `404` Not found
- `500` Server error
