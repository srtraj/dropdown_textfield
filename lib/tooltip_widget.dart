import 'package:flutter/material.dart';

class ToolTipWidget extends StatefulWidget {
  const ToolTipWidget(
      {Key? key, required this.msg, this.outSideClickToClose = true})
      : super(key: key);
  final String msg;
  final bool outSideClickToClose;

  @override
  State<ToolTipWidget> createState() => _ToolTipWidgetState();
}

class _ToolTipWidgetState extends State<ToolTipWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        toolTipDialogue(context: context, msg: widget.msg);
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
              Navigator.of(context, rootNavigator: true).pop();
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
}
