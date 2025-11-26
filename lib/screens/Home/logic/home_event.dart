import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCarsEvent extends HomeEvent {}

class SearchCarsEvent extends HomeEvent {
  final String query;
  SearchCarsEvent(this.query);
  
  @override
  List<Object?> get props => [query];
}