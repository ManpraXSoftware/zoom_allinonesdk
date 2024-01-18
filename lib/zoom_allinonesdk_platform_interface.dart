import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'data/models/meeting_options.dart';
import 'data/models/zoom_options.dart';
import 'zoom_allinonesdk_method_channel.dart';

// The abstract class that defines the common methods for the plugin.
abstract class ZoomAllInOneSdkPlatform extends PlatformInterface {
  // The constructor that checks if the plugin has been initialized properly.
  ZoomAllInOneSdkPlatform() : super(token: _token);

  // The token that represents the plugin.
  static final Object _token = Object();

  // The default instance of the plugin that uses the MethodChannel implementation.
  static ZoomAllInOneSdkPlatform _instance = MethodChannelZoomAllInOneSdk();

  // The getter and setter for the instance of the plugin.
  static ZoomAllInOneSdkPlatform get instance => _instance;
  static set instance(ZoomAllInOneSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZoomAllInOneSdkPlatform] when
  /// they register themselves.

  /// Flutter Zoom SDK Initialization function
  Future<List> initZoom({required ZoomOptions options}) async {
    throw UnimplementedError('initZoom() has not been implemented.');
  }

  /// Flutter Zoom SDK Start Meeting function
  Future<List> startMeeting(
      {required String clientId,
      required String clientSecret,
      required String accountId,
      required MeetingOptions meetingOptions}) async {
    throw UnimplementedError('startMeetingLogin() has not been implemented.');
  }

  /// Flutter Zoom SDK Join Meeting function
  Future<bool> joinMeeting({required MeetingOptions meetingOptions}) async {
    throw UnimplementedError('joinMeeting() has not been implemented.');
  }
}
