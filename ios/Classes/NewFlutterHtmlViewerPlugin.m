#import "NewFlutterHtmlViewerPlugin.h"
#if __has_include(<new_flutter_html_viewer/new_flutter_html_viewer-Swift.h>)
#import <new_flutter_html_viewer/new_flutter_html_viewer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "new_flutter_html_viewer-Swift.h"
#endif

@implementation NewFlutterHtmlViewerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNewFlutterHtmlViewerPlugin registerWithRegistrar:registrar];
}
@end
