import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Habit {
  final String id;
  final String name;
  final Color positiveColor;
  final Color negativeColor;

  Habit({
    String? id,
    required this.name,
    required this.positiveColor,
    required this.negativeColor,
  }) : id = id ?? const Uuid().v4();

  Habit copyWith({String? name, Color? positiveColor, Color? negativeColor}) {
    return Habit(
      id: this.id,
      name: name ?? this.name,
      positiveColor: positiveColor ?? this.positiveColor,
      negativeColor: negativeColor ?? this.negativeColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'positiveColor': positiveColor.value,
      'negativeColor': negativeColor.value,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      positiveColor: Color(map['positiveColor']),
      negativeColor: Color(map['negativeColor']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));
}
