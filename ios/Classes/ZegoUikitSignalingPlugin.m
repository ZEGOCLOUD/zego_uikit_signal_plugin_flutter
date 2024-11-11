#import "ZegoUikitSignalingPlugin.h"

@implementation ZegoUikitSignalingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zego_uikit_signaling_plugin"
            binaryMessenger:[registrar messenger]];
  ZegoUikitSignalingPlugin* instance = [[ZegoUikitSignalingPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(FlutterMethodNotImplemented);
}
@end
