// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      id: json['ID'] as String,
      firstName: json['FirstName'] as String,
      lastName: json['LastName'] as String,
      phoneNumber: json['PhoneNumber'] as String,
      profilePic: json['ProfilePic'] as String,
      role: json['Role'] as String,
      createdAt: json['CreatedAt'] == null
          ? null
          : DateTime.parse(json['CreatedAt'] as String),
      updatedAt: json['UpdatedAt'] == null
          ? null
          : DateTime.parse(json['UpdatedAt'] as String));
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'ID': instance.id,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'PhoneNumber': instance.phoneNumber,
      'ProfilePic': instance.profilePic,
      'Role': instance.role,
      'CreatedAtt': instance.createdAt?.toIso8601String(),
      'UpdatedAt': instance.updatedAt?.toIso8601String()
    };
