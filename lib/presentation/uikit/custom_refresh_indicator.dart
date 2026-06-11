// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';

const double _kActivityIndicatorRadius = 14.0;
const double _kActivityIndicatorMargin = 16.0;

class CustomRefreshIndicator extends StatelessWidget {
  final RefreshIndicatorMode refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;
  const CustomRefreshIndicator({Key? key, required this.refreshState, required this.pulledExtent, required this.refreshTriggerPullDistance, required this.refreshIndicatorExtent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentageComplete = (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: _kActivityIndicatorMargin,
            left: 0.0,
            right: 0.0,
            child: RefreshStateIndicator(refreshState: refreshState, radius: _kActivityIndicatorRadius, percentageComplete: percentageComplete),
          ),
        ],
      ),
    );
  }
}

class RefreshStateIndicator extends StatelessWidget {
  final RefreshIndicatorMode refreshState;
  final double radius;
  final double percentageComplete;
  const RefreshStateIndicator({Key? key, required this.refreshState, required this.radius, required this.percentageComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        // While we're dragging, we draw individual ticks of the spinner while simultaneously
        // easing the opacity in. Note that the opacity curve values here were derived using
        // Xcode through inspecting a native app running on iOS 13.5.
        const Curve opacityCurve = Interval(0.0, 0.55, curve: Curves.easeInOut);
        return Opacity(
          opacity: opacityCurve.transform(percentageComplete),
          child: const Loader(
            size: 30,
            color: AppColors.green,
          ),
        );
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        // Once we're armed or performing the refresh, we just show the normal spinner.
        return const Loader(
          size: 30,
          color: AppColors.green,
        );
      case RefreshIndicatorMode.done:
        // When the user lets go, the standard transition is to shrink the spinner.
        return const Loader(
          size: 30,
          color: AppColors.green,
        );
      case RefreshIndicatorMode.inactive:
        // Anything else doesn't show anything.
        return Container();
    }
  }
}
