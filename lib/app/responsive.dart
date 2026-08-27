import 'package:flutter/widgets.dart';

enum DeviceType { compact, mobile, tablet, desktop }

enum ResponsivePageType { shell, browse, detail, modal }

final class ResponsiveLayoutSpec {
  const ResponsiveLayoutSpec({
    required this.maxWidth,
    required this.horizontalPadding,
    required this.preferTwoPane,
    required this.modalWidth,
    required this.modalMaxHeightFactor,
  });

  final double maxWidth;
  final double horizontalPadding;
  final bool preferTwoPane;
  final double modalWidth;
  final double modalMaxHeightFactor;
}

extension ResponsiveContext on BuildContext {
  DeviceType get deviceType {
    final width = MediaQuery.sizeOf(this).width;
    if (width < 350) {
      return DeviceType.compact;
    }
    if (width < 600) {
      return DeviceType.mobile;
    }
    if (width < 900) {
      return DeviceType.tablet;
    }
    return DeviceType.desktop;
  }

  bool get isLargeScreen =>
      deviceType == DeviceType.tablet || deviceType == DeviceType.desktop;

  bool get isDesktop => deviceType == DeviceType.desktop;

  T responsive<T>({required T compact, T? mobile, T? tablet, T? desktop}) {
    return switch (deviceType) {
      DeviceType.compact => compact,
      DeviceType.mobile => mobile ?? compact,
      DeviceType.tablet => tablet ?? mobile ?? compact,
      DeviceType.desktop => desktop ?? tablet ?? mobile ?? compact,
    };
  }

  ResponsiveLayoutSpec layoutType(ResponsivePageType type) {
    final horizontalPadding = responsive(
      compact: 16.0,
      mobile: 20.0,
      tablet: 28.0,
      desktop: 32.0,
    );

    return switch (type) {
      ResponsivePageType.shell => ResponsiveLayoutSpec(
        maxWidth: responsive(
          compact: double.infinity,
          mobile: double.infinity,
          tablet: 960,
          desktop: 1200,
        ),
        horizontalPadding: horizontalPadding,
        preferTwoPane: isDesktop,
        modalWidth: 560,
        modalMaxHeightFactor: 0.9,
      ),
      ResponsivePageType.browse => ResponsiveLayoutSpec(
        maxWidth: responsive(
          compact: double.infinity,
          mobile: double.infinity,
          tablet: 860,
          desktop: 1120,
        ),
        horizontalPadding: horizontalPadding,
        preferTwoPane: isDesktop,
        modalWidth: 560,
        modalMaxHeightFactor: 0.9,
      ),
      ResponsivePageType.detail => ResponsiveLayoutSpec(
        maxWidth: 720,
        horizontalPadding: horizontalPadding,
        preferTwoPane: false,
        modalWidth: 560,
        modalMaxHeightFactor: 0.9,
      ),
      ResponsivePageType.modal => ResponsiveLayoutSpec(
        maxWidth: responsive(
          compact: double.infinity,
          mobile: double.infinity,
          tablet: 540,
          desktop: 560,
        ),
        horizontalPadding: horizontalPadding,
        preferTwoPane: false,
        modalWidth: responsive(
          compact: double.infinity,
          mobile: double.infinity,
          tablet: 540,
          desktop: 560,
        ),
        modalMaxHeightFactor: responsive(
          compact: 0.92,
          mobile: 0.9,
          tablet: 0.88,
          desktop: 0.86,
        ),
      ),
    };
  }
}

final class ResponsivePageContainer extends StatelessWidget {
  const ResponsivePageContainer({
    required this.pageType,
    required this.child,
    super.key,
  });

  final ResponsivePageType pageType;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spec = context.layoutType(pageType);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: spec.maxWidth),
        child: child,
      ),
    );
  }
}
