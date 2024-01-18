import Flutter
import UIKit
import MobileRTC
public class SwiftZoomAllInOneSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "zoom_allinonesdk", binaryMessenger: registrar.messenger())
        let instance = SwiftZoomAllInOneSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        if call.method == "initZoom" {
            self.setupSDK(call: call, result: result)
        }

        if call.method == "joinMeeting" {
            self.joinMeeting(call: call, result: result)
        }
        if call.method == "startMeeting" {
            self.startMeeting(call: call, result: result)
        }


    }


    func getDeviceID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }

    func getRootController() -> UIViewController {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        let topController = (keyWindow?.rootViewController)!
        return topController
    }
}
extension SwiftZoomAllInOneSdkPlugin{

    func joinAMeetingButtonPressed(meetingNumber: String, meetingPassword: String){
        MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
    }

    func joinMeeting(call: FlutterMethodCall, result: FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, String> else { return }
            let meetingNumber = args["meetingId"] ?? ""
            let meetingPassword = args["meetingPassword"] ?? ""
        MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
        if let meetingService = MobileRTC.shared().getMeetingService() {
        
            // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
            // In this case, we will only need to provide a meeting number and password.
            meetingService.delegate = self

            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            joinMeetingParameters.meetingNumber = meetingNumber
            joinMeetingParameters.password = meetingPassword

            // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
            // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
            meetingService.muteMyVideo(false)
            meetingService.muteMyAudio(false)

            //            meetingService.video
            meetingService.joinMeeting(with: joinMeetingParameters)
        }
    }

}

extension SwiftZoomAllInOneSdkPlugin {

    func startMeeting(call: FlutterMethodCall, result: FlutterResult){
        guard let args = call.arguments as? Dictionary<String, String> else { return }
            let zoomAccessToken = args["zakToken"] ?? ""
            let meetingId = args["meetingId"] ?? ""
            let displayName = args["displayName"] ?? ""
        if let meetingService = MobileRTC.shared().getMeetingService() {
            meetingService.delegate = self
            let startMeetingParams = MobileRTCMeetingStartParam4WithoutLoginUser()
            startMeetingParams.zak = zoomAccessToken
            startMeetingParams.meetingNumber = meetingId
            startMeetingParams.userName = displayName
            meetingService.startMeeting(with: startMeetingParams)
        }
    }

}


extension SwiftZoomAllInOneSdkPlugin: MobileRTCMeetingServiceDelegate {

    // Is called upon in-meeting errors, join meeting errors, start meeting errors, meeting connection errors, etc.
    public func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
        switch error {
        case MobileRTCMeetError.passwordError:
            print("MobileRTCMeeting   :   Could not join or start meeting because the meeting password was incorrect.")
        default:
            print("MobileRTCMeeting   :   Could not join or start meeting with MobileRTCMeetError: \(error) \(message ?? "")")
        }
    }

    // Is called when the user joins a meeting.
    public func onJoinMeetingConfirmed() {
        print("MobileRTCMeeting   :   Join meeting confirmed.")
    }

    // Is called upon meeting state changes.
    public func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("MobileRTCMeeting   :   Current meeting state: \(state.rawValue)")
        switch state{

        case .idle:
            print("idle")
        case .connecting:
            print("connecting")

        case .waitingForHost:
            print("waitingForHost")

        case .inMeeting:
            print("inMeeting")

        case .disconnecting:
            print("disconnecting")

        case .reconnecting:
            print("reconnecting")

        case .failed:
            print("failed")

        case .ended:
            print("ended")

        case .locked:
            print("locked")

        case .unlocked:
            print("unlocked")

        case .inWaitingRoom:
            print("inWaitingRoom")

        case .webinarPromote:
            print("webinarPromote")

        case .webinarDePromote:
            print("webinarDePromote")

        case .joinBO:
            print("joinBO")

        case .leaveBO:
            print("leaveBO")

        @unknown default:
            break
        }
    }
}


extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}



extension SwiftZoomAllInOneSdkPlugin: MobileRTCAuthDelegate {
    func setupSDK(call: FlutterMethodCall, result: @escaping FlutterResult)  {
        guard let args = call.arguments as? Dictionary<String,String> else { return }
        let jwtToken = args["jwtToken"] ?? ""
        let context = MobileRTCSDKInitContext()
        context.domain = "zoom.us"
        context.enableLog = true

        let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)

        if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.shared().getAuthService() {
            authorizationService.delegate = self
            authorizationService.jwtToken = jwtToken
            authorizationService.sdkAuth()
        }
        let response: [Int] = [0, 0]
        result(response)
    }

    // Result of calling sdkAuth(). MobileRTCAuthError_Success represents a successful authorization.
    public func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        switch returnValue {
        case MobileRTCAuthError.success:
            print("SDK successfully initialized.")
        case MobileRTCAuthError.keyOrSecretEmpty:
            print("SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
        case MobileRTCAuthError.keyOrSecretWrong, MobileRTCAuthError.unknown:
            print("SDK Key/Secret is not valid.")
        default:
            print("SDK Authorization failed with MobileRTCAuthError: \(returnValue).")
        }
    }

    private func onMobileRTCLoginReturn(_ returnValue: Int) {
        switch returnValue {
        case 0:
            print("Successfully logged in")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
        case 1002:
            print("Password incorrect")
        default:
            print("Could not log in. Error code: \(returnValue)")
        }
    }
    public func onMobileRTCLogoutReturn(_ returnValue: Int) {
        switch returnValue {
        case 0:
            print("Successfully logged out")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
        default:
            print("Could not log out. Error code: \(returnValue)")
        }
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        // Obtain the MobileRTCAuthService from the Zoom SDK, this service can log in a Zoom user, log out a Zoom user, authorize the Zoom SDK etc.
        if let authorizationService = MobileRTC.shared().getAuthService() {

            // Call logoutRTC() to log the user out.
            authorizationService.logoutRTC()
        }
    }
}

