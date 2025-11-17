# Deadline Tracker

A beautiful Flutter application to help you track and manage deadlines with real-time countdown.

## Features

- ✅ **Add Deadlines**: Create new deadlines with title, description, and due date/time
- 📊 **Visual Table**: View all deadlines in a clean, organized table format
- ⏰ **Remaining Time**: See exactly how much time is left for each deadline
- 🔴 **Overdue Alerts**: Overdue deadlines are highlighted in red
- 📅 **Smart Sorting**: Deadlines are automatically sorted from earliest to latest
- 🗑️ **Delete Deadlines**: Remove completed or cancelled deadlines
- 🎨 **Modern UI**: Beautiful Material Design 3 interface

## Screenshots

The app displays:
- A table with columns: Title, Description, Due Date, Remaining Time, Status, and Actions
- Color-coded status indicators (green for active, red for overdue)
- Real-time countdown that updates automatically
- Floating action button to add new deadlines

## Installation & Setup

1. **Install Flutter** (if not already installed):
   - Follow the official Flutter installation guide: https://flutter.dev/docs/get-started/install

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   
   For Android/iOS:
   ```bash
   flutter run
   ```
   
   For Web:
   ```bash
   flutter run -d chrome
   ```
   
   For Desktop (Linux/macOS/Windows):
   ```bash
   flutter run -d linux
   flutter run -d macos
   flutter run -d windows
   ```

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   └── deadline.dart              # Deadline data model
├── providers/
│   └── deadline_provider.dart     # State management
└── screens/
    ├── home_screen.dart           # Main screen with deadlines table
    └── add_deadline_screen.dart   # Screen to add new deadlines
```

## Usage

1. **Adding a Deadline**:
   - Tap the "Add Deadline" floating action button
   - Fill in the title and description
   - Select the due date and time
   - Tap "Save Deadline"

2. **Viewing Deadlines**:
   - All deadlines are displayed in a table
   - Sorted automatically from earliest to latest
   - Remaining time is calculated and displayed in real-time
   - Overdue deadlines are highlighted in red

3. **Deleting a Deadline**:
   - Click the delete icon (trash can) in the Actions column
   - Confirm the deletion in the dialog

## Dependencies

- **flutter**: SDK for building the app
- **provider**: State management solution
- **intl**: Internationalization and date formatting

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Material Design 3**: Modern UI design system
- **Provider Pattern**: For state management

## Future Enhancements

Potential features for future versions:
- Persistent storage (local database)
- Push notifications for upcoming deadlines
- Categories/tags for deadlines
- Search and filter functionality
- Edit existing deadlines
- Dark mode toggle
- Export deadlines to calendar

## License

This project is open source and available for educational purposes.
