# Deadline Tracker

A beautiful Flutter application to help you track and manage deadlines with real-time countdown.

## Features

- ✅ **Add Deadlines**: Create new deadlines with title, description, and due date/time
- 📊 **Visual Table**: View all deadlines in a clean, organized table format
- ⏰ **Remaining Time**: See exactly how much time is left for each deadline
- 🔴 **Overdue Alerts**: Overdue deadlines are highlighted in red
- 📅 **Smart Sorting**: Deadlines are automatically sorted from earliest to latest
- 🗑️ **Delete Deadlines**: Remove completed or cancelled deadlines
- 📈 **Statistics Dashboard**: Comprehensive analytics and insights
  - Overview cards showing total, active, overdue, and critical deadlines
  - Status distribution with visual progress bars
  - Time analysis with average time remaining
  - Upcoming deadlines (next 7 days) list
  - Recent activity tracker
- 🎨 **Modern UI**: Beautiful Material Design 3 interface with bottom navigation

## Screenshots

The app displays:

**Deadlines Tab:**
- A table with columns: Title, Description, Due Date, Remaining Time, Status, and Actions
- Color-coded status indicators (green for active, red for overdue)
- Real-time countdown that updates automatically
- Floating action button to add new deadlines

**Statistics Tab:**
- Overview section with key metrics (total, active, overdue, critical deadlines)
- Status distribution with percentage breakdown
- Time analysis showing average time remaining
- Upcoming deadlines for the next 7 days
- Recent activity showing deadlines created in the last week

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
    ├── home_screen.dart           # Main screen with bottom navigation
    ├── add_deadline_screen.dart   # Screen to add new deadlines
    └── statistics_screen.dart     # Statistics and analytics dashboard
```

## Usage

1. **Adding a Deadline**:
   - Navigate to the "Deadlines" tab (first tab in bottom navigation)
   - Tap the "Add Deadline" floating action button
   - Fill in the title and description
   - Select the due date and time
   - Tap "Save Deadline"

2. **Viewing Deadlines**:
   - All deadlines are displayed in a table on the Deadlines tab
   - Sorted automatically from earliest to latest
   - Remaining time is calculated and displayed in real-time
   - Overdue deadlines are highlighted in red

3. **Viewing Statistics**:
   - Tap the "Statistics" tab in the bottom navigation
   - View comprehensive analytics including:
     - Total, active, overdue, and critical deadlines count
     - Status distribution with percentage breakdown
     - Average time remaining for active deadlines
     - List of upcoming deadlines (next 7 days)
     - Recent activity showing newly created deadlines

4. **Deleting a Deadline**:
   - Go to the Deadlines tab
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
- More advanced charts and visualizations
- Deadline completion tracking
- Weekly/monthly statistics reports

## License

This project is open source and available for educational purposes.
