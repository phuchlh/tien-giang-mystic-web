import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserMetaModel extends Equatable {
  final String? avatarUrl;
  final String? email;
  final bool? emailVerified;
  final String? fullName;
  final String? iss;
  final String? name;
  final bool? phoneVerified;
  final String? picture;
  final String? providerId;
  final String? sub;

  const UserMetaModel({
    this.avatarUrl,
    this.email,
    this.emailVerified,
    this.fullName,
    this.iss,
    this.name,
    this.phoneVerified,
    this.picture,
    this.providerId,
    this.sub,
  });

  factory UserMetaModel.fromMap(Map<String, dynamic> map) {
    return UserMetaModel(
      avatarUrl: map['avatar_url'],
      email: map['email'],
      emailVerified: map['email_verified'],
      fullName: map['full_name'],
      iss: map['iss'],
      name: map['name'],
      phoneVerified: map['phone_verified'],
      picture: map['picture'],
      providerId: map['provider_id'],
      sub: map['sub'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatar_url': avatarUrl,
      'email': email,
      'email_verified': emailVerified,
      'full_name': fullName,
      'iss': iss,
      'name': name,
      'phone_verified': phoneVerified,
      'picture': picture,
      'provider_id': providerId,
      'sub': sub,
    };
  }

  // to json
  String toJson() => json.encode(toMap());

  // from json
  factory UserMetaModel.fromJson(String source) =>
      UserMetaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserMeta(avatarUrl: $avatarUrl, email: $email, emailVerified: $emailVerified, fullName: $fullName, iss: $iss, name: $name, phoneVerified: $phoneVerified, picture: $picture, providerId: $providerId, sub: $sub)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserMetaModel &&
        other.avatarUrl == avatarUrl &&
        other.email == email &&
        other.emailVerified == emailVerified &&
        other.fullName == fullName &&
        other.iss == iss &&
        other.name == name &&
        other.phoneVerified == phoneVerified &&
        other.picture == picture &&
        other.providerId == providerId &&
        other.sub == sub;
  }

  @override
  int get hashCode {
    return avatarUrl.hashCode ^
        email.hashCode ^
        emailVerified.hashCode ^
        fullName.hashCode ^
        iss.hashCode ^
        name.hashCode ^
        phoneVerified.hashCode ^
        picture.hashCode ^
        providerId.hashCode ^
        sub.hashCode;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        avatarUrl,
        email,
        emailVerified,
        fullName,
        iss,
        name,
        phoneVerified,
        picture,
        providerId,
        sub,
      ];
}
