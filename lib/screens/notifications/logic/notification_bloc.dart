import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotificationsEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        final notifications = [
          {
            'id': 'N001',
            'carName': 'BMW M4 Competition',
            'message': 'Booking confirmed for tomorrow',
            'timeAgo': '2 hours ago',
            'isRead': false,
          },
          {
            'id': 'N002',
            'carName': 'Mercedes AMG GT',
            'message': 'Payment successful',
            'timeAgo': '5 hours ago',
            'isRead': false,
          },
          {
            'id': 'N003',
            'carName': 'Audi R8 V10',
            'message': 'Booking completed successfully',
            'timeAgo': '1 day ago',
            'isRead': true,
          },
          {
            'id': 'N004',
            'carName': 'Toyota Supra',
            'message': 'Special offer available',
            'timeAgo': '2 days ago',
            'isRead': true,
          },
        ];
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<MarkAsReadEvent>((event, emit) async {
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        final updatedNotifications = currentState.notifications.map((notification) {
          if (notification['id'] == event.notificationId) {
            return {...notification, 'isRead': true};
          }
          return notification;
        }).toList();
        emit(NotificationLoaded(updatedNotifications));
      }
    });
  }
}