part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginNotificationAPIImpl
    implements ZegoSignalingPluginNotificationAPI {
  /// enable notify when app running in background or quit
  @override
  Future<ZegoSignalingPluginEnableNotifyResult>
      enableNotifyWhenAppRunningInBackgroundOrQuit({
    bool? isIOSSandboxEnvironment,
    bool enableIOSVoIP = true,
    ZegoSignalingPluginMultiCertificate certificateIndex =
        ZegoSignalingPluginMultiCertificate.firstCertificate,
    String appName = '',
    String androidChannelID = "",
    String androidChannelName = "",
    String androidSound = "",
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'enable Notify When App Running In Background Or Quit, '
      'is iOS Sandbox Environment:$isIOSSandboxEnvironment, '
      'enable iOS VoIP:$enableIOSVoIP, '
      'certificate index:$certificateIndex, '
      'appName: $appName, '
      'androidChannelID: $androidChannelID, '
      'androidChannelName: $androidChannelName, '
      'androidSound: $androidSound',
      tag: 'signaling',
      subTag: 'notification',
    );

    if ((!io.Platform.isAndroid) && (!io.Platform.isIOS)) {
      ZegoSignalingLoggerService.logInfo(
        'Only Support Android And iOS Platform.',
        tag: 'signaling',
        subTag: 'notification',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.platformNotSupport,
              message: 'only support android and iOS platform.',
              method: 'enableNotifyWhenAppRunningInBackgroundOrQuit',
            ),
          );

      return ZegoSignalingPluginEnableNotifyResult(
        error: PlatformException(
          code: '-1',
          message: 'Only Support Android And iOS Platform.',
        ),
      );
    }

    try {
      var zpnsConfig = ZPNsConfig();
      if (!kIsWeb && io.Platform.isAndroid) {
        final notificationChannel = ZPNsNotificationChannel();
        notificationChannel.channelID = androidChannelID;
        notificationChannel.channelName = androidChannelName;
        notificationChannel.androidSound = androidSound;
        await ZPNs.getInstance().createNotificationChannel(notificationChannel);

        zpnsConfig.enableFCMPush = true;
      } else if (!kIsWeb && io.Platform.isIOS) {
        await ZPNs.getInstance().applyNotificationPermission();
      }
      zpnsConfig.appType = certificateIndex.id;
      await ZPNs.setPushConfig(zpnsConfig);

      var iOSEnvironment = ZPNsIOSEnvironment.Automatic;
      if (null != isIOSSandboxEnvironment) {
        iOSEnvironment = isIOSSandboxEnvironment
            ? ZPNsIOSEnvironment.Development
            : ZPNsIOSEnvironment.Production;
      }
      await ZPNs.getInstance().registerPush(
        iOSEnvironment: iOSEnvironment,
        enableIOSVoIP: enableIOSVoIP,
      );
      ZegoSignalingLoggerService.logInfo(
        'register push done',
        tag: 'signaling',
        subTag: 'notification',
      );
      return const ZegoSignalingPluginEnableNotifyResult();
    } catch (e) {
      ZegoSignalingLoggerService.logInfo(
        'register push, error:${e.toString()}',
        tag: 'signaling',
        subTag: 'notification',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.notificationEnableNotifyError,
              message: 'isIOSSandboxEnvironment:$isIOSSandboxEnvironment, '
                  'enableIOSVoIP:$enableIOSVoIP , '
                  'certificateIndex:$certificateIndex , '
                  'appName:$appName , '
                  'androidChannelID:$androidChannelID , '
                  'androidChannelName:$androidChannelName , '
                  'androidSound:$androidSound , '
                  'exception:$e',
              method: 'enableNotifyWhenAppRunningInBackgroundOrQuit',
            ),
          );

      if (e is PlatformException) {
        return ZegoSignalingPluginEnableNotifyResult(
          error: PlatformException(
            code: e.code,
            message: e.message,
          ),
        );
      } else {
        return ZegoSignalingPluginEnableNotifyResult(
          error: PlatformException(
            code: '-2',
            message: e.toString(),
          ),
        );
      }
    }
  }
}

/// @nodoc
class ZegoSignalingPluginNotificationEventImpl
    implements ZegoSignalingPluginNotificationEvent {
  /// getNotificationArrivedEventStream
  @override
  Stream<ZegoSignalingPluginNotificationArrivedEvent>
      getNotificationArrivedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .notificationArrivedEvent
        .stream;
  }

  /// getNotificationClickedEventStream
  @override
  Stream<ZegoSignalingPluginNotificationClickedEvent>
      getNotificationClickedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .notificationClickedEvent
        .stream;
  }

  /// getNotificationRegisteredEventStream
  @override
  Stream<ZegoSignalingPluginNotificationRegisteredEvent>
      getNotificationRegisteredEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .notificationRegisteredEvent
        .stream;
  }
}
