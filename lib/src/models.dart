import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Customizes the dropdown or clear icon's appearance.
class IconProperty {
  final IconData? icon;
  final Color? color;
  final double? size;

  const IconProperty({this.icon, this.color, this.size});
}

/// Customizes the appearance and behavior of the multi-selection checkbox.
class CheckBoxProperty {
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlinedBorder? shape;
  final BorderSide? side;

  static const double width = 18.0;

  const CheckBoxProperty({
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
  });
}

/// Represents a single item in the dropdown list.
class DropDownValueModel extends Equatable {
  final String name;
  final dynamic value;
  final Widget? prefixWidget;

  /// Optional tooltip message. Currently only supported for multi-selection.
  final String? toolTipMsg;

  /// Optional custom widget to render in place of the default text.
  final Widget? customListItem;

  /// Optional display string for the text field, if different from [name].
  final String? displayValue;

  const DropDownValueModel({
    required this.name,
    required this.value,
    this.prefixWidget,
    this.toolTipMsg,
    this.customListItem,
    this.displayValue,
  });

  factory DropDownValueModel.fromJson(Map<String, dynamic> json) =>
      DropDownValueModel(
        name: json['name'] as String,
        value: json['value'],
        prefixWidget: json['prefixWidget'] as Widget?,
        toolTipMsg: json['toolTipMsg'] as String?,
        customListItem: json['customListItem'] as Widget?,
        displayValue: json['displayValue'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
    'prefixWidget': prefixWidget,
    'toolTipMsg': toolTipMsg,
    'customListItem': customListItem,
    'displayValue': displayValue,
  };

  @override
  List<Object?> get props => [
    name,
    value,
    prefixWidget,
    toolTipMsg,
    customListItem,
    displayValue,
  ];
}

/// Controls per-item vertical padding in the dropdown list.
class ListPadding {
  final double top;
  final double bottom;

  const ListPadding({this.top = 15, this.bottom = 15});
}
