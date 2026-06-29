import 'package:flutter/material.dart';

import 'models.dart';
import 'tooltip_widget.dart';

/// Internal widget that renders the multi-selection dropdown list with
/// checkboxes and a submit button.
class MultiSelection extends StatefulWidget {
  const MultiSelection({
    super.key,
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
    this.checkBoxProperty,
    this.buttonDecoration,
    this.listBackgroundColor,
    this.textAlign,
    this.textDirection,
    required this.maxLines,
  });

  final List<DropDownValueModel> dropDownList;

  /// Called with the updated boolean selection list when the user taps submit.
  final ValueSetter<List<bool>> onChanged;
  final List<bool> list;
  final double height;
  final Color? buttonColor;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final double listTileHeight;
  final TextStyle? listTextStyle;
  final ListPadding listPadding;
  final CheckBoxProperty? checkBoxProperty;
  final BoxDecoration? buttonDecoration;
  final Color? listBackgroundColor;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int maxLines;

  @override
  State<MultiSelection> createState() => _MultiSelectionState();
}

class _MultiSelectionState extends State<MultiSelection> {
  late List<bool> _selectionState;

  @override
  void initState() {
    super.initState();
    _selectionState = List.from(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildList(), _buildSubmitRow(context)]);
  }

  Widget _buildList() {
    return SizedBox(
      height: widget.height,
      child: Scrollbar(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.dropDownList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = widget.dropDownList[index];
            final isSelected = _selectionState[index];

            return SizedBox(
              height:
                  widget.listTileHeight +
                  widget.listPadding.top +
                  widget.listPadding.bottom,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: widget.listPadding.bottom,
                  top: widget.listPadding.top,
                ),
                child: Semantics(
                  label: item.name,
                  button: true,
                  child: Material(
                    color: isSelected && widget.listBackgroundColor != null
                        ? widget.listBackgroundColor
                        : Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () {
                        setState(() {
                          _selectionState[index] = !_selectionState[index];
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              isSelected && widget.listBackgroundColor != null
                              ? 8.0
                              : 0.0,
                        ),
                        child: Directionality(
                          textDirection:
                              widget.textDirection ??
                              Directionality.of(context),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            item.prefixWidget ??
                                                const SizedBox.shrink(),
                                            Expanded(
                                              child:
                                                  item.customListItem ??
                                                  Text(
                                                    item.name,
                                                    style: widget.listTextStyle,
                                                    textAlign: widget.textAlign,
                                                    maxLines: widget.maxLines,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (item.toolTipMsg != null)
                                        ToolTipWidget(msg: item.toolTipMsg!),
                                    ],
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: _selectionState[index],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectionState[index] = value;
                                    });
                                  }
                                },
                                tristate:
                                    widget.checkBoxProperty?.tristate ?? false,
                                mouseCursor:
                                    widget.checkBoxProperty?.mouseCursor,
                                activeColor:
                                    widget.checkBoxProperty?.activeColor,
                                fillColor: widget.checkBoxProperty?.fillColor,
                                checkColor: widget.checkBoxProperty?.checkColor,
                                focusColor: widget.checkBoxProperty?.focusColor,
                                hoverColor: widget.checkBoxProperty?.hoverColor,
                                overlayColor:
                                    widget.checkBoxProperty?.overlayColor,
                                splashRadius:
                                    widget.checkBoxProperty?.splashRadius,
                                materialTapTargetSize: widget
                                    .checkBoxProperty
                                    ?.materialTapTargetSize,
                                visualDensity:
                                    widget.checkBoxProperty?.visualDensity,
                                focusNode: widget.checkBoxProperty?.focusNode,
                                shape: widget.checkBoxProperty?.shape,
                                side: widget.checkBoxProperty?.side,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubmitRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const Expanded(child: SizedBox.shrink()),
        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
            left: 8.0,
            top: 15,
            bottom: 10,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => widget.onChanged(_selectionState),
              child: Container(
                height: widget.listTileHeight * 0.9,
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 12,
                ),
                decoration:
                    widget.buttonDecoration ??
                    BoxDecoration(
                      color: widget.buttonColor ?? theme.colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                child: Align(
                  child: FittedBox(
                    child: Text(
                      widget.buttonText ?? 'Ok',
                      style:
                          widget.buttonTextStyle ??
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
