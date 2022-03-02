import 'package:flutter/material.dart';

class ToolTipWidget extends StatefulWidget {
  const ToolTipWidget({Key? key, required this.msg}) : super(key: key);
  final String msg;

  @override
  State<ToolTipWidget> createState() => _ToolTipWidgetState();
}

class _ToolTipWidgetState extends State<ToolTipWidget> {
  late OverlayEntry overlayEntry;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // toolTipDialogue(context: context, msg: widget.msg);
        _showOverlay(context);
      },
      child: const Icon(
        Icons.info_outlined,
        size: 20,
        color: Colors.blueAccent,
      ),
    );
  }

  toolTipDialogue({required BuildContext context, required String msg}) {
    showAnimatedAlertDialog(
        context: context,
        content: Text(msg),
        icon: Icons.info_outlined,
        iconColor: Colors.blue,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            color: Colors.lightBlueAccent,
            child: const Text(
              "Ok",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]);
  }

  showAnimatedAlertDialog(
      {required BuildContext context,
      required Widget content,
      required List<Widget> actions,
      MainAxisAlignment? actionsAlignment,
      required IconData icon,
      Color? iconColor}) {
    double size = 100;
    AlertDialog alert = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        actionsPadding: const EdgeInsets.only(right: 20),
        title: Center(
          child: SizedBox(
            height: size,
            width: size,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (BuildContext context, double value, child) {
                return Icon(
                  icon,
                  size: size * value,
                  color: iconColor ?? Colors.amber,
                );
              },
            ),
          ),
        ),
        content: content,
        actionsAlignment: actionsAlignment,
        actions: actions);

    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(opacity: a1.value, child: alert),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox.shrink();
        });
  }

  void _showOverlay(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    double size = 70;
    overlayEntry = OverlayEntry(builder: (context) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.withOpacity(0.5),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: SizedBox(
                        height: size,
                        width: size,
                        child: TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 600),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (BuildContext context, double value, child) {
                            return Icon(Icons.info_outlined,
                                size: size * value, color: Colors.blue);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.msg,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Colors.lightBlueAccent,
                      child: const Text(
                        "Ok",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        closeOverlay();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
    overlayState?.insert(overlayEntry);
  }

  closeOverlay() {
    overlayEntry.remove();
  }
}
