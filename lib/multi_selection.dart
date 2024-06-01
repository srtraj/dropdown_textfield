import 'package:dropdown_textfield/tooltip_widget.dart';
import 'package:flutter/material.dart';

import 'dropdown_textfield.dart';

class MultiSelection extends StatefulWidget {
  const MultiSelection(
      {Key? key,
      required this.onChanged,
      required this.dropDownList,
      required this.list,
      required this.height,
      this.buttonColor,
      this.buttonText,
      this.buttonTextStyle,
      required this.listTileHeight,
      required this.listPadding,
      this.listTextStyle,
      this.checkBoxProperty})
      : super(key: key);
  final List<DropDownValueModel> dropDownList;
  final ValueSetter onChanged;
  final List<bool> list;
  final double height;
  final Color? buttonColor;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final double listTileHeight;
  final TextStyle? listTextStyle;
  final ListPadding listPadding;
  final CheckBoxProperty? checkBoxProperty;

  @override
  _MultiSelectionState createState() => _MultiSelectionState();
}

class _MultiSelectionState extends State<MultiSelection> {
  List<bool> multiSelectionValue = [];

  @override
  void initState() {
    multiSelectionValue = List.from(widget.list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: Scrollbar(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.dropDownList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: widget.listTileHeight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: widget.listPadding.bottom,
                          top: widget.listPadding.top),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(widget.dropDownList[index].name,
                                        style: widget.listTextStyle),
                                  ),
                                  if (widget.dropDownList[index].toolTipMsg !=
                                      null)
                                    ToolTipWidget(
                                        msg: widget
                                            .dropDownList[index].toolTipMsg!)
                                ],
                              ),
                            ),
                          ),
                          Checkbox(
                            value: multiSelectionValue[index],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  multiSelectionValue[index] = value;
                                });
                              }
                            },
                            tristate:
                                widget.checkBoxProperty?.tristate ?? false,
                            mouseCursor: widget.checkBoxProperty?.mouseCursor,
                            activeColor: widget.checkBoxProperty?.activeColor,
                            fillColor: widget.checkBoxProperty?.fillColor,
                            checkColor: widget.checkBoxProperty?.checkColor,
                            focusColor: widget.checkBoxProperty?.focusColor,
                            hoverColor: widget.checkBoxProperty?.hoverColor,
                            overlayColor: widget.checkBoxProperty?.overlayColor,
                            splashRadius: widget.checkBoxProperty?.splashRadius,
                            materialTapTargetSize:
                                widget.checkBoxProperty?.materialTapTargetSize,
                            visualDensity:
                                widget.checkBoxProperty?.visualDensity,
                            focusNode: widget.checkBoxProperty?.focusNode,
                            autofocus:
                                widget.checkBoxProperty?.autofocus ?? false,
                            shape: widget.checkBoxProperty?.shape,
                            side: widget.checkBoxProperty?.side,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
        Row(
          children: [
            const Expanded(
              child: SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 8.0, left: 8.0, top: 15, bottom: 10),
              child: InkWell(
                onTap: () => widget.onChanged(multiSelectionValue),
                child: Container(
                  height: widget.listTileHeight * 0.9,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
                  decoration: BoxDecoration(
                      color: widget.buttonColor ?? Colors.green,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Align(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.buttonText ?? "Ok",
                        style: widget.buttonTextStyle ??
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
