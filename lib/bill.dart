class Bill {
  final String description;
  final double amount;
  final DateTime date;

  Bill({
    required this.description,
    required this.amount,
    required this.date,
  });

  // Convert a Bill into a Map. The keys must correspond to the names of the
  // fields in the bill.
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  // Extract a Bill object from a Map.
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      description: json['description'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }
}
