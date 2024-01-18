#import "ZoomAllInOneSdkPlugin.h"
#if __has_include(<zoom_allinonesdk/zoom_allinonesdk-Swift.h>)
#import <zoom_allinonesdk/zoom_allinonesdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "zoom_allinonesdk-Swift.h"
#endif

@implementation ZoomAllInOneSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftZoomAllInOneSdkPlugin registerWithRegistrar:registrar];
}
@end
