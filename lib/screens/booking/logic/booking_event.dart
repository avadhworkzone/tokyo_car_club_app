import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBookingsEvent extends BookingEvent {}

class FilterBookingsEvent extends BookingEvent {
  final String status;
  FilterBookingsEvent(this.status);
  
  @override
  List<Object?> get props => [status];
}