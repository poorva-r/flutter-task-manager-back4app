# Flutter Task Manager App 📝

A Flutter-based Task Manager application built with Back4App (Backend as a Service).
This app demonstrates full CRUD operations with user authentication using Parse Server.

## 📱 Screenshots

## ✨ Features

- 🔐 User Registration & Login using student email
- ✅ Create tasks with title and description
- 📋 Read and view all your tasks in real time
- ✏️ Update/Edit existing tasks
- 🗑️ Delete tasks with confirmation dialog
- 🔄 Real-time sync with Back4App cloud database
- 🚪 Secure logout with session invalidation

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Flutter & Dart | Frontend mobile app |
| Back4App | Backend as a Service (BaaS) |
| Parse Server | Database & Authentication |
| GitHub | Version Control |

## 📁 Project Structure

```
lib/
├── main.dart                 → App entry point & Parse initialization
└── screens/
    ├── login_screen.dart     → User login
    ├── register_screen.dart  → User registration
    ├── task_list_screen.dart → View, delete & logout
    ├── add_task_screen.dart  → Create new task
    └── edit_task_screen.dart → Update existing task
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio (for Android SDK)
- Back4App account
- VS Code

### Installation

1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/flutter-task-manager-back4app.git
cd flutter-task-manager-back4app
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Back4App credentials in `lib/main.dart`
```dart
await Parse().initialize(
  'YOUR_APPLICATION_ID',
  'https://parseapi.back4app.com',
  clientKey: 'YOUR_CLIENT_KEY',
  autoSendSessionId: true,
);
```

4. Run the app
```bash
flutter run
```

## 🗄️ Back4App Database Structure

### Task Class
| Column | Type | Description |
|---|---|---|
| objectId | String | Auto-generated unique ID |
| title | String | Task title |
| description | String | Task description |
| user_id | Pointer to _User | Owner of the task |
| createdAt | DateTime | Auto-generated timestamp |
| updatedAt | DateTime | Auto-generated timestamp |

### _User Class (built-in)
| Column | Type | Description |
|---|---|---|
| objectId | String | Auto-generated unique ID |
| username | String | Student email |
| email | String | Student email |
| password | String | Encrypted password |

## 📋 CRUD Operations

| Operation | Screen | Description |
|---|---|---|
| Create | Add Task Screen | Add new task to cloud database |
| Read | Task List Screen | Fetch and display all user tasks |
| Update | Edit Task Screen | Modify existing task |
| Delete | Task List Screen | Remove task with confirmation |

## 🔐 Security Note

> In production, API keys should be stored in a `.env` file and never committed to GitHub.
> For this demo project, keys are stored in `main.dart` for simplicity.

## 📹 Demo Video

