import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<LoadBookingsEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        final allBookings = [
          {
            'id': 'TCC001',
            'carName': 'Toyota Supra',
            'carImage': 'assets/images/car.png',
            'startDate': '2024-01-15',
            'endDate': '2024-01-18',
            'status': 'upcoming',
            'location': 'Tokyo Station',
            'price': '₹50,000'
          },
          {
            'id': 'TCC002',
            'carName': 'Nissan GTR',
            'carImage': 'assets/images/car.png',
            'startDate': '2024-01-10',
            'endDate': '2024-01-12',
            'status': 'completed',
            'location': 'Shibuya',
            'price': '₹75,000'
          },
        ];
        
        final upcomingBookings = allBookings
            .where((booking) => booking['status'] == 'upcoming')
            .toList();
        
        emit(BookingLoaded(upcomingBookings, 'upcoming'));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    });

    on<FilterBookingsEvent>((event, emit) async {
      if (state is BookingLoaded) {
        final currentState = state as BookingLoaded;
        final allBookings = [
          {
            'id': 'TCC001',
            'carName': 'Toyota Supra',
            'carImage': 'assets/images/car.png',
            'startDate': '2024-01-15',
            'endDate': '2024-01-18',
            'status': 'upcoming',
            'location': 'Tokyo Station',
            'price': '₹50,000'
          },
          {
            'id': 'TCC002',
            'carName': 'Nissan GTR',
            'carImage': 'assets/images/car.png',
            'startDate': '2024-01-10',
            'endDate': '2024-01-12',
            'status': 'completed',
            'location': 'Shibuya',
            'price': '₹75,000'
          },
        ];
        
        final filteredBookings = allBookings
            .where((booking) => booking['status'] == event.status)
            .toList();
        
        emit(BookingLoaded(filteredBookings, event.status));
      }
    });
  }
}