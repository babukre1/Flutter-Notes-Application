# Notes Application

## group member
1. abubakar ali abdulle
2. adullahi ali abdullahi
3. abas abirahman yusuf
4. nuradin farah adan
5. mohamed abdisalam ahmed

A Flutter project refactored into a **Model-View-Controller (MVC)** architecture.

## Architecture Overview

This application follows a strict MVC pattern to separate concerns and improve maintainability:

### 1. Model (`lib/models/`)
- Represents the data structure of the application (e.g., `NoteItem`).
- Used by Controllers to Type-safe data and by Views to render information.
- Contains `fromJson` methods for parsing API responses.

### 2. View (`lib/views/`)
- Contains all UI screens (e.g., `LoginScreen`, `NotesListHome`) and widgets.
- Responsible **only** for rendering the UI and handling user interactions.
- Calls methods in **Controllers** to perform actions (like logging in or fetching notes).
- Updates the UI based on data returned from Controllers (using `setState`).

### 3. Controller (`lib/controllers/`)
- Acts as the bridge between the View and the Data (Services/Models).
- Contains business logic (e.g., proper login validation handling, filtering notes list).
- Calls **Services** to fetch raw data, converts it to **Models**, and returns it to the View.
- **Examples**: `AuthController` (handles login/signup), `NotesController` (fetches/filters notes).

### 4. Service (`lib/services/`)
- Handles low-level data fetching and networking.
- **Example**: `ApiClient` manages Dio instances, cookies, and HTTP requests.

## Getting Started

1.  Clone the repository.
2.  Run `flutter pub get`.
3.  Run `flutter run`.
