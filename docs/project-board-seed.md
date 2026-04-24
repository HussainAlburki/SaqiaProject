# Suggested Initial GitHub Issues

## Setup & Workflow

- Protect `main` branch and require PR reviews.
- Configure required checks: `flutter analyze` and `flutter test`.
- Add issue templates for bug report and feature request.

## Frontend

- Refactor shared cards/chips into reusable components.
- Add full auth form validation and error messages.
- Add loading, empty, and error states to donor/supplier/admin screens.

## Architecture

- Introduce repository interfaces for auth, mosques, and orders.
- Add mock repository implementations and migrate state layer.
- Add environment config for `dev`, `staging`, `prod`.

## Backend MVP

- Initialize backend project and add `/health`.
- Implement auth module with JWT.
- Implement mosques and orders CRUD endpoints.
- Implement delivery proof upload endpoint and storage.
