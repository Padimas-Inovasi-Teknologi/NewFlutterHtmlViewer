import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_flutter_html_viewer/new_flutter_html_viewer.dart';
import 'package:new_flutter_html_viewer/src/custom_tabs_launcher.dart';

void main() {
  const MethodChannel channel = MethodChannel('new_flutter_html_viewer');

  TestWidgetsFlutterBinding.ensureInitialized();

  final log = <MethodCall>[];
  channel.setMockMethodCallHandler((methodCall) async => log.add(methodCall));

  tearDown(() => log.clear());

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('customTabLauncher() no options', () async {
    await customTabsLauncher('http://example.com/', const CustomTabsOption());
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'option': const <String, dynamic>{},
        }),
      ],
    );
  });

  test('customTabLauncher() contains options', () async {
    await customTabsLauncher(
      'http://example.com/',
      const CustomTabsOption(
        toolbarColor: const Color(0xFFFFEBEE),
        enableUrlBarHiding: true,
        enableDefaultShare: false,
        showPageTitle: true,
        enableInstantApps: false,
        animation: const CustomTabsAnimation(
          startEnter: '_startEnter',
          startExit: '_startExit',
          endEnter: '_endEnter',
          endExit: '_endExit',
        ),
        extraCustomTabs: <String>[
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
    );
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'option': const <String, dynamic>{
            'toolbarColor': '#ffffebee',
            'enableUrlBarHiding': true,
            'enableDefaultShare': false,
            'showPageTitle': true,
            'enableInstantApps': false,
            'animations': <String, String>{
              'startEnter': '_startEnter',
              'startExit': '_startExit',
              'endEnter': '_endEnter',
              'endExit': '_endExit',
            },
            'extraCustomTabs': <String>[
              'org.mozilla.firefox',
              'com.microsoft.emmx',
            ],
          },
        }),
      ],
    );
  });
}
