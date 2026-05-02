# Orbit - Task Manager App

A Flutter-based task manager application built with Back4App as a Backend-as-a-Service (BaaS). Orbit allows users to register, log in, and manage their tasks through a clean dark-themed interface with no custom backend required.

This project was built as part of the course Cross Platform Application Development (SE ZG585) at BITS Pilani (WILP).

## Demo Video

[Video Link](https://youtube.com/shorts/TLLH-0hnnEo?si=t263rL3iJreXqHXT)

## Screenshots

<img width="1498" height="752" alt="image" src="https://github.com/user-attachments/assets/c9c5a0c1-949a-4369-b81b-130073b35497" />

## Features

- User registration and login using email
- Create tasks with a title and description
- View all tasks fetched in real time from the cloud
- Edit existing tasks
- Delete tasks with a confirmation dialog
- Mark tasks as complete with a checkbox — completed tasks show a strikethrough and move to the bottom
- Progress bar showing how many tasks are completed
- Secure logout with session invalidation
- Dark themed UI

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter and Dart | Frontend mobile application |
| Back4App | Backend as a Service (BaaS) - database and user authentication |
| GitHub | Version control |

## Project Structure

```
lib/
├── main.dart                 — App entry point and Parse initialization
└── screens/
    ├── login_screen.dart     — User login
    ├── register_screen.dart  — User registration
    ├── task_list_screen.dart — Task list with complete, edit, delete and logout
    ├── add_task_screen.dart  — Create a new task
    └── edit_task_screen.dart — Edit an existing task
```

## Database Structure

### Task Class

| Column | Type | Description |
|---|---|---|
| objectId | String | Auto-generated unique ID |
| title | String | Task title |
| description | String | Task description |
| isCompleted | Boolean | Whether the task is checked off |
| user_id | Pointer to _User | Links task to its owner |
| createdAt | DateTime | Auto-generated timestamp |

### _User Class (built-in to Back4App)

| Column | Type | Description |
|---|---|---|
| objectId | String | Auto-generated unique ID |
| username | String | Student email used as username |
| email | String | Student email address |
| password | String | Encrypted by Parse automatically |

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio (for Android SDK)
- Back4App account

### Installation

1. Clone the repository

```bash
git clone https://github.com/poorva-r/flutter-task-manager-back4app.git
cd flutter-task-manager-back4app
```

2. Install dependencies

```bash
flutter pub get
```

3. Add your Back4App credentials

If running on Chrome, add them directly in `lib/main.dart`:

```dart
await Parse().initialize(
  'YOUR_APPLICATION_ID',
  'https://parseapi.back4app.com',
  clientKey: 'YOUR_CLIENT_KEY',
  autoSendSessionId: true,
);
```

If running on Android, create a `.env` file in the project root:

```
APP_ID=your_application_id
CLIENT_KEY=your_client_key
```

4. Run the app

```bash
flutter run
```

## Details

- Name: Poorva Ramnani
- Student ID: 2025TM93093
- Email: 2025tm93093@wilp.bits-pilani.ac.in
- Course: Cross Platform Application Development - SE ZG585
- Institution: BITS Pilani (WILP)
