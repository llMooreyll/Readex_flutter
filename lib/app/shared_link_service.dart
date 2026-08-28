import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

final class SharedLinkService {
  SharedLinkService();

  static const _channel = MethodChannel('readex/share_intents');

  final _controller = StreamController<String>.broadcast();
  var _started = false;

  Stream<String> get sharedUrls => _controller.stream;

  Future<void> start() async {
    if (_started) {
      return;
    }
    _started = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method != 'sharedUrl') {
        return;
      }
      final url = call.arguments;
      if (url is String && url.trim().isNotEmpty) {
        _controller.add(url.trim());
      }
    });

    try {
      final initialUrl = await _channel.invokeMethod<String>(
        'getInitialSharedUrl',
      );
      if (initialUrl != null && initialUrl.trim().isNotEmpty) {
        _controller.add(initialUrl.trim());
      }
    } on MissingPluginException {
      // Non-Android builds and widget tests do not expose this channel.
    } on PlatformException catch (error) {
      debugPrint('Shared link channel failed: ${error.message}');
    }
  }

  Future<void> dispose() async {
    _channel.setMethodCallHandler(null);
    await _controller.close();
  }
}
