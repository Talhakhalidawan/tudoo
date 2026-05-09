import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Habit {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final String frequency; // 'Daily', 'Weekly', 'Custom'
  final int targetValue;
  final DateTime createdAt;

  Habit({
    String? id,
    required this.name,
    required this.icon,
    required this.color,
    this.frequency = 'Daily',
    this.targetValue = 1,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Habit copyWith({
    String? name,
    String? icon,
    Color? color,
    String? frequency,
    int? targetValue,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      targetValue: targetValue ?? this.targetValue,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color.value,
      'frequency': frequency,
      'targetValue': targetValue,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      icon: map['icon'] ?? 'book',
      color: map['color'] != null ? Color(map['color']) : Colors.greenAccent,
      frequency: map['frequency'] ?? 'Daily',
      targetValue: map['targetValue'] ?? 1,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());
  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));
}
