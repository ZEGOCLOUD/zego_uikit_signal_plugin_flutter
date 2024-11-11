part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginUserAPIImpl implements ZegoSignalingPluginUserAPI {
  /// login
  @override
  Future<ZegoSignalingPluginConnectUserResult> connectUser({
    required String id,
    String name = '',
    String token = '',
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'connectUser, '
      'id:$id, name:$name, '
      'has token:${token.isNotEmpty}',
      tag: 'signaling',
      subTag: 'user',
    );

    var targetUser = ZIMUserInfo()
      ..userID = id
      ..userName = name.isNotEmpty ? name : id;

    if (null != ZegoSignalingPluginCore().currentUser &&
        (ZegoSignalingPluginCore().currentUser!.userID.isNotEmpty &&
            ZegoSignalingPluginCore().currentUser!.userID != id)) {
      ZegoSignalingLoggerService.logInfo(
        'login exist before, and not same, auto logout....',
        tag: 'signaling',
        subTag: 'user',
      );
      await disconnectUser();
    }

    ZIMLoginConfig config = ZIMLoginConfig()
      ..userName = name
      ..token = token;
    return ZIM.getInstance()!.login(targetUser.userID, config).then((value) {
      ZegoSignalingLoggerService.logInfo(
        'connectUser success.',
        tag: 'signaling',
        subTag: 'user',
      );

      ZegoSignalingPluginCore().currentUser = targetUser;

      return const ZegoSignalingPluginConnectUserResult();
    }).catchError((error) {
      if (error is PlatformException &&
          int.parse(error.code) ==
              ZIMErrorCode.networkModuleUserHasAlreadyLogged &&
          ZegoSignalingPluginCore().currentUser?.userID == targetUser.userID &&
          ZegoSignalingPluginCore().currentUser?.userName ==
              targetUser.userName) {
        ZegoSignalingLoggerService.logError(
          'connectUser, user is same who current login',
          tag: 'signaling',
          subTag: 'user',
        );

        return const ZegoSignalingPluginConnectUserResult();
      }

      ZegoSignalingLoggerService.logInfo(
        'connectUser, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'user',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.userLoginError,
              message:
                  'id:$id, name:$name, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'connectUser',
            ),
          );

      return ZegoSignalingPluginConnectUserResult(
        error: error,
      );
    });
  }

  /// logout
  @override
  Future<ZegoSignalingPluginDisconnectUserResult> disconnectUser(
      [Duration timeout = const Duration(seconds: 2)]) async {
    ZegoSignalingLoggerService.logInfo(
      'disconnectUser, current id:${ZegoSignalingPluginCore().currentUser?.userID}, '
      'current name:${ZegoSignalingPluginCore().currentUser?.userName}',
      tag: 'signaling',
      subTag: 'user',
    );

    ZegoSignalingPluginCore().currentUser = null;
    ZIM.getInstance()!.logout();

    if (ZegoSignalingPluginCore().eventCenter.connectionState ==
        ZIMConnectionState.reconnecting) {
      /// if current state is network break(reconnecting),
      /// sdk will not call onConnectionStateChanged callback,
      /// that mean the following Completer code will wait forever,
      /// so here return result directly
      return Future.value(
        const ZegoSignalingPluginDisconnectUserResult(timeout: false),
      );
    }

    /// wait for disconnect, make sure state is disconnected before next connect
    ZegoSignalingLoggerService.logInfo(
      'disconnectUser, waitForDisconnect...',
      tag: 'signaling',
      subTag: 'user',
    );
    if (ZegoSignalingPluginCore().eventCenter.connectionState !=
        ZIMConnectionState.disconnected) {
      final completer = Completer<ZegoSignalingPluginDisconnectUserResult>();
      final timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (ZegoSignalingPluginCore().eventCenter.connectionState ==
            ZIMConnectionState.disconnected) {
          if (timer.isActive) timer.cancel();
          if (!completer.isCompleted) {
            completer.complete(
                const ZegoSignalingPluginDisconnectUserResult(timeout: false));
          }
          ZegoSignalingLoggerService.logInfo(
            'disconnectUser, waitForDisconnect success',
            tag: 'signaling',
            subTag: 'user',
          );
        }
      });

      /// if not complete in timeout seconds, not wait the disconnect anymore
      Future.delayed(timeout, () {
        if (timer.isActive) timer.cancel();
        if (!completer.isCompleted) {
          completer.complete(
              const ZegoSignalingPluginDisconnectUserResult(timeout: true));
        }
        ZegoSignalingLoggerService.logInfo(
          'disconnectUser, waitForDisconnect timeout',
          tag: 'signaling',
          subTag: 'user',
        );
      });
      return completer.future;
    } else {
      return Future.value(
        const ZegoSignalingPluginDisconnectUserResult(timeout: false),
      );
    }
  }

  /// renew token
  @override
  Future<ZegoSignalingPluginRenewTokenResult> renewToken(String token) async {
    ZegoSignalingLoggerService.logInfo(
      'renewToken, has token:${token.isNotEmpty}',
      tag: 'signaling',
      subTag: 'user',
    );

    return ZIM
        .getInstance()!
        .renewToken(token)
        .then((value) => const ZegoSignalingPluginRenewTokenResult())
        .catchError((error) {
      ZegoSignalingLoggerService.logError(
        'renewToken error:${error.toString()}',
        tag: 'signaling',
        subTag: 'user',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.renewTokenError,
              message:
                  'exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'renewToken',
            ),
          );

      return ZegoSignalingPluginRenewTokenResult(
        error: error,
      );
    });
  }
}

/// @nodoc
class ZegoSignalingPluginUserEventImpl implements ZegoSignalingPluginUserEvent {
  /// connection state
  @override
  ZegoSignalingPluginConnectionState getConnectionState() {
    return ZegoSignalingPluginConnectionState
        .values[ZegoSignalingPluginCore().eventCenter.connectionState.index];
  }

  /// connection state changed event
  @override
  Stream<ZegoSignalingPluginConnectionStateChangedEvent>
      getConnectionStateChangedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .connectionStateChangedEvent
        .stream;
  }

  /// token will expire event
  @override
  Stream<ZegoSignalingPluginTokenWillExpireEvent>
      getTokenWillExpireEventStream() {
    return ZegoSignalingPluginCore().eventCenter.tokenWillExpireEvent.stream;
  }
}
