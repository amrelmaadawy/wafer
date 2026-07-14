import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/notifications_cubit.dart';
import '../views/notifications_view.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (context) => sl<NotificationsCubit>()..getNotifications(forceRefresh: false),
      child: const NotificationsView(),
    );
  }
}
