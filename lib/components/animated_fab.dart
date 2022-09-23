import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnimatedFAB extends StatelessWidget {
  final Widget openWidget;
  final String label;
  final IconData icon;
  const AnimatedFAB({
    Key? key,
    required this.openWidget,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, _) => openWidget,
      openColor: Theme.of(context).colorScheme.background,
      openElevation: 0,
      closedColor: Theme.of(context).colorScheme.primaryContainer,
      closedElevation: 6,
      tappable: false,
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      )),
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: openContainer,
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(
              height: 56.0,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 16.0, end: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                      SizedBox(width: 8.0),
                  Text(
                    label,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
