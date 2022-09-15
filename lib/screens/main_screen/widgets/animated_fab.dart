import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnimatedFAB extends StatelessWidget {
  final Widget openWidget;
  const AnimatedFAB({
    Key? key, required this.openWidget,
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
      closedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0), bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0))),
      closedBuilder: (context, openContainer) =>  ConstrainedBox(
          constraints: const BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
          child: Center(
            child: Icon(
              Icons.add_comment_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        )
    );
  }
}