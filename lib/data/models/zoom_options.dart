/// Basic Zoom Options required for plugin (WEB, iOS, Android)
class ZoomOptions {
  /// Domain For Zoom Web
  String? domain;

  String? clientId;

  String? clientSecert;

  /// --JWT token for web / iOS / Android
  String? jwtSignature;

  /// --Language for web
  String? language;

  /// --Meeting Header for web
  bool? showMeetingHeader;

  /// --Disable Invite Option for web
  bool? disableInvite;

  /// --Disable CallOut Option for web
  bool? disableCallOut;

  /// --Disable Record Option for web
  bool? disableRecord;

  /// --Disable Join Audio for web
  bool? disableJoinAudio;

  /// -- Allow Pannel Always Open for web
  bool? audioPanelAlwaysOpen;

  /// --Backup URL for web
  String? backupUrl;

  ZoomOptions(
      {required this.domain,
      required this.clientId,
      required this.clientSecert,
      this.jwtSignature,
      this.language = "en-US",
      this.showMeetingHeader = true,
      this.disableInvite = false,
      this.disableCallOut = false,
      this.disableRecord = false,
      this.disableJoinAudio = false,
      this.audioPanelAlwaysOpen = false,
      this.backupUrl = ''});
}
