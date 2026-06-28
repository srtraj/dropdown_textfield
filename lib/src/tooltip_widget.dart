import 'package:flutter/material.dart';

/// Displays an info icon that, when tapped, shows an overlay dialog
/// with the provided tooltip message.
class ToolTipWidget extends StatefulWidget {
  const ToolTipWidget({super.key, required this.msg});

  final String msg;

  @override
  State<ToolTipWidget> createState() => _ToolTipWidgetState();
}

class _ToolTipWidgetState extends State<ToolTipWidget> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'More info',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showOverlay(context),
        child: const Icon(
          Icons.info_outlined,
          size: 20,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    final overlayState = Overlay.of(context);
    const double iconSize = 70;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Barrier — tap to dismiss
          GestureDetector(
            onTap: _closeOverlay,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
          Positioned.fill(
            child: Align(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).shadowColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: SizedBox(
                          height: iconSize,
                          width: iconSize,
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 600),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (_, value, _) => Icon(
                              Icons.info_outlined,
                              size: iconSize * value,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.msg,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _closeOverlay,
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void _closeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _closeOverlay();
    super.dispose();
  }
}
