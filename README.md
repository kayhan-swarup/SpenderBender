# SpenderBender

An offline-first expense tracking mobile application built with Flutter. Track your expenses and income across multiple accounts (Cash & Bank) with beautiful dark-themed UI and comprehensive financial statistics.

## Features

### Screenshots

<img width="418" height="874" alt="Screenshot 2026-02-23 at 1 31 42 AM" src="https://github.com/user-attachments/assets/3e82886d-fd02-4d42-8875-dcf8563db381" />
<img width="424" height="881" alt="Screenshot 2026-02-23 at 1 52 59 AM" src="https://github.com/user-attachments/assets/574ef5f9-796f-4a92-a3b1-0b3099a4f8a6" />
<img width="421" height="877" alt="Screenshot 2026-02-23 at 1 32 55 AM" src="https://github.com/user-attachments/assets/204401c4-7559-451d-95f8-2a2b35069079" />


### 💰 Account Management
- **Multiple Account Types**: Create and manage both Cash and Bank accounts
- **Balance Tracking**: Real-time balance updates across all accounts
- **Initial Setup**: Guided cash balance setup on first launch
- **Account Overview**: Visual cards displaying account balances

### 📊 Transaction Management
- **Income & Expenses**: Track both income and expense transactions
- **Category Organization**: Pre-defined categories (Food & Drinks, Shopping, Transportation, Others)
- **Custom Categories**: Create new categories on-the-fly
- **Transaction Details**: Amount, category, account, date & time for each transaction
- **Recent Transactions**: Quick view of last 5 transactions on dashboard
- **Transaction History**: Complete list of all transactions with delete functionality

### 📈 Financial Statistics
- **Total Balance**: Aggregate balance across all accounts
- **Spending Analysis**: Track total expenses over selected periods
- **Cash Flow**: Monitor income vs expenses
- **Income Reports**: View total income over time
- **Time Period Filters**: Analyze data by 7 days, 30 days, 12 weeks, 6 months, or 1 year

### 🎨 User Experience
- **Dark Theme**: Beautiful dark mode UI for comfortable viewing
- **Pull-to-Refresh**: Refresh data on dashboard and transaction screens
- **Offline-First**: All data stored locally using SQLite
- **Smooth Navigation**: Bottom navigation bar with 3 tabs (Dashboard, Add Record, Statistics)
- **Form Validation**: Real-time validation for all input forms
- **Auto-Navigation**: Automatically returns to dashboard after adding transactions

## Tech Stack

### Framework & Language
- **Flutter** `3.41.2` - Cross-platform mobile framework
- **Dart** `3.11.0` - Programming language

### State Management
- **Riverpod** `^3.2.1` - Modern, reactive state management solution
- **flutter_riverpod** `^3.2.1` - Flutter integration for Riverpod

### Database
- **sqflite** `^2.3.0` - SQLite plugin for Flutter
- **path** `^1.9.1` - Path manipulation library

### Navigation
- **go_router** `^17.1.0` - Declarative routing solution

### UI Components & Utilities
- **intl** `^0.20.2` - Internationalization and localization (date/number formatting)
- **fl_chart** `^1.1.1` - Beautiful charts library (ready for balance trend visualization)

### Forms
- **flutter_form_builder** `^10.3.0+2` - Form building and management
- **form_builder_validators** `^11.3.0` - Pre-built form validators

### Development
- **flutter_lints** `^6.0.0` - Recommended linting rules

## Project Structure

```
spender_bender/
├── lib/
│   ├── main.dart                           # App entry point
│   ├── app.dart                            # Root app widget
│   ├── core/
│   │   ├── constants/                      # App-wide constants
│   │   │   ├── app_constants.dart          # General constants
│   │   │   └── theme_constants.dart        # Theme & styling
│   │   ├── routes/
│   │   │   └── app_router.dart             # GoRouter configuration
│   │   └── utils/
│   │       ├── date_formatter.dart         # Date formatting utilities
│   │       └── currency_formatter.dart     # Currency formatting
│   ├── data/
│   │   ├── database/
│   │   │   └── database_helper.dart        # SQLite initialization
│   │   ├── models/                         # Data models
│   │   │   ├── user.dart
│   │   │   ├── account.dart
│   │   │   ├── category.dart
│   │   │   ├── transaction.dart
│   │   │   └── balance_data_point.dart
│   │   └── repositories/                   # Data access layer
│   │       ├── user_repository.dart
│   │       ├── account_repository.dart
│   │       ├── category_repository.dart
│   │       └── transaction_repository.dart
│   ├── providers/                          # Riverpod providers
│   │   ├── user_provider.dart
│   │   ├── account_provider.dart
│   │   ├── category_provider.dart
│   │   ├── transaction_provider.dart
│   │   └── navigation_provider.dart
│   └── presentation/
│       ├── screens/                        # App screens
│       │   ├── setup_cash/
│       │   ├── dashboard/
│       │   ├── add_account/
│       │   ├── add_record/
│       │   ├── statistics/
│       │   └── all_transactions/
│       └── shared/
│           └── bottom_navigation/          # Bottom nav bar
```

## Database Schema

### Tables

**users**
- `id`: INTEGER PRIMARY KEY
- `first_name`: TEXT
- `last_name`: TEXT
- `email`: TEXT
- `password`: TEXT

**accounts**
- `id`: INTEGER PRIMARY KEY
- `user_id`: INTEGER (FK → users.id)
- `account_name`: TEXT
- `balance`: REAL
- `type`: TEXT ('cash' | 'bank')

**categories**
- `id`: INTEGER PRIMARY KEY
- `name`: TEXT (UNIQUE)

**transactions**
- `id`: INTEGER PRIMARY KEY
- `account_id`: INTEGER (FK → accounts.id)
- `category_id`: INTEGER (FK → categories.id)
- `type`: TEXT ('expense' | 'income')
- `amount`: REAL
- `date`: TEXT (ISO 8601)
- `description`: TEXT

### Default Data
- **User**: John Doe (id: 1)
- **Categories**: Food & Drinks, Shopping, Transportation, Others

## Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.11.0 or higher
  ```bash
  flutter --version
  ```
- **Xcode** (for iOS development)
- **Android Studio** (for Android development)

### Installation

1. **Navigate to project directory**
   ```bash
   cd spender_bender
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify installation**
   ```bash
   flutter doctor
   ```

### Running the App

#### iOS
```bash
# Run on iOS Simulator
flutter run

# Run on specific iOS device
flutter devices
flutter run -d <device-id>

# Build for release
flutter build ios
```

#### Android
```bash
# Run on Android Emulator
flutter run

# Run on specific Android device
flutter devices
flutter run -d <device-id>

# Build APK
flutter build apk

# Build App Bundle (for Play Store)
flutter build appbundle
```

### Development Commands

```bash
# Clean build cache
flutter clean

# Analyze code
flutter analyze

# Run tests
flutter test

# Check for outdated dependencies
flutter pub outdated

# Hot reload (during development)
# Press 'r' in terminal while app is running

# Hot restart
# Press 'R' in terminal while app is running
```

## Configuration

### App Constants
Edit `lib/core/constants/app_constants.dart` to modify:
- Default currency (currently: BDT)
- Default user information
- Default categories
- Time period options

### Theme
Edit `lib/core/constants/theme_constants.dart` to customize:
- Color scheme (background, primary, surface, etc.)
- Text styles
- Component themes (buttons, cards, inputs)

## Key Features Implementation

### Offline-First Architecture
- All data stored locally using SQLite
- No internet connection required
- Instant data access and updates

### State Management Pattern
```dart
// Using Riverpod Notifier pattern
final accountsProvider = NotifierProvider<AccountsNotifier, AsyncValue<List<Account>>>(() {
  return AccountsNotifier();
});

// Consuming in widgets
final accountsAsync = ref.watch(accountsProvider);
accountsAsync.when(
  data: (accounts) => /* Show UI */,
  loading: () => CircularProgressIndicator(),
  error: (e, _) => Text('Error: $e'),
);
```

### Transaction Flow
1. User creates transaction (expense/income)
2. Account balance is automatically updated
3. Transaction is saved to database
4. Dashboard refreshes to show updates
5. User is navigated back to dashboard

## Troubleshooting

### Common Issues

**Issue**: App crashes on first launch
- **Solution**: Delete app and reinstall, or run `flutter clean`

**Issue**: Hot reload not working
- **Solution**: Do a hot restart (R) or full restart

**Issue**: Database errors
- **Solution**: Uninstall app to clear database, then reinstall

**Issue**: Build errors after updating dependencies
- **Solution**:
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```

## Future Enhancements

- [ ] Balance trend chart visualization (fl_chart integration)
- [ ] Data export (CSV, PDF)
- [ ] Backup and restore functionality
- [ ] Recurring transactions
- [ ] Budget tracking and goals
- [ ] Multi-currency support
- [ ] Cloud sync (optional)
- [ ] Biometric authentication
- [ ] Transaction search and filters
- [ ] Custom transaction categories with icons

## License

This project is for educational purposes.

## Contributing

This is a personal project, but suggestions and feedback are welcome!

## Support

For issues or questions, please refer to:
- Flutter Documentation: https://docs.flutter.dev/
- Riverpod Documentation: https://riverpod.dev/

---

**Built with ❤️ using Flutter**
