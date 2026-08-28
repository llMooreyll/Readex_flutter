import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/articles/presentation/widgets/article_preview_sheet.dart';
import 'app_router.dart';
import 'providers.dart';
import 'responsive_navigation.dart';
import 'shared_link_service.dart';

final sharedLinkServiceProvider = Provider<SharedLinkService>((ref) {
  final service = SharedLinkService();
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
});

final class SharedLinkListener extends ConsumerStatefulWidget {
  const SharedLinkListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SharedLinkListener> createState() => _SharedLinkListenerState();
}

final class _SharedLinkListenerState extends ConsumerState<SharedLinkListener> {
  StreamSubscription<String>? _subscription;
  var _handlingUrl = false;
  String? _queuedUrl;

  @override
  void initState() {
    super.initState();
    final service = ref.read(sharedLinkServiceProvider);
    _subscription = service.sharedUrls.listen(_handleSharedUrl);
    unawaited(service.start());
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  Future<void> _handleSharedUrl(String url) async {
    if (_handlingUrl) {
      _queuedUrl = url;
      return;
    }

    _handlingUrl = true;
    try {
      var currentUrl = url;
      while (mounted) {
        await _prepareAndPreview(currentUrl);
        final nextUrl = _queuedUrl;
        if (nextUrl == null) {
          break;
        }
        _queuedUrl = null;
        currentUrl = nextUrl;
      }
    } finally {
      _handlingUrl = false;
    }
  }

  Future<void> _prepareAndPreview(String url) async {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null || !mounted) {
      return;
    }

    ScaffoldMessenger.of(navigatorContext)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Importing shared link...'),
          duration: Duration(seconds: 2),
        ),
      );

    final controller = ref.read(saveArticleControllerProvider.notifier);
    final draft = await controller.prepare(url);
    if (!mounted) {
      return;
    }

    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return;
    }

    if (draft == null) {
      final failure = ref.read(saveArticleControllerProvider).failure;
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              failure?.message ?? 'The shared link could not be imported.',
            ),
          ),
        );
      return;
    }

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final saved = await ResponsiveNavigation.showAdaptiveModalPage<bool>(
      context: context,
      child: ArticlePreviewSheet(draft: draft),
    );
    if (!mounted || !context.mounted || saved != true) {
      return;
    }

    final latestContext = rootNavigatorKey.currentContext;
    if (latestContext == null || !latestContext.mounted) {
      return;
    }
    ScaffoldMessenger.of(latestContext)
        .showSnackBar(const SnackBar(content: Text('Article saved.')));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
