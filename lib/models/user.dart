import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  final String uid;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String? photoUrl;
  
  @HiveField(4)
  final String? phoneNumber;
  
  @HiveField(5)
  final List<UserAddress> addresses;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    this.phoneNumber,
    List<UserAddress>? addresses,
  }) : addresses = addresses ?? [];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'addresses': addresses.map((addr) => addr.toMap()).toList(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
      addresses: (map['addresses'] as List<dynamic>?)
          ?.map((addr) => UserAddress.fromMap(addr))
          .toList() ?? [],
    );
  }

  UserProfile copyWith({
    String? name,
    String? photoUrl,
    String? phoneNumber,
    List<UserAddress>? addresses,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addresses: addresses ?? this.addresses,
    );
  }
}

@HiveType(typeId: 1)
class UserAddress {
  @HiveField(0)
  final String street;
  
  @HiveField(1)
  final String city;
  
  @HiveField(2)
  final String state;
  
  @HiveField(3)
  final String zipCode;
  
  @HiveField(4)
  final String country;

  UserAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    return UserAddress(
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'] ?? '',
    );
  }
} 