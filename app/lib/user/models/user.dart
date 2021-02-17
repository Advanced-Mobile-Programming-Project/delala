import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'user.g.dart';

@immutable
class User extends Equatable {
  final String id;
  final String userName;
  final String phoneNumber;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  User(this.id, this.userName, this.phoneNumber, this.category, this.createdAt,
      this.updatedAt);

  factory User.forEvent({userName, phoneNumber, category}) {
    return User(null, userName, phoneNumber, category, null, null);
  }

  @override
  List<Object> get props =>
      [id, userName, phoneNumber, category, createdAt, updatedAt];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
