import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_list_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const GetNotifications(limit: 10));
  }

  Future<void> _onRefresh() async {
    context.read<NotificationBloc>().add(const GetNotifications(limit: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(child: Text('No notifications yet'));
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top:16, bottom: 100, left: 16, right: 16),
                  child: Column(
                    children: List.generate(state.notifications.length, (index) {
                      return NotificationListTile(
                        notification: state.notifications[index],
                      );
                    }),
                  ),
                ),
              );
              // return ListView.builder(
              //   padding: const EdgeInsets.all(16),
              //   itemCount: state.notifications.length,
              //   itemBuilder: (context, index) {
              //     return NotificationListTile(
              //       notification: state.notifications[index],
              //     );
              //   },
              // );
            } else if (state is NotificationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _onRefresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Start fetching notifications...'));
          },
        ),
      ),
    );
  }
}
