class ZoomConstants {
  static const String authTokenUrl =
      "https://zoom.us/oauth/token?grant_type=account_credentials&account_id=";
  static const String zakTokenUrl =
      "https://api.zoom.us/v2/users/me/token?type=zak";
  // Zoom methods
  static const String INIT_ZOOM = 'initZoom';
  static const String JOIN_MEETING = 'joinMeeting';
  static const String START_MEETING = 'startMeeting';

  // Zoom options
  static const String JWT_TOKEN = 'jwtToken';
  static const String DOMAIN = 'domain';
  static const String USER_ID = 'userId';
  static const String MEETING_ID = 'meetingId';
  static const String MEETING_PASSWORD = 'meetingPassword';
  static const String DISABLE_DIAL_IN = 'disableDialIn';
  static const String DISABLE_DRIVE = 'disableDrive';
  static const String DISABLE_INVITE = 'disableInvite';
  static const String DISABLE_SHARE = 'disableShare';
  static const String DISABLE_TITLEBAR = 'disableTitlebar';
  static const String NO_DISCONNECT_AUDIO = 'noDisconnectAudio';
  static const String VIEW_OPTIONS = 'viewOptions';
  static const String NO_AUDIO = 'noAudio';
  static const String ZAK_TOKEN = 'zakToken';
  static const String DISPLAY_NAME = 'displayName';
  static const String USER_PASSWORD = 'userPassword';
  static const String USER_TYPE = 'userType';

  // Extra
  static const String TOKEN = "token";

  // Meeting options
  static const String MEETING_NO_DRIVING_MODE = 'noDrivingMode';
  static const String MEETING_NO_INVITE = 'noInvite';
  static const String MEETING_NO_SHARE = 'noShare';
  static const String MEETING_NO_TITLEBAR = 'noTitlebar';
  static const String MEETING_NO_DISCONNECT_AUDIO = 'noDisconnectAudio';
  static const String MEETING_VIEW_OPTIONS = 'viewOptions';
  static const String MEETING_NO_AUDIO = 'noAudio';
  static const String MEETING_NO_VIDEO = 'noVideo';
  static const String MEETING_ZOOM_TOKEN = 'zoomToken';
  static const String MEETING_ZOOM_ACCESS_TOKEN = 'zoomAccessToken';
  static const String MEETING_JWT_API_KEY = 'jwtAPIKey';
  static const String MEETING_JWT_SIGNATURE = 'jwtSignature';
  static const String MEETING_USER_TYPE = 'userType';
  static const String MEETING_CUSTOM_MEETING_ID = 'customMeetingId';
  static const String MEETING_CUSTOMER_KEY = 'customerKey';
  static const String MEETING_NO_CHAT_MSG_TOAST = 'noChatMsgToast';
  static const String MEETING_NO_UNMUTE_CONFIRM_DIALOG =
      'noUnmuteConfirmDialog';
  static const String MEETING_NO_WEBINAR_REGISTER_DIALOG =
      'noWebinarRegisterDialog';
  static const String MEETING_INVITE_OPTIONS = 'inviteOptions';
  static const String MEETING_VIEWS_OPTIONS = 'meetingViewsOptions';
  static const String MEETING_NO_DIAL_IN_VIA_PHONE = 'noDialInViaPhone';
  static const String MEETING_NO_DIAL_OUT_TO_PHONE = 'noDialOutToPhone';
  static const String MEETING_NO_RECORD = 'noRecord';
  static const String MEETING_NO_MEETING_END_MESSAGE = 'noMeetingEndMessage';
  static const String MEETING_NO_MEETING_ERROR_MESSAGE =
      'noMeetingErrorMessage';
  static const String MEETING_NO_BOTTOM_TOOLBAR = 'noBottomToolbar';
}
