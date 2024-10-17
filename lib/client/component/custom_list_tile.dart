import 'package:budgetman/extension.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.enableTrailingConstraints = true,
    this.trailingConstraints,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final bool enableTrailingConstraints;
  final BoxConstraints? trailingConstraints;

  @override
  State<CustomListTile> createState() => CustomListTileState();
}

class CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              widget.leading,
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
          Flexible(
            child: Builder(builder: (context) {
              if (!widget.enableTrailingConstraints) {
                return widget.trailing;
              }
              return ConstrainedBox(
                constraints: widget.trailingConstraints ??
                    BoxConstraints(
                      maxWidth: [40.w, 300].min.toDouble(),
                    ),
                child: widget.trailing,
              );
            }),
          ),
        ],
      ),
    );
  }
}
