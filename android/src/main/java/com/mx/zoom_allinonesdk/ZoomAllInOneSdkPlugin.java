package com.mx.zoom_allinonesdk;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import us.zoom.sdk.JoinMeetingOptions;
import us.zoom.sdk.JoinMeetingParams;
import us.zoom.sdk.MeetingError;
import us.zoom.sdk.MeetingParameter;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.MeetingServiceListener;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.StartMeetingOptions;
import us.zoom.sdk.StartMeetingParams4NormalUser;
import us.zoom.sdk.ZoomError;
import us.zoom.sdk.ZoomSDK;
import us.zoom.sdk.ZoomSDKInitParams;
import us.zoom.sdk.ZoomSDKInitializeListener;
import us.zoom.sdk.MeetingViewsOptions;
import us.zoom.sdk.StartMeetingParamsWithoutLogin;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import com.mx.zoom_allinonesdk.constants.ZoomConstants;

public class ZoomAllInOneSdkPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, MeetingServiceListener,
        ZoomSDKInitializeListener, ActivityAware {

    private MethodChannel channel;
    private Activity activity;
    private Context context;
    private ZoomSDK zoomSDK = ZoomSDK.getInstance();

    @Override
    public void onAttachedToEngine(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zoom_allinonesdk");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case ZoomConstants.INIT_ZOOM:
                initZoom(call, result);
                break;
            case ZoomConstants.JOIN_MEETING:
                joinMeeting(call, result);
                break;
            case ZoomConstants.START_MEETING:
                startMeeting(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    // Initialize Zoom SDK
    private void initZoom(MethodCall call, Result result) {
        Map<String, String> options = call.arguments();

        // Check for required parameters
        if (options.get(ZoomConstants.JWT_TOKEN) == null) {
            result.error("JWT_TOKEN_NULL", "JWT Token cannot be null", null);
            return;
        }

        // Check if Zoom SDK is already initialized
        if (zoomSDK.isInitialized()) {
            List<Integer> response = Arrays.asList(0, 0);
            result.success(response);
            return;
        }

        // Configure ZoomSDKInitParams
        ZoomSDKInitParams initParams = new ZoomSDKInitParams();
        initParams.jwtToken = options.get(ZoomConstants.JWT_TOKEN);
        initParams.domain = options.get(ZoomConstants.DOMAIN);
        initParams.enableLog = true;

        // Initialize Zoom SDK
        ZoomSDKInitializeListener zoomSDKInitializeListener = new ZoomSDKInitializeListener() {
            @Override
            public void onZoomSDKInitializeResult(int errorCode, int internalErrorCode) {
                handleZoomSDKInitializationResult(errorCode, internalErrorCode, result);
            }

            @Override
            public void onZoomAuthIdentityExpired() {
                Log.d("ZoomAllInOneSdkPlugin", "Zoom authentication identity expired.");
            }
        };

        zoomSDK.initialize(context, zoomSDKInitializeListener, initParams);
    }

    // Handle Zoom SDK Initialization Result
    private void handleZoomSDKInitializationResult(int errorCode, int internalErrorCode, Result result) {
        if (errorCode != ZoomError.ZOOM_ERROR_SUCCESS) {
            Toast.makeText(activity, "Failed to initialize Zoom SDK. Error: " + errorCode + ", internalErrorCode=" + internalErrorCode, Toast.LENGTH_LONG).show();
            result.error("SDK_INIT_ERROR", "Failed to initialize Zoom SDK", errorCode);
        } else {
            Toast.makeText(activity, "Initialize Zoom SDK successfully.", Toast.LENGTH_LONG).show();
            List<Integer> response = Arrays.asList(0, 0);
            result.success(response);
        }
    }

    // Join a Zoom meeting
    private void joinMeeting(MethodCall methodCall, Result result) {
        Map<String, String> options = methodCall.arguments();

        // Check if Zoom SDK is initialized
        if (!zoomSDK.isInitialized()) {
            Log.e("ZoomAllInOneSdkPlugin", "Zoom SDK is not initialized");
            result.success(false);
            return;
        }

        // Get MeetingService instance
        MeetingService meetingService = zoomSDK.getMeetingService();

        // Configure JoinMeetingOptions and JoinMeetingParams
        JoinMeetingOptions opts = new JoinMeetingOptions();
        JoinMeetingParams params = new JoinMeetingParams();
        params.displayName = options.get(ZoomConstants.DISPLAY_NAME);
        params.meetingNo = options.get(ZoomConstants.MEETING_ID);
        params.password =options.get(ZoomConstants.MEETING_PASSWORD);

        // Join the meeting
        meetingService.joinMeetingWithParams(activity, params, opts);
    }

    
    private void startMeeting(MethodCall methodCall, Result result) {
        Map<String, String> options = methodCall.arguments();
    
        ZoomSDK zoomSDK = ZoomSDK.getInstance();
    
        if (!zoomSDK.isInitialized()) {
            sendReply(result, Arrays.asList("SDK ERROR", "001"));
            return;
        }
    
        MeetingService meetingService = zoomSDK.getMeetingService();
        
        if (meetingService.getMeetingStatus() != MeetingStatus.MEETING_STATUS_IDLE) {
            Log.d("ZoomAllInOneSdkPlugin", "Cannot start a new meeting while another meeting is in progress.");
            sendReply(result, Arrays.asList("MEETING ERROR", "002"));
            return;
        }
    
        StartMeetingOptions startMeetingOptions = new StartMeetingOptions();
        StartMeetingParamsWithoutLogin startMeetingParamsWithoutLogin = new StartMeetingParamsWithoutLogin();
        
        // Set meeting parameters
        startMeetingParamsWithoutLogin.displayName = options.get(ZoomConstants.DISPLAY_NAME);
        startMeetingParamsWithoutLogin.userType = Integer.parseInt(options.get(ZoomConstants.USER_TYPE));
        startMeetingParamsWithoutLogin.meetingNo = options.get(ZoomConstants.MEETING_ID);
        startMeetingParamsWithoutLogin.zoomAccessToken = options.get(ZoomConstants.ZAK_TOKEN);
    
        // Start the meeting
        meetingService.startMeetingWithParams(context, startMeetingParamsWithoutLogin, startMeetingOptions);
    
        sendReply(result, Arrays.asList("MEETING SUCCESS", "200"));
    }

    // Send a reply to Flutter
    private void sendReply(Result result, List<String> response) {
        result.success(response);
    }

    // Callback for meeting status changes
    @Override
    public void onMeetingStatusChanged(MeetingStatus meetingStatus, int errorCode, int internalErrorCode) {
        Log.d("ZoomAllInOneSdkPlugin", "Meeting status changed: " + meetingStatus);

        if (meetingStatus == MeetingStatus.MEETING_STATUS_CONNECTING) {
            Log.d("ZoomAllInOneSdkPlugin", "Connecting to the meeting...");
        } else if (meetingStatus == MeetingStatus.MEETING_STATUS_DISCONNECTING) {
            if (errorCode == ZoomError.ZOOM_ERROR_SUCCESS) {
                Log.d("ZoomAllInOneSdkPlugin", "Meeting disconnected successfully.");
            } else {
                Log.e("ZoomAllInOneSdkPlugin", "Meeting disconnect failed. Error: " + errorCode + ", internalErrorCode: " + internalErrorCode);
            }
        } else if (meetingStatus == MeetingStatus.MEETING_STATUS_FAILED) {
            handleMeetingFailure(errorCode);
        }
    }

    // Handle meeting failure
    private void handleMeetingFailure(int errorCode) {
        Log.e("ZoomAllInOneSdkPlugin", "Meeting failed. Error: " + errorCode);

        // Show an appropriate message to the user
        switch (errorCode) {
            case MeetingError.MEETING_ERROR_CLIENT_INCOMPATIBLE:
                showToast("Your Zoom client version is too low");
                break;
            case MeetingError.MEETING_ERROR_INCORRECT_MEETING_NUMBER:
                showToast("The meeting number is incorrect");
                break;
            case MeetingError.MEETING_ERROR_MEETING_NOT_EXIST:
                showToast("The meeting does not exist");
                break;
            case MeetingError.MEETING_ERROR_NETWORK_UNAVAILABLE:
                showToast("Network unavailable");
                break;
            case MeetingError.MEETING_ERROR_TIMEOUT:
                showToast("Connection timeout");
                break;
            case MeetingError.MEETING_ERROR_USER_FULL:
                showToast("The meeting is full");
                break;
            case MeetingError.MEETING_ERROR_WEB_SERVICE_FAILED:
                showToast("Web service failed");
                break;
            default:
                showToast("Unknown error");
                break;
        }
    }

    // Show a toast message
    private void showToast(String message) {
        Toast.makeText(activity, message, Toast.LENGTH_SHORT).show();
    }

    // Callback for Zoom SDK initialization result
    @Override
    public void onZoomSDKInitializeResult(int errorCode, int internalErrorCode) {
        Log.d("TAG", "onZoomSDKInitializeResult: " + errorCode + " , " + internalErrorCode);
    }

    // Callback for Zoom authentication identity expiration
    @Override
    public void onZoomAuthIdentityExpired() {
        Log.d("TAG", "onZoomAuthIdentityExpired");
    }

    // Callback when attached to an activity
    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    // Callback when detached from an activity due to configuration changes
    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    // Callback when reattached to an activity after configuration changes
    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    // Callback when detached from an activity
    @Override
    public void onDetachedFromActivity() {
        channel.setMethodCallHandler(null);
    }

    // Helper Function for parsing string to boolean value
    private boolean parseBoolean(Map<String, String> options, String property) {
        return options.get(property) != null && Boolean.parseBoolean(options.get(property));
    }

    // Helper Function to create StartMeetingOptions
    private StartMeetingOptions createStartMeetingOptions(Map<String, String> options) {
        StartMeetingOptions opts = new StartMeetingOptions();
        // Implement based on your requirements
        return opts;
    }

    // Callback for meeting parameter notification
    @Override
    public void onMeetingParameterNotification(MeetingParameter meetingParameter) {
        Log.d("TAG", "onMeetingParameterNotification: " + meetingParameter);
    }

    // Helper Function to create StartMeetingParams4NormalUser
    private StartMeetingParams4NormalUser createStartMeetingParams(Map<String, String> options) {
        StartMeetingParams4NormalUser params = new StartMeetingParams4NormalUser();
        // Implement based on your requirements
        return params;
    }
}
