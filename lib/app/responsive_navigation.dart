import 'package:flutter/material.dart';

import 'haptics.dart';
import 'responsive.dart';

enum AdaptiveModalContentLayout { wrapContent, fillHeight }

final class ResponsiveNavigation {
  const ResponsiveNavigation._();

  static Future<T?> showAdaptiveModalPage<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double? maxWidth,
    bool showCloseButton = true,
    bool showDragHandle = true,
    bool barrierDismissible = true,
    AdaptiveModalContentLayout contentLayout =
        AdaptiveModalContentLayout.wrapContent,
  }) {
    final spec = context.layoutType(ResponsivePageType.modal);
    if (!context.isLargeScreen) {
      return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: showDragHandle,
        builder: (_) => child,
      );
    }

    final height =
        MediaQuery.sizeOf(context).height * spec.modalMaxHeightFactor;
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? spec.modalWidth,
            maxHeight: height,
          ),
          child: _AdaptiveModalFrame(
            title: title,
            showCloseButton: showCloseButton,
            contentLayout: contentLayout,
            child: child,
          ),
        ),
      ),
    );
  }
}

final class _AdaptiveModalFrame extends StatelessWidget {
  const _AdaptiveModalFrame({
    required this.child,
    required this.showCloseButton,
    required this.contentLayout,
    this.title,
  });

  final Widget child;
  final String? title;
  final bool showCloseButton;
  final AdaptiveModalContentLayout contentLayout;

  @override
  Widget build(BuildContext context) {
    final header = title == null && !showCloseButton
        ? null
        : Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
            child: Row(
              children: [
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                else
                  const Spacer(),
                if (showCloseButton)
                  IconButton(
                    onPressed: () {
                      Haptics.light();
                      Navigator.of(context).pop();
                    },
                    tooltip: 'Close',
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
          );

    final body = contentLayout == AdaptiveModalContentLayout.fillHeight
        ? Expanded(child: child)
        : Flexible(child: SingleChildScrollView(child: child));

    return Column(mainAxisSize: MainAxisSize.min, children: [?header, body]);
  }
}
