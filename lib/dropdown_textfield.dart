import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'src/controllers.dart';
import 'src/keyboard_visibility_builder.dart';
import 'src/models.dart';
import 'src/multi_selection.dart';
import 'src/single_selection.dart';

export 'src/controllers.dart';
export 'src/models.dart';

/// A material-design TextField that opens a searchable dropdown list
/// on tap, supporting both single and multi-value selection.
///
/// Use the default constructor for single-selection and
/// [DropDownTextField.multiSelection] for multi-value selection.
///
/// ### Single selection example
/// ```dart
/// DropDownTextField(
///   dropDownList: const [
///     DropDownValueModel(name: 'One', value: 1),
///     DropDownValueModel(name: 'Two', value: 2),
///   ],
///   onChanged: (val) => print(val),
/// )
/// ```
///
/// ### Multi selection example
/// ```dart
/// DropDownTextField.multiSelection(
///   dropDownList: const [
///     DropDownValueModel(name: 'Flutter', value: 'flutter'),
///     DropDownValueModel(name: 'Dart', value: 'dart'),
///   ],
///   onChanged: (val) => print(val),
/// )
/// ```
class DropDownTextField extends StatefulWidget {
  // ── Single-selection constructor ──────────────────────────────────────────

  const DropDownTextField({
    super.key,
    this.controller,
    this.initialValue,
    required this.dropDownList,
    this.padding,
    this.textStyle,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.enableSearch = false,
    this.readOnly = true,
    this.dropdownRadius = 12,
    this.textFieldDecoration,
    this.dropDownIconProperty,
    this.dropDownItemCount = 6,
    this.searchTextStyle,
    this.searchFocusNode,
    this.textFieldFocusNode,
    this.searchAutofocus = false,
    this.searchDecoration,
    this.searchShowCursor,
    this.searchKeyboardType,
    this.listSpace = 0,
    this.clearOption = true,
    this.clearIconProperty,
    this.listPadding,
    this.listTextStyle,
    this.keyboardType,
    this.autovalidateMode,
    this.boxDecoration,
    this.boxMargin,
  }) : assert(
         !(initialValue != null && controller != null),
         'You cannot provide both initialValue and controller. '
         'Set the initial value via SingleValueDropDownController(data: value).',
       ),
       assert(
         !(!readOnly && enableSearch),
         'readOnly must be true when enableSearch is true.',
       ),
       assert(
         controller == null || controller is SingleValueDropDownController,
         'controller must be a SingleValueDropDownController, '
         'not a MultiValueDropDownController.',
       ),
       checkBoxProperty = null,
       isMultiSelection = false,
       singleController = controller as SingleValueDropDownController?,
       multiController = null,
       displayCompleteItem = false,
       submitButtonColor = null,
       submitButtonText = null,
       submitButtonTextStyle = null;

  // ── Multi-selection constructor ───────────────────────────────────────────

  const DropDownTextField.multiSelection({
    super.key,
    this.controller,
    this.displayCompleteItem = false,
    this.initialValue,
    required this.dropDownList,
    this.padding,
    this.textStyle,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.dropdownRadius = 12,
    this.dropDownIconProperty,
    this.textFieldDecoration,
    this.dropDownItemCount = 6,
    this.searchFocusNode,
    this.textFieldFocusNode,
    this.listSpace = 0,
    this.clearOption = true,
    this.clearIconProperty,
    this.submitButtonColor,
    this.submitButtonText,
    this.submitButtonTextStyle,
    this.listPadding,
    this.listTextStyle,
    this.checkBoxProperty,
    this.autovalidateMode,
    this.boxDecoration,
    this.boxMargin,
  }) : assert(
         initialValue == null || controller == null,
         'You cannot provide both initialValue and controller. '
         'Set the initial value via MultiValueDropDownController(data: values).',
       ),
       assert(
         controller == null || controller is MultiValueDropDownController,
         'controller must be a MultiValueDropDownController, '
         'not a SingleValueDropDownController.',
       ),
       multiController = controller as MultiValueDropDownController?,
       isMultiSelection = true,
       enableSearch = false,
       readOnly = true,
       searchTextStyle = null,
       searchAutofocus = false,
       searchKeyboardType = null,
       searchShowCursor = null,
       singleController = null,
       searchDecoration = null,
       keyboardType = null;

  // ── Shared fields ─────────────────────────────────────────────────────────

  /// The dropdown controller. Pass a [SingleValueDropDownController] for
  /// single-selection and a [MultiValueDropDownController] for multi-selection.
  ///
  /// Both types share the sealed base [DropDownController], so the Dart
  /// type-checker prevents passing unrelated objects.
  final DropDownController? controller;

  /// Typed reference for single-selection controller (derived from [controller]).
  final SingleValueDropDownController? singleController;

  /// Typed reference for multi-selection controller (derived from [controller]).
  final MultiValueDropDownController? multiController;

  /// The radius of the dropdown list container. Defaults to 12.
  final double dropdownRadius;

  /// Initial selection value. Mutually exclusive with [controller].
  /// For multi-selection, provide a `List<String>` of item names.
  final dynamic initialValue;

  /// The list of items to display in the dropdown.
  final List<DropDownValueModel> dropDownList;

  /// Called when the selection changes.
  /// Returns a [DropDownValueModel] for single-selection and
  /// a `List<DropDownValueModel>` for multi-selection.
  final ValueSetter<dynamic>? onChanged;

  /// Whether multi-selection mode is active. Set internally via constructors.
  final bool isMultiSelection;

  /// Text style applied to the selected value in the text field.
  final TextStyle? textStyle;

  /// Padding around the text field.
  final EdgeInsets? padding;

  /// Overrides the default [InputDecoration] of the text field.
  final InputDecoration? textFieldDecoration;

  /// Customizes the dropdown arrow icon.
  final IconProperty? dropDownIconProperty;

  /// Whether the text field is interactive. Defaults to `true`.
  final bool isEnabled;

  /// Validation function for the text field.
  final FormFieldValidator<String>? validator;

  /// Enables a search field inside the dropdown (single-selection only).
  final bool enableSearch;

  /// When `false`, the text field accepts typed input alongside the dropdown.
  final bool readOnly;

  /// When `true`, multi-selection shows the full comma-separated list
  /// instead of "N items selected".
  final bool displayCompleteItem;

  /// Maximum number of visible list items before scrolling. Defaults to 6.
  final int dropDownItemCount;

  final FocusNode? searchFocusNode;
  final FocusNode? textFieldFocusNode;

  /// Text style for the search field.
  final TextStyle? searchTextStyle;

  /// Overrides the default decoration of the search field.
  final InputDecoration? searchDecoration;

  /// Keyboard type for the search field. Only used when [enableSearch] is `true`.
  final TextInputType? searchKeyboardType;

  /// Auto-focuses the search field when the dropdown opens. Defaults to `false`.
  final bool searchAutofocus;

  /// When `false`, hides the cursor in the search field.
  final bool? searchShowCursor;

  /// When `false`, hides the clear suffix icon. Defaults to `true`.
  final bool clearOption;

  /// Customizes the clear icon.
  final IconProperty? clearIconProperty;

  /// Vertical gap between the text field and the dropdown list. Defaults to 0.
  final double listSpace;

  /// Per-item padding inside the dropdown list.
  final ListPadding? listPadding;

  /// Submit button label for multi-selection. Defaults to "Ok".
  final String? submitButtonText;

  /// Submit button background color for multi-selection.
  final Color? submitButtonColor;

  /// Submit button text style for multi-selection.
  final TextStyle? submitButtonTextStyle;

  /// Text style for dropdown list items.
  final TextStyle? listTextStyle;

  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;

  /// Overrides the default [BoxDecoration] of the dropdown container.
  final BoxDecoration? boxDecoration;

  /// Margin around the dropdown container.
  final EdgeInsets? boxMargin;

  /// Customizes the checkbox appearance in multi-selection mode.
  final CheckBoxProperty? checkBoxProperty;

  @override
  State<DropDownTextField> createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField>
    with TickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(
    curve: Curves.easeIn,
  );

  late TextEditingController _textController;
  late bool _isExpanded;
  OverlayEntry? _entry;
  OverlayEntry? _entry2;
  OverlayEntry? _barrierOverlay;
  final _layerLink = LayerLink();
  late AnimationController _animController;
  late Animation<double> _heightFactor;
  List<bool> _multiSelectionValue = [];
  late double _dropdownHeight;
  late List<DropDownValueModel> _dropDownList;
  late int _maxListItem;
  final double _searchWidgetHeight = 60;
  late FocusNode _searchFocusNode;
  late FocusNode _textFieldFocusNode;
  late bool _isOutsideClickOverlay;
  late bool _isScrollPadding;
  final int _animDurationMs = 150;
  late Offset _offset;
  late bool _searchAutofocus;
  late bool _isPortrait;
  late double _listTileHeight;
  final double _keyboardHeight = 450;
  late TextStyle _listTileTextStyle;
  late ListPadding _listPadding;
  late TextDirection _currentDirection;
  final GlobalKey _overlayKey = GlobalKey();

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _isScrollPadding = false;
    _isOutsideClickOverlay = false;
    _searchFocusNode = widget.searchFocusNode ?? FocusNode();
    _textFieldFocusNode = widget.textFieldFocusNode ?? FocusNode();
    _isExpanded = false;
    _searchAutofocus = false;

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animDurationMs),
    );
    _heightFactor = _animController.drive(_easeInTween);

    _searchFocusNode.addListener(_onSearchFocusChanged);
    _textFieldFocusNode.addListener(_onTextFieldFocusChanged);
    widget.singleController?.addListener(_onSingleControllerChanged);
    widget.multiController?.addListener(_onMultiControllerChanged);

    _initMultiSelectionState();
    _applyInitialValue();
    _updateDropdownState();
  }

  @override
  void didUpdateWidget(covariant DropDownTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateDropdownState(oldWidget: oldWidget);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _textFieldFocusNode.removeListener(_onTextFieldFocusChanged);
    widget.singleController?.removeListener(_onSingleControllerChanged);
    widget.multiController?.removeListener(_onMultiControllerChanged);
    if (widget.searchFocusNode == null) _searchFocusNode.dispose();
    if (widget.textFieldFocusNode == null) _textFieldFocusNode.dispose();
    if (_animController.isAnimating) _animController.stop();
    _animController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // ── Listeners ─────────────────────────────────────────────────────────────

  void _onSearchFocusChanged() {
    if (!_searchFocusNode.hasFocus &&
        !_textFieldFocusNode.hasFocus &&
        _isExpanded &&
        !widget.isMultiSelection) {
      _isExpanded = false;
      _hideOverlay();
    }
  }

  void _onTextFieldFocusChanged() {
    if (!_searchFocusNode.hasFocus &&
        !_textFieldFocusNode.hasFocus &&
        _isExpanded) {
      _isExpanded = false;
      _hideOverlay();
      if (!widget.readOnly &&
          widget.singleController?.dropDownValue?.name !=
              _textController.text) {
        setState(() => _textController.clear());
      }
    }
  }

  void _onSingleControllerChanged() {
    if (widget.singleController?.dropDownValue == null) {
      _clearSelection();
    }
  }

  void _onMultiControllerChanged() {
    if (widget.multiController?.dropDownValueList == null) {
      _clearSelection();
    }
  }

  // ── Initialization helpers ────────────────────────────────────────────────

  void _initMultiSelectionState() {
    _multiSelectionValue = List.filled(widget.dropDownList.length, false);
  }

  void _applyInitialValue() {
    if (widget.initialValue == null) return;
    _dropDownList = List.from(widget.dropDownList);

    if (widget.isMultiSelection) {
      for (int i = 0; i < (widget.initialValue as List).length; i++) {
        final idx = _dropDownList.indexWhere(
          (e) => e.name.trim() == widget.initialValue[i].trim(),
        );
        if (idx != -1) _multiSelectionValue[idx] = true;
      }
      final count = _multiSelectionValue.where((e) => e).length;
      _textController.text = count == 0
          ? ''
          : widget.displayCompleteItem
          ? (widget.initialValue as List<String>).join(',')
          : '$count item selected';
    } else {
      final idx = _dropDownList.indexWhere(
        (e) => e.name.trim() == (widget.initialValue as String).trim(),
      );
      if (idx != -1) _textController.text = widget.initialValue as String;
    }
  }

  void _updateDropdownState({DropDownTextField? oldWidget}) {
    final bool Function(dynamic, dynamic) eq =
        const DeepCollectionEquality().equals;
    _dropDownList = List.from(widget.dropDownList);
    _listPadding = widget.listPadding ?? const ListPadding();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (widget.isMultiSelection) {
        _syncMultiSelectionState(oldWidget, eq);
      } else {
        _syncSingleSelectionState();
      }

      _listTileTextStyle =
          (widget.listTextStyle ?? Theme.of(context).textTheme.titleMedium)!;
      _listTileHeight =
          _measureTextHeight('dummy Text', _listTileTextStyle) +
          _listPadding.top +
          _listPadding.bottom;
      _maxListItem = widget.dropDownItemCount;

      final visibleCount = _dropDownList.length < _maxListItem
          ? _dropDownList.length.toDouble()
          : _maxListItem.toDouble();
      _dropdownHeight = visibleCount * _listTileHeight + 10;
    });
  }

  void _syncMultiSelectionState(
    DropDownTextField? oldWidget,
    bool Function(dynamic, dynamic) eq,
  ) {
    if (oldWidget != null && !eq(oldWidget.dropDownList, _dropDownList)) {
      _multiSelectionValue = List.filled(_dropDownList.length, false);
      _textController.text = '';
    }

    if (widget.multiController != null) {
      if (widget.multiController?.dropDownValueList != null) {
        _multiSelectionValue = List.filled(_dropDownList.length, false);
        for (final selected in widget.multiController!.dropDownValueList!) {
          final idx = _dropDownList.indexOf(selected);
          if (idx != -1) _multiSelectionValue[idx] = true;
        }

        if (oldWidget?.displayCompleteItem != widget.displayCompleteItem) {
          final names = (widget.multiController?.dropDownValueList ?? [])
              .map((m) => m.name)
              .toList();
          final count = _multiSelectionValue.where((e) => e).length;
          _textController.text = count == 0
              ? ''
              : widget.displayCompleteItem
              ? names.join(',')
              : '$count item selected';
        }
      } else {
        _multiSelectionValue = List.filled(_dropDownList.length, false);
        _textController.text = '';
      }
    }
  }

  void _syncSingleSelectionState() {
    if (widget.singleController != null) {
      if (widget.singleController!.dropDownValue != null) {
        _textController.text = widget.singleController!.dropDownValue!.name;
      } else {
        _textController.clear();
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _currentDirection = Directionality.of(context);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (!isKeyboardVisible && _isExpanded && _isScrollPadding) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _shiftOverlayEntry2to1();
          });
        }
        return CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: _textController,
            focusNode: _textFieldFocusNode,
            keyboardType: widget.keyboardType,
            autovalidateMode: widget.autovalidateMode,
            style: widget.textStyle,
            enabled: widget.isEnabled,
            readOnly: widget.readOnly,
            onTapOutside: _onTapOutside,
            onTap: _onTextFieldTap,
            validator: (value) => widget.validator?.call(value),
            decoration: _buildInputDecoration(),
          ),
        );
      },
    );
  }

  void _onTapOutside(PointerDownEvent event) {
    final renderObject = _overlayKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final overlayPos = renderObject.localToGlobal(Offset.zero);
      final overlaySize = renderObject.size;
      final isOverlayTap =
          (overlayPos.dx <= event.position.dx &&
              event.position.dx <= overlayPos.dx + overlaySize.width) &&
          (overlayPos.dy <= event.position.dy &&
              event.position.dy <= overlayPos.dy + overlaySize.height);
      if (!isOverlayTap) _textFieldFocusNode.unfocus();
    }
  }

  void _onTextFieldTap() {
    _searchAutofocus = widget.searchAutofocus;
    if (!_isExpanded) {
      if (_dropDownList.isNotEmpty) _showOverlay();
    } else {
      if (widget.readOnly) _hideOverlay();
    }
  }

  InputDecoration _buildInputDecoration() {
    final suffixIcon = _buildSuffixIcon();
    return widget.textFieldDecoration != null
        ? widget.textFieldDecoration!.copyWith(suffixIcon: suffixIcon)
        : InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: 'Select Item',
            hintStyle: const TextStyle(fontWeight: FontWeight.normal),
            suffixIcon: suffixIcon,
          );
  }

  /// Builds the suffix icon — either the dropdown arrow or the clear button.
  Widget _buildSuffixIcon() {
    if (_textController.text.isEmpty || !widget.clearOption) {
      return Icon(
        widget.dropDownIconProperty?.icon ?? Icons.arrow_drop_down_outlined,
        size: widget.dropDownIconProperty?.size,
        color: widget.dropDownIconProperty?.color,
      );
    }
    return Semantics(
      label: 'Clear selection',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _clearSelection,
        child: Icon(
          widget.clearIconProperty?.icon ?? Icons.clear,
          size: widget.clearIconProperty?.size,
          color: widget.clearIconProperty?.color,
        ),
      ),
    );
  }

  // ── Overlay ───────────────────────────────────────────────────────────────

  Future<void> _showOverlay() async {
    _animController.forward();
    _isExpanded = true;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _offset = renderBox.localToGlobal(Offset.zero);

    final posFromTop = _offset.dy;
    final posFromBot = MediaQuery.of(context).size.height - posFromTop;
    final dropdownListHeight =
        _dropdownHeight +
        (widget.enableSearch ? _searchWidgetHeight : 0) +
        widget.listSpace;
    final ht = dropdownListHeight + 120;

    if (_searchAutofocus &&
        !(posFromBot < ht) &&
        posFromBot < _keyboardHeight &&
        !_isScrollPadding &&
        _isPortrait) {
      _isScrollPadding = true;
    }

    _isOutsideClickOverlay =
        _isScrollPadding ||
        (widget.readOnly &&
            dropdownListHeight >
                (posFromTop - MediaQuery.of(context).padding.top - 15) &&
            posFromBot < ht);

    final topPaddingHeight = _isOutsideClickOverlay
        ? (dropdownListHeight -
              (posFromTop - MediaQuery.of(context).padding.top - 15))
        : 0.0;

    final htPos = posFromBot < ht
        ? size.height - 100 + topPaddingHeight
        : _isScrollPadding
        ? size.height - (_keyboardHeight - posFromBot)
        : size.height;

    if (_isOutsideClickOverlay) {
      _openBarrierOverlay(context);
    }

    _entry = _buildOverlayEntry(
      size: size,
      posFromBot: posFromBot,
      ht: ht,
      htPos: htPos,
      useBottomAnchor: posFromBot < ht,
    );

    _entry2 = _buildOverlayEntry(
      size: size,
      posFromBot: posFromBot,
      ht: ht,
      htPos: htPos,
      useBottomAnchor: true,
      forceBottomAnchor: true,
    );

    overlay.insert(_isScrollPadding ? _entry2! : _entry!);
  }

  OverlayEntry _buildOverlayEntry({
    required Size size,
    required double posFromBot,
    required double ht,
    required double htPos,
    required bool useBottomAnchor,
    bool forceBottomAnchor = false,
  }) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          targetAnchor: (!forceBottomAnchor && posFromBot < ht)
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          followerAnchor: (!forceBottomAnchor && posFromBot < ht)
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
            0,
            (!forceBottomAnchor && posFromBot < ht)
                ? htPos - widget.listSpace
                : htPos + widget.listSpace,
          ),
          child: AnimatedBuilder(
            animation: _animController.view,
            builder: _buildOverlayContent,
          ),
        ),
      ),
    );
  }

  void _openBarrierOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    _barrierOverlay = OverlayEntry(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return GestureDetector(
          onTap: _hideOverlay,
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.transparent,
          ),
        );
      },
    );
    overlay.insert(_barrierOverlay!);
  }

  void _hideOverlay() {
    _animController.reverse().then<void>((_) {
      _removeOverlayEntries();
      _isScrollPadding = false;
      _isExpanded = false;
    });
    _textFieldFocusNode.unfocus();
  }

  void _removeOverlayEntries() {
    if (_entry != null && _entry!.mounted) {
      _entry?.remove();
      _entry = null;
    }
    if (_entry2 != null && _entry2!.mounted) {
      _entry2?.remove();
      _entry2 = null;
    }
    if (_barrierOverlay != null && _barrierOverlay!.mounted) {
      _barrierOverlay?.remove();
      _barrierOverlay = null;
      _isOutsideClickOverlay = false;
    }
  }

  void _shiftOverlayEntry2to1() {
    _searchAutofocus = false;
    _entry2?.remove();
    _entry2 = null;
    _removeBarrier();
    _animController.reset();
    _isScrollPadding = false;
    _showOverlay();
    _textFieldFocusNode.requestFocus();
  }

  void _removeBarrier() {
    if (_barrierOverlay != null && _barrierOverlay!.mounted) {
      _barrierOverlay?.remove();
      _barrierOverlay = null;
      _isOutsideClickOverlay = false;
    }
  }

  Widget _buildOverlayContent(BuildContext context, Widget? child) {
    return Directionality(
      textDirection: _currentDirection,
      child: ClipRect(
        child: Align(
          heightFactor: _heightFactor.value,
          child: Material(
            key: _overlayKey,
            color: Colors.transparent,
            child: Container(
              margin:
                  widget.boxMargin ??
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              decoration:
                  widget.boxDecoration ??
                  BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.dropdownRadius),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).shadowColor.withValues(alpha: 0.2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
              child: widget.isMultiSelection
                  ? _buildMultiSelection()
                  : _buildSingleSelection(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleSelection() {
    return SingleSelection(
      mainController: _textController,
      autoSort: !widget.readOnly,
      mainFocusNode: _textFieldFocusNode,
      searchTextStyle: widget.searchTextStyle,
      searchFocusNode: _searchFocusNode,
      enableSearch: widget.enableSearch,
      height: _dropdownHeight,
      listTileHeight: _listTileHeight,
      dropDownList: _dropDownList,
      listTextStyle: _listTileTextStyle,
      onChanged: (item) {
        setState(() {
          _textController.text = item.name;
          _isExpanded = false;
        });
        widget.singleController?.setDropDown(item);
        widget.onChanged?.call(item);
        _hideOverlay();
      },
      searchHeight: _searchWidgetHeight,
      searchKeyboardType: widget.searchKeyboardType,
      searchAutofocus: _searchAutofocus,
      searchDecoration: widget.searchDecoration,
      searchShowCursor: widget.searchShowCursor,
      listPadding: _listPadding,
      clearIconProperty: widget.clearIconProperty,
    );
  }

  Widget _buildMultiSelection() {
    return MultiSelection(
      buttonTextStyle: widget.submitButtonTextStyle,
      buttonText: widget.submitButtonText,
      buttonColor: widget.submitButtonColor,
      height: _dropdownHeight,
      listTileHeight: _listTileHeight,
      list: _multiSelectionValue,
      dropDownList: _dropDownList,
      listTextStyle: _listTileTextStyle,
      listPadding: _listPadding,
      onChanged: (selectedBools) {
        _isExpanded = false;
        _multiSelectionValue = selectedBools;

        final result = <DropDownValueModel>[];
        final names = <String>[];
        for (int i = 0; i < _multiSelectionValue.length; i++) {
          if (_multiSelectionValue[i]) {
            result.add(_dropDownList[i]);
            names.add(_dropDownList[i].name);
          }
        }

        final count = result.length;
        _textController.text = count == 0
            ? ''
            : widget.displayCompleteItem
            ? names.join(',')
            : '$count item selected';

        widget.multiController?.setDropDown(result.isNotEmpty ? result : null);
        widget.onChanged?.call(result);
        _hideOverlay();
        setState(() {});
      },
      checkBoxProperty: widget.checkBoxProperty,
    );
  }

  // ── Utilities ─────────────────────────────────────────────────────────────

  double _measureTextHeight(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.size.height;
  }

  void _clearSelection() {
    if (_isExpanded) {
      _isExpanded = false;
      _hideOverlay();
    }
    _textController.clear();
    if (widget.isMultiSelection) {
      widget.multiController?.clearDropDown();
      widget.onChanged?.call(<DropDownValueModel>[]);
      _multiSelectionValue = List.filled(_dropDownList.length, false);
    } else {
      widget.singleController?.clearDropDown();
      widget.onChanged?.call('');
    }
    setState(() {});
  }
}
