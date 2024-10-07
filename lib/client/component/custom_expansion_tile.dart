import 'package:flutter/material.dart';

class CustomExpansionTile extends ExpansionTile {
  CustomExpansionTile({
    super.key,
    super.initiallyExpanded = true,
    bool showBorder = true,
    required BuildContext context,
    super.leading,
    required String title,
    String? subtitle,
    super.trailing,
    List<Widget> children = const [],
  }) : super(
          expansionAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut,
          ),
          shape: showBorder ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ) : null,
          collapsedShape: showBorder ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ) : null,
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : null,
          children: [
            for (final child in children) ...[
              const Divider(),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 90,
                ),
                child: child,
              ),
            ],
          ],
        );
}
