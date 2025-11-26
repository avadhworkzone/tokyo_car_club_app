import 'package:flutter_bloc/flutter_bloc.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreInitial()) {
    on<LoadExploreData>(_onLoadExploreData);
    on<SelectCarBrand>(_onSelectCarBrand);
    on<SelectCarType>(_onSelectCarType);
    on<SelectLocation>(_onSelectLocation);
  }

  void _onLoadExploreData(LoadExploreData event, Emitter<ExploreState> emit) async {
    emit(ExploreLoading());
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    emit(ExploreLoaded(
      carBrands: ['BMW', 'Mercedes', 'Audi', 'Toyota', 'Honda', 'Nissan'],
      carTypes: [
        {'name': 'SUV', 'icon': 'suv', 'count': 45},
        {'name': 'Sedan', 'icon': 'sedan', 'count': 32},
        {'name': 'Luxury', 'icon': 'luxury', 'count': 28},
        {'name': 'Electric', 'icon': 'electric', 'count': 15},
      ],
      locations: [
        {'name': 'Tokyo Station', 'cars': '120+ cars'},
        {'name': 'Shibuya', 'cars': '85+ cars'},
        {'name': 'Harajuku', 'cars': '95+ cars'},
      ],
    ));
  }

  void _onSelectCarBrand(SelectCarBrand event, Emitter<ExploreState> emit) {
    if (state is ExploreLoaded) {
      final currentState = state as ExploreLoaded;
      emit(currentState.copyWith(selectedBrand: event.brand));
    }
  }

  void _onSelectCarType(SelectCarType event, Emitter<ExploreState> emit) {
    if (state is ExploreLoaded) {
      final currentState = state as ExploreLoaded;
      emit(currentState.copyWith(selectedType: event.type));
    }
  }

  void _onSelectLocation(SelectLocation event, Emitter<ExploreState> emit) {
    if (state is ExploreLoaded) {
      final currentState = state as ExploreLoaded;
      emit(currentState.copyWith(selectedLocation: event.location));
    }
  }
}