class AppConstants {
  static const String appName = 'SpenderBender';
  static const String dbName = 'spender_bender.db';
  static const int dbVersion = 1;

  static const String currency = 'BDT';

  static const List<String> defaultCategories = [
    'Food & Drinks',
    'Shopping',
    'Transportation',
    'Others',
  ];

  static const String defaultUserFirstName = 'John';
  static const String defaultUserLastName = 'Doe';
  static const String defaultUserEmail = 'john@example.com';
  static const String defaultUserPassword = 'password123';
  static const int defaultUserId = 1;

  static const List<String> timePeriods = [
    '7 days',
    '30 days',
    '12 weeks',
    '6 months',
    '1 year',
  ];

  static int periodToDays(String period) {
    switch (period) {
      case '7 days':
        return 7;
      case '30 days':
        return 30;
      case '12 weeks':
        return 84;
      case '6 months':
        return 180;
      case '1 year':
        return 365;
      default:
        return 30;
    }
  }
}
