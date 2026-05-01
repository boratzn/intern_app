import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationService {
  void init() {
    // Check if App ID is provided in .env, otherwise skip initialization
    // Required to prevent crash during missing .env key
    final appId = dotenv.env['ONESIGNAL_APP_ID'];
    if (appId == null || appId.isEmpty) {
      debugPrint('OneSignal App ID is not configured.');
      return;
    }

    // Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(appId);

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }

  /// Push Notification using OneSignal REST API.
  /// (Since server-less, we call REST API directly using REST API KEY)
  Future<void> sendNotificationToUser({
    required String targetUserId,
    required String title,
    required String message,
  }) async {
    final appId = dotenv.env['ONESIGNAL_APP_ID'];
    final restKey = dotenv.env['ONESIGNAL_REST_KEY'];

    if (appId == null || appId.isEmpty || restKey == null || restKey.isEmpty) {
      debugPrint(
        'OneSignal config missing — APP_ID: ${appId == null ? "null" : (appId.isEmpty ? "empty" : "ok")}'
        ' | REST_KEY: ${restKey == null ? "null" : (restKey.isEmpty ? "empty" : "ok")}',
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Key $restKey',
        },
        body: jsonEncode({
          'app_id': appId,
          // We assume the user logs in and calls OneSignal.login(userId)
          'include_external_user_ids': [targetUserId],
          'headings': {'en': title, 'tr': title},
          'contents': {'en': message, 'tr': message},
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Notification sent: ${response.body}');
      } else {
        debugPrint(
          'Error sending notification: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Exception sending notification: $e');
    }
  }

  /// Sets the external user ID for the current logged-in user so they can receive targeted push notifications.
  void loginUser(String userId) {
    if (dotenv.env['ONESIGNAL_APP_ID'] != null) {
      OneSignal.login(userId);
    }
  }

  void logoutUser() {
    if (dotenv.env['ONESIGNAL_APP_ID'] != null) {
      OneSignal.logout();
    }
  }
}
