import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'user.g.dart';

@immutable
class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String profilePic;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.profilePic,
      this.role,
      this.createdAt,
      this.updatedAt});

  @override
  List<Object> get props => [
        id,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.profilePic,
        role,
        createdAt,
        updatedAt
      ];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
