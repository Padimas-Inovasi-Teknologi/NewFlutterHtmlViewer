package com.bleuxstrife.new_flutter_html_viewer;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.browser.customtabs.CustomTabsIntent;

import com.bleuxstrife.new_flutter_html_viewer.internal.Launcher;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** NewFlutterHtmlViewerPlugin */
public class NewFlutterHtmlViewerPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private static final String KEY_OPTION = "option";
  private static final String KEY_URL = "url";
  private static final String KEY_EXTRA_CUSTOM_TABS = "extraCustomTabs";
  private static final String CODE_LAUNCH_ERROR = "LAUNCH_ERROR";
  private Context applicationContext;
  private Launcher launcher;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    onAttachedToEngine(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
  }

  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    this.applicationContext = applicationContext;
    channel = new MethodChannel(messenger, "com.bleuxstrife/new_flutter_html_viewer");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "launch":
        launch(((Map<String, Object>) call.arguments), result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @SuppressWarnings("unchecked")
  private void launch(@NonNull Map<String, Object> args, @NonNull MethodChannel.Result result) {
    final Context context = applicationContext;
    launcher = new Launcher(context);
    final Uri uri = Uri.parse(args.get(KEY_URL).toString());
    final Map<String, Object> options = (Map<String, Object>) args.get(KEY_OPTION);
    final CustomTabsIntent customTabsIntent = launcher.buildIntent(options);


    customTabsIntent.intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

    try {
      final List<String> extraCustomTabs;
      if (options.containsKey(KEY_EXTRA_CUSTOM_TABS)) {
        extraCustomTabs = ((List<String>) options.get(KEY_EXTRA_CUSTOM_TABS));
      } else {
        extraCustomTabs = null;
      }
      launcher.launch(context, uri, customTabsIntent, extraCustomTabs);
      result.success(null);
    } catch (ActivityNotFoundException e) {
      result.error(CODE_LAUNCH_ERROR, e.getMessage(), null);
    }
  }
}
