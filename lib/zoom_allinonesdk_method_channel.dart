import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zoom_allinonesdk/constants/zoom_constants.dart';
import 'package:zoom_allinonesdk/data/models/accesstokenmodel.dart';
import 'package:zoom_allinonesdk/data/providers/zoom_provider.dart';
import 'package:zoom_allinonesdk/data/repositories/zoom_repository.dart';
import 'data/models/meeting_options.dart';
import 'data/models/zoom_options.dart';
import 'data/util/jwt_generator.dart';
import 'data/util/zoom_error.dart';
import 'zoom_allinonesdk_platform_interface.dart';

class MethodChannelZoomAllInOneSdk extends ZoomAllInOneSdkPlatform {
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('zoom_allinonesdk');

  final jwtGenerator = JwtGenerator();

  @override
  Future<List> initZoom({required ZoomOptions options}) async {
    try {
      String jwtSignature = jwtGenerator.generate(
          key: options.clientId ?? "", secret: options.clientSecert ?? "");
      final optionsMap = <String, dynamic>{
        ZoomConstants.JWT_TOKEN: jwtSignature,
        ZoomConstants.DOMAIN: options.domain,
      };

      // Invoke method and handle the result
      final version = await methodChannel
          .invokeMethod<List>(ZoomConstants.INIT_ZOOM, optionsMap)
          .then<List>((List? value) => value ?? List.empty());

      return version;
    } catch (e) {
      throw ZoomError('Error joining meeting: $e');
    }
  }

  @override
  Future<bool> joinMeeting({required MeetingOptions meetingOptions}) async {
    try {
      // Prepare options map
      final options = <String, dynamic>{
        ZoomConstants.USER_ID: meetingOptions.userId??'',
        ZoomConstants.MEETING_ID: meetingOptions.meetingId??'',
        ZoomConstants.MEETING_PASSWORD: meetingOptions.meetingPassword??'',
        ZoomConstants.DISABLE_DIAL_IN: meetingOptions.noDialInViaPhone??'',
        ZoomConstants.DISABLE_DRIVE: meetingOptions.noDrivingMode??'',
        ZoomConstants.DISABLE_INVITE: meetingOptions.noInvite??'',
        ZoomConstants.DISABLE_SHARE: meetingOptions.noShare??'',
        ZoomConstants.DISABLE_TITLEBAR: meetingOptions.noTitlebar??'',
        ZoomConstants.NO_DISCONNECT_AUDIO: meetingOptions.noDisconnectAudio??'',
        ZoomConstants.VIEW_OPTIONS: meetingOptions.viewOptions??'',
        ZoomConstants.NO_AUDIO: meetingOptions.noAudio??'',
      };

      // Invoke method and handle the result
      final result = await methodChannel.invokeMethod<bool>(
        ZoomConstants.JOIN_MEETING,
        options,
      );

      // Use null coalescing operator to return false if null
      return result ?? false;
    } catch (e) {
      throw ZoomError('Error joining meeting: $e');
    }
  }

  @override
  Future<List> startMeeting({
    required String clientId,
    required String clientSecret,
    required String accountId,
    required MeetingOptions meetingOptions,
  }) async {
    try {
      // Prepare options map
      final options = <String, dynamic>{
        ZoomConstants.MEETING_ID: meetingOptions.meetingId??'',
        ZoomConstants.USER_ID: meetingOptions.userId??'',
        ZoomConstants.DISPLAY_NAME: meetingOptions.displayName??'',
        ZoomConstants.USER_PASSWORD: meetingOptions.userPassword??'',
        ZoomConstants.DISABLE_DIAL_IN: meetingOptions.noDialInViaPhone??'',
        ZoomConstants.DISABLE_DRIVE: meetingOptions.noDrivingMode??'',
        ZoomConstants.DISABLE_INVITE: meetingOptions.noInvite??'',
        ZoomConstants.DISABLE_SHARE: meetingOptions.noShare??'',
        ZoomConstants.DISABLE_TITLEBAR: meetingOptions.noTitlebar??'',
        ZoomConstants.VIEW_OPTIONS: meetingOptions.viewOptions??'',
        ZoomConstants.NO_DISCONNECT_AUDIO: meetingOptions.noDisconnectAudio??'',
        ZoomConstants.NO_AUDIO: meetingOptions.noAudio??'',
        ZoomConstants.USER_TYPE: meetingOptions.userType??'',
      };

      // Instantiate ZoomProvider and ZoomRepository
      final ZoomProvider zoomProvider = ZoomProvider();
      final ZoomRepository repository =
          ZoomRepository(zoomProvider: zoomProvider);

      // Fetch access token
      final AccessTokenModel accessTokenResponse =
          await repository.fetchAccesstoken(
        accountId: accountId,
        clientId: clientId,
        clientSecret: clientSecret,
      );

      // Fetch zak token
      final String zakTokenResponse = await repository.fetchZaktoken(
        clientId: clientId,
        clientSecret: clientSecret,
        accessToken: accessTokenResponse.accessToken,
      );

      // Add zak token to options map
      options
          .addAll(<String, dynamic>{ZoomConstants.ZAK_TOKEN: zakTokenResponse});

      print("zak $zakTokenResponse");

      // Invoke method and handle the result
      final version = await methodChannel.invokeMethod<List>(
        ZoomConstants.START_MEETING,
        options,
      );

      // Use null coalescing operator to return an empty list if null
      return version ?? [];
    } catch (e) {
      // Throw a custom error to provide a meaningful error message
      throw ZoomError('Error starting meeting: $e');
    }
  }
}
