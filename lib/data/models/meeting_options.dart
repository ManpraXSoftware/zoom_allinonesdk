class MeetingOptions {
  /// Username For Join Meeting & Host Email For Start Meeting
  String? userId;

  /// Host Password For Start Meeting
  String? userPassword;

  /// Display Name
  String? displayName;

  /// Personal meeting id for start meeting required
  String? meetingId;

  /// Personal meeting passcode for start meeting required
  String? meetingPassword;

  /// Disable Driving Mode
  bool? noDrivingMode;

  /// Disable Invite Mode
  bool? noInvite;

  /// Disable Share Mode
  bool? noShare;

  /// Disable Title Bar Mode
  bool? noTitlebar;

  /// No Disconnect Audio Mode
  bool? noDisconnectAudio;

  /// View option to disable zoom icon for Learning system
  String? viewOptions;

  /// Disable No Audio
  bool? noAudio;

  /// Disable No Video
  bool? noVideo;

  /// Zoom token for SDK
  String? zoomToken;

  /// Zoom access token for SDK
  String? zoomAccessToken;

  /// JWT API KEY For Web Only
  String? jwtAPIKey;

  /// JWT API Signature For Web Only
  String? jwtSignature;

  /// User type for SDK
  String? userType;

  /// Set to change meeting ID displayed on meeting view title
  String? customMeetingId;

  /// Participant ID
  String? customerKey;

  /// Set whether to hide chat message toast when receive a chat message
  bool? noChatMsgToast;

  /// Query whether to hide host unmute yourself confirm dialog
  bool? noUnmuteConfirmDialog;

  /// Query whether to hide webinar need register dialog
  bool? noWebinarRegisterDialog;

  /// Invitation options. The host can enable all the items to invite attendees
  int? inviteOptions;

  /// Meeting view options
  int? meetingViewsOptions;

  /// Disable Dial In Via Phone
  bool? noDialInViaPhone;

  /// Disable Dial Out To Phone
  bool? noDialOutToPhone;

  /// Disable Record
  bool? noRecord;

  /// Disable Meeting End Message
  bool? noMeetingEndMessage;

  /// Disable Meeting Error Message
  bool? noMeetingErrorMessage;

  /// Disable Bottom Toolbar
  bool? noBottomToolbar;

  MeetingOptions({
    this.userId,
    this.userPassword,
    this.displayName,
    this.meetingId,
    this.meetingPassword,
    this.noDrivingMode,
    this.noInvite,
    this.noShare,
    this.noTitlebar,
    this.noDisconnectAudio,
    this.viewOptions,
    this.noAudio,
    this.noVideo,
    this.zoomToken,
    this.zoomAccessToken,
    this.jwtAPIKey,
    this.jwtSignature,
    this.userType,
    this.customMeetingId,
    this.customerKey,
    this.noChatMsgToast,
    this.noUnmuteConfirmDialog,
    this.noWebinarRegisterDialog,
    this.inviteOptions,
    this.meetingViewsOptions,
    this.noDialInViaPhone,
    this.noDialOutToPhone,
    this.noRecord,
    this.noMeetingEndMessage,
    this.noMeetingErrorMessage,
    this.noBottomToolbar,
  });
}
