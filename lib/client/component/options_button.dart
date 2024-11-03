import 'package:budgetman/client/presentation/budget/budget_page.dart';
import 'package:budgetman/client/presentation/categories/categories_page.dart';
import 'package:budgetman/client/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class OptionsButton extends StatefulWidget {
  const OptionsButton({
    super.key,
    required this.locate,
  });

  final String locate;

  @override
  State<OptionsButton> createState() => _OptionsButtonState();
}

class _OptionsButtonState extends State<OptionsButton> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  bool isClicked = false;
  OverlayEntry? _overlayEntry;

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.bottomRight,
            child: TapRegion(
              onTapOutside: (t) {
                _removeOverlay();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(maxWidth: 220),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.add_circle_outline,
                          color: Theme.of(context).colorScheme.onPrimaryContainer),
                      title: Text(
                        widget.locate == HomePage.routeName
                            ? 'Add Budget'
                            : widget.locate == BudgetPage.routeName
                                ? 'Add List'
                                : 'Add Categories',
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                      onTap: () {
                        _removeOverlay();
                      },
                    ),
                    if (widget.locate == BudgetPage.routeName)
                      Divider(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    if (widget.locate == BudgetPage.routeName)
                      ListTile(
                        leading: Icon(
                          Icons.edit_outlined,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        title: Text(
                          'Edit List',
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        onTap: () {
                          _removeOverlay();
                        },
                      ),
                    if (widget.locate != CategoriesPage.routeName)
                      Divider(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    if (widget.locate != CategoriesPage.routeName)
                      ListTile(
                        leading: Icon(
                          Icons.folder_outlined,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        title: Text(
                          'Edit Categories',
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        onTap: () {
                          _removeOverlay();
                          context.go('/${CategoriesPage.routeName}');
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).animate().fadeIn(delay: 0.25.seconds, duration: 0.25.seconds),
    );
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(context);
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      controller?.reverse();
      isClicked = !isClicked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      target: isClicked ? 1 : 0,
      onComplete: (controller) {
        this.controller = controller;
        controller.stop();
      },
      effects: [
        FadeEffect(
          begin: 1,
          end: 0,
          duration: 0.25.seconds,
          curve: Curves.easeInOut,
        ),
        ScaleEffect(
          begin: const Offset(1, 1),
          end: const Offset(0.1, 0.1),
          curve: Curves.easeInOut,
          duration: 0.25.seconds,
        ),
      ],
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          if (controller?.isAnimating ?? false) return;
          controller?.forward();
          isClicked = !isClicked;
          _showOverlay(context);
        },
        child: const Icon(Icons.more_horiz),
      ),
    );
  }
}
