// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['ID'] as String,
      json['UserName'] as String,
      json['PhoneNumber'] as String,
      json['Category'] as String,
      json['CreatedAt'] == null
          ? null
          : DateTime.parse(json['CreatedAt'] as String),
      json['UpdatedAt'] == null
          ? null
          : DateTime.parse(json['UpdatedAt'] as String));
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'ID': instance.id,
      'UserName': instance.userName,
      'PhoneNumber': instance.phoneNumber,
      'Category': instance.category,
      'CreatedAt': instance.createdAt?.toIso8601String(),
      'UpdatedAt': instance.updatedAt?.toIso8601String()
    };
