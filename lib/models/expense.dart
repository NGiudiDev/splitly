import 'person.dart';

class Expense {
  final Person person;
  final double amount;

  Expense({
    required this.person,
    required this.amount
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    person: Person.fromJson(json["person"]),
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "person": person.toJson(),
    "amount": amount,
  };

  Expense copyWith({
    Person? person,
    double? amount,
  }) {
    return Expense(
      person: person ?? this.person,
      amount: amount ?? this.amount,
    );
  }
}
