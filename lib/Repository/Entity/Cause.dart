import 'dart:convert';

class Cause {
  int? id;
  String? cause;
  Cause({
    this.id,
    this.cause,
  });

  Cause copyWith({
    int? id,
    String? cause,
  }) {
    return Cause(
      id: id ?? this.id,
      cause: cause ?? this.cause,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cause': cause,
    };
  }

  factory Cause.fromMap(Map<String, dynamic> map) {
    return Cause(
      id: map['id'],
      cause: map['cause'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Cause.fromJson(String source) => Cause.fromMap(json.decode(source));

  @override
  String toString() => 'Cause(id: $id, cause: $cause)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cause && other.id == id && other.cause == cause;
  }

  @override
  int get hashCode => id.hashCode ^ cause.hashCode;
}
