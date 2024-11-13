package com.zegocloud.uikit.flutter.signal_plugin.zego_uikit_signaling_plugin;

import android.app.ActivityManager;
import android.content.Context;
import android.content.IntentFilter;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.List;

/**
 * ZegoUikitSignalingPlugin
 */
public class ZegoUikitSignalingPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel methodChannel;
    private Context context;
    private ActivityPluginBinding activityBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.d("signaling plugin", "onAttachedToEngine");

        methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zego_uikit_signaling_plugin");
        methodChannel.setMethodCallHandler(this);

        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.d("signaling plugin", "onMethodCall: " + call.method);
        result.notImplemented();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d("signaling plugin", "onDetachedFromEngine");

        methodChannel.setMethodCallHandler(null);
    }


    @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
        Log.d("signaling plugin", "onAttachedToActivity");

        activityBinding = activityPluginBinding;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {
        Log.d("signaling plugin", "onReattachedToActivityForConfigChanges");

        activityBinding = activityPluginBinding;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d("signaling plugin", "onDetachedFromActivityForConfigChanges");

        activityBinding = null;
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d("signaling plugin", "onDetachedFromActivity");

        activityBinding = null;
    }

}