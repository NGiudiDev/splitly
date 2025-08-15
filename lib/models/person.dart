class Person {
  String name;

  Person({
      required this.name,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
      name: json["name"],
  );

  Map<String, dynamic> toJson() => {
      "name": name,
  };

  Person copyWith({
    String? name,
  }) {
    return Person(
      name: name ?? this.name,
    );
  }
}
