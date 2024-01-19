import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zoom_allinonesdk/data/models/meeting_options.dart';
import 'data/models/accesstokenmodel.dart';
import 'data/models/zoom_options.dart';
import 'data/providers/zoom_provider.dart';
import 'data/repositories/zoom_repository.dart';
import 'data/util/jwt_generator.dart';
import 'webSupport/zoom_js.dart';
import 'zoom_allinonesdk_platform_interface.dart';

class FlutterZoomWeb extends ZoomAllInOneSdkPlatform {
  final jwtGenerator = JwtGenerator();

  static void registerWith(Registrar registrar) {
    ZoomAllInOneSdkPlatform.instance = FlutterZoomWeb();
  }

  late ZoomOptions zoomoptions;

  @override
  Future<List<dynamic>> initZoom({required ZoomOptions options}) async {
    final Completer<List<dynamic>> completer = Completer();

    zoomoptions = options;

    ZoomMtg.setZoomJSLib('https://source.zoom.us/2.18.0/lib', '/av');
    ZoomMtg.preLoadWasm();
    ZoomMtg.prepareWebSDK();

    ZoomMtg.i18n.load(options.language);
    ZoomMtg.init(InitParams(
      leaveUrl: '/index.html',
      success: allowInterop((res) {
        var zr = window.document.getElementById("zmmtg-root");
        querySelector('body')?.append(zr!);

        var div = window.document.getElementById("aria-notify-area");
        querySelector('body')?.append(div!);
        completer.complete([200, 0]);
      }),
      error: allowInterop((res) {
        completer.completeError([1, 0]);
      }),
      // URL for web participants to leave the meeting
    ));
    try {
      return await completer.future;
    } catch (e) {
      return [1, 0];
    }
  }

  /// Start Meeting Function for Zoom Web
  @override
  Future<List> startMeeting(
      {required String clientId,
      required String clientSecret,
      required String accountId,
      required MeetingOptions meetingOptions}) async {
    final Completer<List> completer = Completer();

    String jwtSignature = jwtGenerator.generate(
        key: zoomoptions.clientId ?? "",
        secret: zoomoptions.clientSecert ?? "",
        meetingId: int.tryParse(meetingOptions.meetingId ?? "") ?? 0,
        role: meetingOptions.userType ?? "1");

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

    ZoomMtg.join(JoinParams(
        meetingNumber: meetingOptions.meetingId,
        userName: meetingOptions.displayName ?? meetingOptions.userId,
        signature: jwtSignature,
        sdkKey: zoomoptions.clientId,
        passWord: meetingOptions.meetingPassword,
        zak: zakTokenResponse,
        success: allowInterop((var res) {
          completer.complete(["MEETING STATUS", "SUCCESS"]);
        }),
        error: allowInterop((var res) {
          completer.complete(["MEETING STATUS", "FAILED"]);
        })));
    return ["MEETING STATUS", "Working"];
  }

  /// Join Meeting Function for Zoom Web
  @override
  Future<bool> joinMeeting({required MeetingOptions meetingOptions}) async {
    final Completer<bool> completer = Completer();
    String jwtSignature = jwtGenerator.generate(
        key: zoomoptions.clientId ?? "",
        secret: zoomoptions.clientSecert ?? "",
        meetingId: int.tryParse(meetingOptions.meetingId ?? "") ?? 0,
        role: meetingOptions.userType ?? "0");
    ZoomMtg.join(JoinParams(
        meetingNumber: meetingOptions.meetingId,
        userName: meetingOptions.displayName ?? meetingOptions.userId,
        signature: jwtSignature,
        sdkKey: zoomoptions.clientId,
        passWord: meetingOptions.meetingPassword,
        success: allowInterop((var res) {
          completer.complete(true);
        }),
        error: allowInterop((var res) {
          completer.complete(false);
        })));
    return completer.future;
  }
}
