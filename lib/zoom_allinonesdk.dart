import 'data/models/meeting_options.dart';
import 'data/models/zoom_options.dart';
import 'zoom_allinonesdk_platform_interface.dart';
export 'data/models/zoom_options.dart';
export 'data/models/meeting_options.dart';

class ZoomAllInOneSdk {
  ZoomAllInOneSdk({ZoomAllInOneSdkPlatform? platform})
      : _platform = platform ?? ZoomAllInOneSdkPlatform.instance;

  final ZoomAllInOneSdkPlatform _platform;

  Future<List> initZoom({
    required ZoomOptions zoomOptions,
  }) {
    return _platform.initZoom(options: zoomOptions);
  }

  Future<bool> joinMeting({required MeetingOptions meetingOptions}) {
    return _platform.joinMeeting(meetingOptions: meetingOptions);
  }

  Future<List> startMeeting(
      {required String clientId,
      required String clientSecret,
      required String accountId,
      required MeetingOptions meetingOptions}) {
    return _platform.startMeeting(
        accountId: accountId,
        clientId: clientId,
        clientSecret: clientSecret,
        meetingOptions: meetingOptions);
  }
}
