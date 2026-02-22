class BalanceDataPoint {
  final DateTime date;
  final double balance;
  final String? label;

  BalanceDataPoint({
    required this.date,
    required this.balance,
    this.label,
  });
}
