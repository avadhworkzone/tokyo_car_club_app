import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import 'package:tokyo_car_club/core/theme/app_theme.dart';
import 'package:tokyo_car_club/core/widgets/app_text.dart';
import 'logic/notification_bloc.dart';
import 'logic/notification_event.dart';
import 'logic/notification_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc()..add(LoadNotificationsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          title: Text(
            StringUtils.t('notifications'),
            style: TextStyle(color: AppColors.textPrimary(context)),
          ),
          backgroundColor: AppColors.background(context),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(13.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: AppColors.white,
                child: Icon(Icons.arrow_back, color: AppColors.black, size: 20),
              ),
            ),
          ),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError) {
              return Center(
                child: AppText(
                  state.message,
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }

            if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: AppColors.textTertiary(context),
                      ),
                      const SizedBox(height: 16),
                      AppText(
                        StringUtils.t('no_notifications'),
                        style: TextStyle(
                          color: AppColors.textTertiary(context),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _buildNotificationItem(context, notification);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isRead) {
              context.read<NotificationBloc>().add(
                MarkAsReadEvent(notification['id']),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground(context),
              borderRadius: BorderRadius.circular(12),
              border: isRead ? null : Border.all(
                color: AppColors.blueAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Blue Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: AppColors.blueAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car Name
                      AppText(
                        notification['carName'],
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: 14,
                          fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Booking Update Message
                      AppText(
                        notification['message'],
                        style: TextStyle(
                          color: isRead ? AppColors.textTertiary(context) : AppColors.textPrimary(context),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Time Ago
                      AppText(
                        notification['timeAgo'],
                        style: TextStyle(
                          color: AppColors.textTertiary(context),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Unread Indicator
                if (!isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}