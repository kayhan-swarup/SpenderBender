class Account {
  final int? id;
  final int userId;
  final String accountName;
  final double balance;
  final String type;

  Account({
    this.id,
    required this.userId,
    required this.accountName,
    required this.balance,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'account_name': accountName,
      'balance': balance,
      'type': type,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      accountName: map['account_name'] as String,
      balance: (map['balance'] as num).toDouble(),
      type: map['type'] as String,
    );
  }

  Account copyWith({
    int? id,
    int? userId,
    String? accountName,
    double? balance,
    String? type,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountName: accountName ?? this.accountName,
      balance: balance ?? this.balance,
      type: type ?? this.type,
    );
  }
}
