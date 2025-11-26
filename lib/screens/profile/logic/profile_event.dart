import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;
  final String phone;
  
  UpdateProfileEvent({
    required this.name,
    required this.email,
    required this.phone,
  });
  
  @override
  List<Object?> get props => [name, email, phone];
}