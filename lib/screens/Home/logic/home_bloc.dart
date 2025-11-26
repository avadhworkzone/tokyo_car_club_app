import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadCarsEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        // Mock data - replace with actual API call
        await Future.delayed(const Duration(seconds: 1));
        final cars = [
          {'name': 'Toyota Supra', 'price': '₹50,00,000'},
          {'name': 'Nissan GTR', 'price': '₹75,00,000'},
          {'name': 'Honda NSX', 'price': '₹1,20,00,000'},
        ];
        emit(HomeLoaded(cars));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

    on<SearchCarsEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        // Mock search - replace with actual search logic
        final allCars = [
          {'name': 'Toyota Supra', 'price': '₹50,00,000'},
          {'name': 'Nissan GTR', 'price': '₹75,00,000'},
          {'name': 'Honda NSX', 'price': '₹1,20,00,000'},
        ];
        final filteredCars = allCars.where((car) => 
          car['name']!.toLowerCase().contains(event.query.toLowerCase())
        ).toList();
        emit(HomeLoaded(filteredCars));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}