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
///   dropdownColor: Colors.blue.shade50, // Sets the background color of the dropdown
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
    this.autovalidateMode,
    this.boxDecoration,
    this.boxMargin,
    this.dropdownColor,
    this.selectedItemHighlightColor,
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
    this.textDirection,
    this.itemTextAlign,
    this.maxlines = 1,
    this.clearOnUnmatched = true,
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
       submitButtonTextStyle = null,
       submitButtonDecoration = null;

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
    this.dropdownColor,
    this.selectedItemHighlightColor,
    this.submitButtonDecoration,
    this.textDirection,
    this.itemTextAlign,
    this.maxlines = 1,
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
       keyboardType = null,
       clearOnUnmatched = true;

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

  /// Background color of the dropdown list container.
  /// Used when [boxDecoration] is not provided.
  final Color? dropdownColor;

  /// Margin around the dropdown container.
  final EdgeInsets? boxMargin;

  /// Customizes the checkbox appearance in multi-selection mode.
  final CheckBoxProperty? checkBoxProperty;

  /// Highlight color for the selected item in the dropdown list.
  final Color? selectedItemHighlightColor;

  /// Text direction for the dropdown items.
  final TextDirection? textDirection;

  /// Text alignment for the dropdown items.
  final TextAlign? itemTextAlign;

  /// Maximum lines for the text in the textfield and dropdown items.
  final int maxlines;

  /// Whether to clear the textfield if the typed value doesn't match any item.
  /// Set to false to allow unknown/free-text values.
  final bool clearOnUnmatched;

  /// Decoration for the submit button in multi-selection.
  final BoxDecoration? submitButtonDecoration;

  @override
  State<DropDownTextField> createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // ── Constants ─────────────────────────────────────────────────────────────

  static const int _animDurationMs = 150;
  static const double _searchWidgetHeight = 60;
  static const double _keyboardHeight = 450;

  /// Shared deep-equality instance — avoids re-allocating on every update.
  static const DeepCollectionEquality _deepEq = DeepCollectionEquality();

  static final Animatable<double> _easeInTween = CurveTween(
    curve: Curves.easeIn,
  );

  // ── State ─────────────────────────────────────────────────────────────────

  late final TextEditingController _textController;
  late final AnimationController _animController;
  late final Animation<double> _heightFactor;
  late final LayerLink _layerLink = LayerLink();
  late final GlobalKey _overlayKey = GlobalKey();

  late FocusNode _searchFocusNode;
  late FocusNode _textFieldFocusNode;

  /// Cached list — rebuilt only when [widget.dropDownList] reference changes.
  late List<DropDownValueModel> _dropDownList;

  /// Cached padding — rebuilt only when [widget.listPadding] changes.
  late ListPadding _listPadding;

  /// Cached text style for list tiles.
  late TextStyle _listTileTextStyle;

  /// Cached tile height — recomputed only when style or padding changes.
  double _listTileHeight = 0;

  /// Cached total dropdown height.
  double _dropdownHeight = 0;

  /// Cached [TextStyle] key used to invalidate [_listTileHeight].
  TextStyle? _cachedTextStyle;

  List<bool> _multiSelectionValue = [];

  bool _isExpanded = false;
  bool _isScrollPadding = false;
  bool _isOutsideClickOverlay = false;
  bool _searchAutofocus = false;

  OverlayEntry? _entry;
  OverlayEntry? _entry2;
  OverlayEntry? _barrierOverlay;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _textController = TextEditingController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _animDurationMs),
    );
    _heightFactor = _animController.drive(_easeInTween);

    _searchFocusNode = widget.searchFocusNode ?? FocusNode();
    _textFieldFocusNode = widget.textFieldFocusNode ?? FocusNode();

    _searchFocusNode.addListener(_onSearchFocusChanged);
    _textFieldFocusNode.addListener(_onTextFieldFocusChanged);
    widget.singleController?.addListener(_onSingleControllerChanged);
    widget.multiController?.addListener(_onMultiControllerChanged);

    _dropDownList = List.from(widget.dropDownList);
    _listPadding = widget.listPadding ?? const ListPadding();

    _initMultiSelectionState();
    _applyInitialValue();

    // Defer layout-dependent work until after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _recalculateDimensions();
    });
  }

  @override
  void didUpdateWidget(covariant DropDownTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-subscribe listeners if the controller instance changed.
    if (oldWidget.singleController != widget.singleController) {
      oldWidget.singleController?.removeListener(_onSingleControllerChanged);
      widget.singleController?.addListener(_onSingleControllerChanged);
    }
    if (oldWidget.multiController != widget.multiController) {
      oldWidget.multiController?.removeListener(_onMultiControllerChanged);
      widget.multiController?.addListener(_onMultiControllerChanged);
    }

    // Only pay the cost of deep equality when the list reference changes.
    final bool listChanged =
        !identical(oldWidget.dropDownList, widget.dropDownList) &&
        !_deepEq.equals(oldWidget.dropDownList, widget.dropDownList);

    if (listChanged) {
      _dropDownList = List.from(widget.dropDownList);
      if (widget.isMultiSelection) {
        _multiSelectionValue = List.filled(_dropDownList.length, false);
        _textController.text = '';
      }
    }

    final bool paddingChanged = oldWidget.listPadding != widget.listPadding;
    if (paddingChanged) {
      _listPadding = widget.listPadding ?? const ListPadding();
    }

    // Recalculate dimensions only when something that affects layout changed.
    final bool needsDimensionUpdate =
        listChanged ||
        paddingChanged ||
        oldWidget.listTextStyle != widget.listTextStyle ||
        oldWidget.dropDownItemCount != widget.dropDownItemCount;

    if (needsDimensionUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _recalculateDimensions();
      });
    }

    // Sync controller → text field only when the value actually changed.
    if (widget.isMultiSelection) {
      _syncMultiSelectionState(oldWidget);
    } else {
      _syncSingleSelectionState(oldWidget);
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _textFieldFocusNode.removeListener(_onTextFieldFocusChanged);
    widget.singleController?.removeListener(_onSingleControllerChanged);
    widget.multiController?.removeListener(_onMultiControllerChanged);
    if (widget.searchFocusNode == null) _searchFocusNode.dispose();
    if (widget.textFieldFocusNode == null) _textFieldFocusNode.dispose();
    if (_animController.isAnimating) _animController.stop(canceled: true);
    _animController.dispose();
    _textController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _removeOverlayEntries();
        _showOverlay();
      });
    }
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
      if (!widget.readOnly) {
        final currentText = _textController.text.trim();
        final currentValue = widget.singleController?.dropDownValue;

        final matchesCurrent =
            currentValue != null &&
            (currentValue.name.trim() == currentText ||
                currentValue.displayValue?.trim() == currentText);

        if (!matchesCurrent) {
          if (widget.clearOnUnmatched) {
            setState(() => _textController.clear());
            widget.singleController?.clearDropDown();
          } else if (currentText.isNotEmpty) {
            final newItem = DropDownValueModel(
              name: currentText,
              value: currentText,
            );
            widget.singleController?.setDropDown(newItem);
            widget.onChanged?.call(newItem);
          }
        }
      }
    }
  }

  void _onSingleControllerChanged() {
    final ctrl = widget.singleController;
    if (ctrl == null) return;
    if (ctrl.dropDownValue == null) {
      _clearSelection();
    } else {
      setState(() {
        _textController.text =
            ctrl.dropDownValue!.displayValue ?? ctrl.dropDownValue!.name;
      });
    }
  }

  void _onMultiControllerChanged() {
    final ctrl = widget.multiController;
    if (ctrl == null) return;
    final newList = ctrl.dropDownValueList;
    if (newList == null) {
      _clearSelection();
    } else {
      setState(() {
        _multiSelectionValue = List.filled(_dropDownList.length, false);
        for (final selected in newList) {
          final idx = _dropDownList.indexOf(selected);
          if (idx != -1) _multiSelectionValue[idx] = true;
        }
        final count = _multiSelectionValue.where((e) => e).length;
        final names = newList.map((m) => m.name).toList();
        _textController.text = count == 0
            ? ''
            : widget.displayCompleteItem
            ? names.join(',')
            : '$count item selected';
      });
    }
  }

  // ── Initialization helpers ────────────────────────────────────────────────

  void _initMultiSelectionState() {
    _multiSelectionValue = List.filled(widget.dropDownList.length, false);
  }

  void _applyInitialValue() {
    if (widget.initialValue == null) return;

    if (widget.isMultiSelection) {
      final initList = widget.initialValue as List;
      for (int i = 0; i < initList.length; i++) {
        final idx = _dropDownList.indexWhere(
          (e) => e.name.trim() == (initList[i] as String).trim(),
        );
        if (idx != -1) _multiSelectionValue[idx] = true;
      }
      final count = _multiSelectionValue.where((e) => e).length;
      _textController.text = count == 0
          ? ''
          : widget.displayCompleteItem
          ? (initList.cast<String>()).join(',')
          : '$count item selected';
    } else {
      final initStr = widget.initialValue as String;
      final idx = _dropDownList.indexWhere(
        (e) => e.name.trim() == initStr.trim(),
      );
      if (idx != -1) _textController.text = initStr;
    }
  }

  /// Computes tile height and total dropdown height.
  /// Only called when relevant props actually change (not on every frame).
  void _recalculateDimensions() {
    final style =
        (widget.listTextStyle ?? Theme.of(context).textTheme.titleMedium)!;

    // Re-measure only when the text style actually changed.
    if (style != _cachedTextStyle) {
      _cachedTextStyle = style;
      _listTileTextStyle = style;
      _listTileHeight =
          _measureTextHeight('dummy Text', style) +
          _listPadding.top +
          _listPadding.bottom;
    }

    final visibleCount = _dropDownList.length < widget.dropDownItemCount
        ? _dropDownList.length.toDouble()
        : widget.dropDownItemCount.toDouble();
    _dropdownHeight = visibleCount * _listTileHeight + 10;
  }

  // ── State sync (controller → UI) ──────────────────────────────────────────

  void _syncMultiSelectionState(DropDownTextField oldWidget) {
    final ctrl = widget.multiController;
    if (ctrl == null) return;

    final newList = ctrl.dropDownValueList;
    final oldList = oldWidget.multiController?.dropDownValueList;

    // Skip if neither the value list nor displayCompleteItem changed.
    if (_deepEq.equals(newList, oldList) &&
        oldWidget.displayCompleteItem == widget.displayCompleteItem) {
      return;
    }

    if (newList != null) {
      _multiSelectionValue = List.filled(_dropDownList.length, false);
      for (final selected in newList) {
        final idx = _dropDownList.indexOf(selected);
        if (idx != -1) _multiSelectionValue[idx] = true;
      }
      final count = _multiSelectionValue.where((e) => e).length;
      final names = newList.map((m) => m.name).toList();
      _textController.text = count == 0
          ? ''
          : widget.displayCompleteItem
          ? names.join(',')
          : '$count item selected';
    } else {
      _multiSelectionValue = List.filled(_dropDownList.length, false);
      _textController.text = '';
    }
  }

  void _syncSingleSelectionState(DropDownTextField oldWidget) {
    final ctrl = widget.singleController;
    if (ctrl == null) return;

    // Skip if the value didn't change.
    if (ctrl.dropDownValue == oldWidget.singleController?.dropDownValue) return;

    if (ctrl.dropDownValue != null) {
      _textController.text = ctrl.dropDownValue!.name;
    } else {
      _textController.clear();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (!isKeyboardVisible && _isExpanded && _isScrollPadding) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _shiftOverlayEntry2to1();
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

  void _showOverlay() {
    _animController.forward();
    _isExpanded = true;

    final overlay = Overlay.of(context);
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;

    final renderBox = renderObject;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final mediaQuery = MediaQuery.of(context);

    final posFromTop = offset.dy;
    final posFromBot = mediaQuery.size.height - posFromTop;
    final dropdownListHeight =
        _dropdownHeight +
        (widget.enableSearch ? _searchWidgetHeight : 0) +
        widget.listSpace;
    final ht = dropdownListHeight + 120;
    final isBelow = posFromBot < ht;

    if (_searchAutofocus &&
        !isBelow &&
        posFromBot < _keyboardHeight &&
        !_isScrollPadding &&
        mediaQuery.orientation == Orientation.portrait) {
      _isScrollPadding = true;
    }

    _isOutsideClickOverlay =
        _isScrollPadding ||
        (widget.readOnly &&
            dropdownListHeight > (posFromTop - mediaQuery.padding.top - 15) &&
            isBelow);

    final topPaddingHeight = _isOutsideClickOverlay
        ? dropdownListHeight - (posFromTop - mediaQuery.padding.top - 15)
        : 0.0;

    final htPos = isBelow
        ? size.height - 100 + topPaddingHeight
        : _isScrollPadding
        ? size.height - (_keyboardHeight - posFromBot)
        : size.height;

    if (_isOutsideClickOverlay) _openBarrierOverlay(overlay);

    // Build only the entry that will actually be used.
    if (_isScrollPadding) {
      _entry2 = _buildOverlayEntry(
        size: size,
        htPos: htPos,
        forceBottomAnchor: true,
      );
      overlay.insert(_entry2!);
    } else {
      _entry = _buildOverlayEntry(size: size, htPos: htPos, isBelow: isBelow);
      overlay.insert(_entry!);
    }
  }

  OverlayEntry _buildOverlayEntry({
    required Size size,
    required double htPos,
    bool isBelow = false,
    bool forceBottomAnchor = false,
  }) {
    final useBottomAnchor = forceBottomAnchor || isBelow;
    final currentDirection = Directionality.of(context);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          targetAnchor: useBottomAnchor
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          followerAnchor: useBottomAnchor
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
            0,
            useBottomAnchor
                ? htPos - widget.listSpace
                : htPos + widget.listSpace,
          ),
          child: AnimatedBuilder(
            animation: _animController.view,
            builder: (ctx, _) => _buildOverlayContent(ctx, currentDirection),
          ),
        ),
      ),
    );
  }

  void _openBarrierOverlay(OverlayState overlay) {
    _barrierOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideOverlay,
        child: const SizedBox.expand(
          child: ColoredBox(color: Colors.transparent),
        ),
      ),
    );
    overlay.insert(_barrierOverlay!);
  }

  void _hideOverlay() {
    _animController.reverse().then<void>((_) {
      if (!mounted) return;
      _removeOverlayEntries();
      _isScrollPadding = false;
      _isExpanded = false;
    });
    _textFieldFocusNode.unfocus();
  }

  void _removeOverlayEntries() {
    if (_entry?.mounted == true) {
      _entry!.remove();
      _entry = null;
    }
    if (_entry2?.mounted == true) {
      _entry2!.remove();
      _entry2 = null;
    }
    _removeBarrier();
  }

  void _shiftOverlayEntry2to1() {
    _searchAutofocus = false;
    if (_entry2?.mounted == true) {
      _entry2!.remove();
      _entry2 = null;
    }
    _removeBarrier();
    _animController.reset();
    _isScrollPadding = false;
    _showOverlay();
    _textFieldFocusNode.requestFocus();
  }

  void _removeBarrier() {
    if (_barrierOverlay?.mounted == true) {
      _barrierOverlay!.remove();
      _barrierOverlay = null;
      _isOutsideClickOverlay = false;
    }
  }

  Widget _buildOverlayContent(BuildContext context, TextDirection direction) {
    return Directionality(
      textDirection: direction,
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
                    color: widget.dropdownColor ?? Theme.of(context).cardColor,
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
        widget.singleController?.setDropDown(item);
        widget.onChanged?.call(item);
        _hideOverlay();
        setState(() {
          _textController.text = item.displayValue ?? item.name;
          _isExpanded = false;
        });
      },
      searchHeight: _searchWidgetHeight,
      searchKeyboardType: widget.searchKeyboardType,
      searchAutofocus: _searchAutofocus,
      searchDecoration: widget.searchDecoration,
      searchShowCursor: widget.searchShowCursor,
      listPadding: _listPadding,
      clearIconProperty: widget.clearIconProperty,
      selectedItemHighlightColor: widget.selectedItemHighlightColor,
      selectedItem: widget.singleController?.dropDownValue,
      textAlign: widget.itemTextAlign,
      textDirection: widget.textDirection,
      maxLines: widget.maxlines,
    );
  }

  Widget _buildMultiSelection() {
    return MultiSelection(
      buttonTextStyle: widget.submitButtonTextStyle,
      buttonText: widget.submitButtonText,
      buttonColor: widget.submitButtonColor,
      buttonDecoration: widget.submitButtonDecoration,
      height: _dropdownHeight,
      listTileHeight: _listTileHeight,
      list: _multiSelectionValue,
      dropDownList: _dropDownList,
      listTextStyle: _listTileTextStyle,
      listPadding: _listPadding,
      onChanged: (selectedBools) {
        final result = <DropDownValueModel>[];
        final names = <String>[];
        for (int i = 0; i < selectedBools.length; i++) {
          if (selectedBools[i]) {
            result.add(_dropDownList[i]);
            names.add(_dropDownList[i].displayValue ?? _dropDownList[i].name);
          }
        }
        final text = result.isEmpty
            ? ''
            : widget.displayCompleteItem
            ? names.join(',')
            : '${result.length} item selected';

        widget.multiController?.setDropDown(result.isNotEmpty ? result : null);
        widget.onChanged?.call(result);
        _hideOverlay();
        setState(() {
          _multiSelectionValue = selectedBools;
          _textController.text = text;
          _isExpanded = false;
        });
      },
      checkBoxProperty: widget.checkBoxProperty,
      listBackgroundColor: widget.selectedItemHighlightColor,
      textAlign: widget.itemTextAlign,
      textDirection: widget.textDirection,
      maxLines: widget.maxlines,
    );
  }

  // ── Utilities ─────────────────────────────────────────────────────────────

  /// Measures the height of a single line of text with the given [style].
  /// Result is cached externally via [_cachedTextStyle].
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
    if (widget.isMultiSelection) {
      widget.multiController?.clearDropDown();
      widget.onChanged?.call(<DropDownValueModel>[]);
      setState(() {
        _textController.clear();
        _multiSelectionValue = List.filled(_dropDownList.length, false);
      });
    } else {
      widget.singleController?.clearDropDown();
      widget.onChanged?.call('');
      setState(() => _textController.clear());
    }
  }
}
