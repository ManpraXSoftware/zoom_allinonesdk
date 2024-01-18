import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoom_allinonesdk/zoom_allinonesdk.dart';

import 'dart:io' show Platform;

import '../config.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool flag = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Join Meeting'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDefaultTextFieldWithLabel(
                context,
                "Meeting Id",
                meetingIdController,
              ),
              SizedBox(height: 16.0),
              getDefaultTextFieldWithLabel(
                context,
                "Password",
                passwordController,
              ),
              SizedBox(height: 32.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    if (meetingIdController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      _showSnackBar(context);
                    } else {
                      String meetingId = meetingIdController.text;
                      String password = passwordController.text;
                      platformCheck(meetingId, password);
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void platformCheck(String meetingId, String password) {
    if (kIsWeb) {
      joinMeetingWeb(meetingId, password);
    } else if (Platform.isAndroid || Platform.isIOS) {
      joinMeetingAndroidAndIos(meetingId, password);
    }
    ;
  }

  void joinMeetingWeb(String meetingId, String password) {
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
        meetingId: meetingId, //Personal meeting id for join meeting required
        meetingPassword:
            password, //Personal meeting passcode for join meeting required
        userType: "0" //userType 0 for attendee
        );

    var zoom = ZoomAllInOneSdk();
    zoom.initZoom(zoomOptions: zoomOptions).then((results) {
      if (results[0] == 200) {
        zoom
            .joinMeting(meetingOptions: meetingOptions)
            .then((joinMeetingResult) {
          print("[Meeting Status Polling] : " + joinMeetingResult.toString());
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });
  }

  void joinMeetingAndroidAndIos(String meetingId, String password) async {
    ZoomOptions zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      clientId: configs["MEETING_SDK_CLIENT_KEY"],
      clientSecert: configs["MEETING_SDK_CLIENT_SECRET"],
    );
    var meetingOptions = MeetingOptions(
        displayName: "", meetingId: meetingId, meetingPassword: password);

    var zoom = ZoomAllInOneSdk();
    zoom.initZoom(zoomOptions: zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.joinMeting(meetingOptions: meetingOptions).then((loginResult) {});
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });
  }

  void _showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Please fill all the empty fields'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget getDefaultTextFieldWithLabel(
    BuildContext context,
    String label,
    TextEditingController textEditingController, {
    bool withSuffix = false,
    bool minLines = false,
    bool isPassword = false,
    bool isEnabled = true,
    bool isPrefix = false,
    Widget? prefix,
    double? height,
    IconData? suffixImage,
    Function? imageFunction,
    List<TextInputFormatter>? inputFormatters,
    FormFieldValidator<String>? validator,
    BoxConstraints? constraint,
    ValueChanged<String>? onChanged,
    double vertical = 20,
    double horizontal = 20,
    int? maxLength,
    String obscuringCharacter = '•',
    GestureTapCallback? onTap,
    bool isReadOnly = false,
    TextInputType? keyboardType,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          readOnly: isReadOnly,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          enabled: isEnabled,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: minLines ? null : 1,
          controller: textEditingController,
          obscuringCharacter: obscuringCharacter,
          autofocus: false,
          obscureText: isPassword,
          showCursor: true,
          cursorColor: Color(0xFF23408F),
          maxLength: maxLength,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 15,
            fontFamily: "Gilroy",
          ),
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.symmetric(
                vertical: vertical, horizontal: horizontal),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFDEDEDE), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF23408F), width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFDEDEDE), width: 1),
            ),
            suffixIconConstraints: BoxConstraints(
              maxHeight: 24,
            ),
            suffixIcon: withSuffix
                ? GestureDetector(
                    onTap: () {
                      imageFunction!();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 18),
                      child: Icon(suffixImage, size: 20.0),
                    ),
                  )
                : null,
            prefixIconConstraints: constraint,
            prefixIcon: isPrefix ? prefix : null,
            labelText: label,
            labelStyle: TextStyle(
              color: Color(0xFF9B9B9B),
              fontWeight: FontWeight.w700,
              fontSize: 15,
              fontFamily: "Gilroy",
            ),
          ),
        );
      },
    );
  }
}
