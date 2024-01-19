# Zoom All-In-One Plugin for Flutter

A Flutter plugin for integrating the **Zoom All-In-One SDK** into your Flutter applications with support for Android, iOS and Web platforms.

You must create a **Zoom account**, generate a **Meeting SDK**, and set up **Server-to-Server OAuth** legacy apps to obtain the necessary **configuration parameters**. Additionally, you need to manually integrate the Zoom Android, iOS, and Web Meeting SDKs by following the instructions provided for each platform below.

**Note:** This plugin is actively under development, and some Zoom features may not be available yet. We welcome feedback, bug reports, and pull requests.

## Features

- Integration of the Zoom All-In-One SDK into your Flutter applications.
- Support for Android, iOS, and Web platforms.
- Support for null safety.
- Initialization of Zoom SDK with specified options.
- Starting and joining Zoom meetings with customizable options.
- Platform-specific initialization and meeting handling.

<summary> <h3>Zoom Account Setup<h3></summary>

**1. Create Zoom Meeting SDK App:**

- Log in to the [Zoom App Marketplace](https://marketplace.zoom.us/).
- Navigate to **Develop > Build App**.
- Choose "Meeting SDK" as the app type and provide a name for your app.
- On the **Basic Info** page, find your app credentials (**client ID and client secret**).
- Set up OAuth in the **OAuth Information** section by entering your development redirect URL or endpoint.
- On the **Features** page, select the Zoom products and features your app will work with.
- On the **Scopes** page, choose the Zoom API methods (scopes) your app needs.
- Download the SDK for your preferred platform (Android and iOS) from the **Download** page.
- On the **Test** page, preview and test your app with internal users.
- For more details, you can refer to the Create a [Meeting SDK App](https://developers.zoom.us/docs/meeting-sdk/create/) documentation.

**2. Create Zoom Server-to-Server OAuth App:**

- Log in to the [Zoom App Marketplace](https://marketplace.zoom.us/).
- Go to **Develop > Build Server-to-Server App**.
- Enter a name for your app and click **Create**.
- On the **App Credentials** page, locate your account ID, client ID, and client secret.
- On the **Information** page, provide basic details about your app.
- On the **Features** page, decide whether to enable event subscriptions and select the events you want to subscribe to.
- On the **Scopes** page, add the Zoom API methods (scopes) your app will use.
- On the **Activation** page, activate your app; you can't generate an access token without activation.
- For more details, you can refer to the Create a [Server-to-Server OAuth app](https://developers.zoom.us/docs/internal-apps/create/) documentation.

**3. Configure SDK and OAuth Credentials:**
Once you have obtained the necessary credentials from Zoom, paste them inside the configuration file.

    const Map<String, String> configs = {
    'MEETING_SDK_CLIENT_KEY': 'YOUR_MEETING_SDK_CLIENT_KEY',
    'MEETING_SDK_CLIENT_SECRET': 'YOUR_MEETING_SDK_CLIENT_SECRET',
    'SERVER_TO_SERVER_CLIENT_KEY': 'YOUR_SERVER_TO_SERVER_CLIENT_KEY',
    'SERVER_TO_SERVER_CLIENT_SECRET': 'YOUR_SERVER_TO_SERVER_CLIENT_SECRET',
    'SERVER_TO_SERVER_ACCOUNT_ID': 'YOUR_SERVER_TO_SERVER_ACCOUNT_ID',
    };


<summary><h3> Setting up Android Plugin </h3></summary>

To use the plugin on Android, follow these steps:

1. Log onto the [Zoom App Marketplace](https://marketplace.zoom.us/) and navigate to **Develop > Build App**.
2. Select **Meeting SDK** as the app type.
3. On the Download page, select **Android** and choose version **5.16.0.16310** from the dropdown menu. Click **Download** to get the Android SDK zip file.
4. Extract the zip file and locate the `commonlib` folder. Copy `commonlib.aar` and paste it inside the plugin directory: `android -> libs` folder.
5. Locate the `mobilertc` folder. Copy `mobilertc.aar` and paste it inside the plugin directory: `android -> libs` folder.

Make sure to maintain the folder structure as mentioned above.


<summary><h3>Setting up iOS Plugin </h3></summary>

To use the plugin on iOS, follow these steps:

1. Log onto the [Zoom App Marketplace](https://marketplace.zoom.us/) and navigate to **Develop > Build App**.

2. Select **Meeting SDK** as the app type.

3. On the Download page, select **iOS** and choose version **5.16.0.16310** from the dropdown menu. Click **Download** to get the iOS SDK zip file.

4. After the download is complete, unzip the file. Locate and copy the following two files:

   - `MobileRTC.xcframework`
   - `MobileRTCResources.bundle`

   Paste them in the iOS module inside the SDK’s iOS folder.

5. Run `pod install` in your project’s iOS folder to install the required pods for Zoom in iOS. You can do this by right-clicking on the iOS folder and selecting **Open in Terminal**.

6. Open the project’s iOS folder in Xcode. Go to **Targets > Build Phases > Copy Bundle Resources** and add `MobileRTCResources.bundle` into it from `.../zoom_allinonesdk/`. This will copy the Zoom SDK resources to your app bundle.

<summary><h3>Setting up Web Plugin</h3></summary>

**Note for using on Web:**

- You cannot start a meeting without the meeting ID and password. To obtain your personal meeting ID and password,visit [https://zoom.us/meeting#/](https://zoom.us/meeting#/) and navigate to the Personal Room tab.

**Stylesheet Setup:**

Add the following stylesheet links to the head of `index.html`:

    <link
      type="text/css"
      rel="stylesheet"
      href="https://source.zoom.us/2.18.0/css/bootstrap.css"
    />
    <link
      type="text/css"
      rel="stylesheet"
      href="https://source.zoom.us/2.18.0/css/react-select.css"
    />

Import ZoomMeeting Dependencies: Add the following script tags to the body of
index.html to import ZoomMeeting dependencies.

    <!-- Import ZoomMeeting dependencies -->
    <script src="https://source.zoom.us/2.18.0/lib/vendor/react.min.js"></script>
    <script src="https://source.zoom.us/2.18.0/lib/vendor/react-dom.min.js"></script>
    <script src="https://source.zoom.us/2.18.0/lib/vendor/redux.min.js"></script>
    <script src="https://source.zoom.us/2.18.0/lib/vendor/redux-thunk.min.js"></script>
    <script src="https://source.zoom.us/2.18.0/lib/vendor/lodash.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jsSHA/2.4.0/sha256.js"></script>
    <script src="https://source.zoom.us/zoom-meeting-2.18.0.min.js"></script>
    <script src="main.dart.js" type="application/javascript"></script>



### Usage

Import the package in your Dart file:

    import 'package:zoom_allinonesdk/zoom_allinonesdk.dart';

### Create a Meeting:

**Android and iOS:**

    ZoomOptions zoomOptions = new ZoomOptions(
    domain: "zoom.us",
    clientId: configs["MEETING_SDK_CLIENT_KEY"],
    clientSecert: configs["MEETING_SDK_CLIENT_SECRET"],
    );
    var meetingOptions = new MeetingOptions(
        displayName: "YOUR_NAME",
        meetingId: "",  // If it's an instant meeting, leave it blank; otherwise, enter your specific YOUR_MEETING_ID
        meetingPassword: "",  // If it's an instant meeting, leave it blank; otherwise, enter your specific YOUR_MEETING_PASSWORD
        userType: "1");

    var zoom = ZoomAllInOneSdk();
    zoom.initZoom(zoomOptions: zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.startMeeting(
                accountId: configs["SERVER_TO_SERVER_ACCOUNT_ID"],
                clientId: configs["SERVER_TO_SERVER_CLIENT_KEY"],
                clientSecret: configs["SERVER_TO_SERVER_CLIENT_SECRET"],
                meetingOptions: meetingOptions)
            .then((loginResult) {
          print("loginResult " + loginResult.toString());
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });

**Web:**

    ZoomOptions zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      clientId: configs["MEETING_SDK_CLIENT_KEY"],
      clientSecert: configs["MEETING_SDK_CLIENT_SECRET"],
      language: "en-US", // Optional - For Web
      showMeetingHeader: true, // Optional - For Web
      disableInvite: false, // Optional - For Web
      disableCallOut: false, // Optional - For Web
      disableRecord: false, // Optional - For Web
      disableJoinAudio: false, // Optional - For Web
      audioPanelAlwaysOpen: false, // Optional - For Web
    );
    var meetingOptions = new MeetingOptions(
        displayName: "YOUR_NAME",
        meetingId: "YOUR_MEETING_ID", //Personal meeting id for start meeting required in web
        meetingPassword: "YOUR_MEETING_PASSWORD", //Personal meeting passcode for start meeting in web required
        userType: "1");

    var zoom = ZoomAllInOneSdk();
    zoom.initZoom(zoomOptions: zoomOptions).then((results) {
      if (results[0] == 200) {
        zoom.startMeeting(
                accountId: configs["SERVER_TO_SERVER_ACCOUNT_ID"],
                clientId: configs["SERVER_TO_SERVER_CLIENT_KEY"],
                clientSecret: configs["SERVER_TO_SERVER_CLIENT_SECRET"],
                meetingOptions: meetingOptions)
            .then((joinMeetingResult) {
          print("[Meeting Status Polling] : " + joinMeetingResult.toString());
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });

### Join a Meeting:

**Android and iOS:**

    ZoomOptions zoomOptions = new ZoomOptions(
    domain: "zoom.us",
    clientId: configs["MEETING_SDK_CLIENT_KEY"],
    clientSecert: configs["MEETING_SDK_CLIENT_SECRET"],
    );
    var meetingOptions = new MeetingOptions(
        displayName: "YOUR_NAME",
        meetingId: "YOUR_MEETING_ID", //Personal meeting id for join meeting required
        meetingPassword: "YOUR_MEETING_PASSWORD", //Personal meeting password for join meeting required
        userType: "0");

    var zoom = ZoomAllInOneSdk();
    zoom.initZoom(zoomOptions: zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.joinMeting(meetingOptions: meetingOptions).then((loginResult) {});
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });

**Web:**

      ZoomOptions zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      clientId: configs["MEETING_SDK_CLIENT_KEY"],
      clientSecert: configs["MEETING_SDK_CLIENT_SECRET"],
      language: "en-US", // Optional - For Web
      showMeetingHeader: true, // Optional - For Web
      disableInvite: false, // Optional - For Web
      disableCallOut: false, // Optional - For Web
      disableRecord: false, // Optional - For Web
      disableJoinAudio: false, // Optional - For Web
      audioPanelAlwaysOpen: false, // Optional - For Web
    );
    var meetingOptions = new MeetingOptions(
        displayName: "",
        meetingId: "YOUR_MEETING_ID", //Personal meeting id for join meeting required
        meetingPassword: "YOUR_MEETING_PASSWORD", //Personal meeting passcode for join meeting required
        userType: "0" //userType 0 for attendee
        );

    var zoom = ZoomAllInOneSdk();
    zoom.initZoom(zoomOptions: zoomOptions).then((results) {
      if (results[0] == 200) {
        zoom.joinMeting(meetingOptions: meetingOptions)
            .then((joinMeetingResult) {
          print("[Meeting Status Polling] : " + joinMeetingResult.toString());
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });

