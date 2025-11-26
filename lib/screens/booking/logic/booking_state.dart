import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Map<String, dynamic>> bookings;
  final String currentFilter;
  
  BookingLoaded(this.bookings, this.currentFilter);
  
  @override
  List<Object?> get props => [bookings, currentFilter];
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
  
  @override
  List<Object?> get props => [message];
}