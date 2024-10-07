import 'package:flutter/material.dart';

class CustomExpansionTile extends ExpansionTile {
  CustomExpansionTile({
    super.key,
    required BuildContext context,
    super.leading,
    required String title,
    String? subtitle,
    super.trailing,
    List<Widget> children = const [],
  }) : super(
          initiallyExpanded: true,
          expansionAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
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
