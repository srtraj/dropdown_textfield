import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dropdown_textfield/tooltip_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class DropDownTextField extends StatefulWidget {
  const DropDownTextField(
      {Key? key,
      this.singleController,
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
      this.dropDownItemCount = 6,
      this.searchFocusNode,
      this.textFieldFocusNode,
      this.searchAutofocus = false,
      this.searchShowCursor,
      this.searchKeyboardType,
      this.listSpace = 0,
      this.clearOption = true,
      // this.keyboardHeight = 450,
      this.listPadding,
      this.listTextStyle})
      : assert(!(initialValue != null && singleController != null),
            "you cannot add both initialValue and singleController,\nset initial value using controller \n\tEg: SingleValueDropDownController(data:initial value) "),
        isMultiSelection = false,
        isForceMultiSelectionClear = false,
        displayCompleteItem = false,
        multiController = null,
        submitButtonColor = null,
        submitButtonText = null,
        submitButtonTextStyle = null,
        super(key: key);
  const DropDownTextField.multiSelection(
      {Key? key,
      this.multiController,
      this.displayCompleteItem = false,
      this.initialValue,
      required this.dropDownList,
      this.padding,
      this.textStyle,
      @Deprecated('Use multiController instead. Will be removed in next version')
          this.isForceMultiSelectionClear = false,
      this.onChanged,
      this.validator,
      this.isEnabled = true,
      this.dropdownRadius = 12,
      this.textFieldDecoration,
      this.dropDownItemCount = 6,
      this.searchFocusNode,
      this.textFieldFocusNode,
      this.listSpace = 0,
      this.clearOption = true,
      this.submitButtonColor,
      this.submitButtonText,
      this.submitButtonTextStyle,
      this.listPadding,
      this.listTextStyle})
      : assert(initialValue == null || multiController == null,
            "you cannot add both initialValue and multiController\nset initial value using controller\n\tMultiValueDropDownController(data:initial value)"),
        isMultiSelection = true,
        enableSearch = false,
        readOnly = true,
        searchAutofocus = false,
        searchKeyboardType = null,
        searchShowCursor = null,
        singleController = null,
        // keyboardHeight = 0,
        super(key: key);

  ///single dropdown controller,
  final SingleValueDropDownController? singleController;

  ///multi dropdown controller
  final MultiValueDropDownController? multiController;

  ///define the radius of dropdown List ,default value is 12
  final double dropdownRadius;

  ///initial value ,if it is null or not exist in dropDownList then it will not display value.
  final dynamic initialValue;

  ///dropDownList,List of dropdown values
  ///List<DropDownValueModel>
  final List<DropDownValueModel> dropDownList;

  ///function,called when value selected from dropdown.
  ///for single Selection Dropdown it will return single DropDownValueModel object,
  ///and for multi Selection Dropdown ,it will return list of DropDownValueModel object,
  final ValueSetter? onChanged;

  final bool isMultiSelection;

  final TextStyle? textStyle;

  final EdgeInsets? padding;

  ///by setting isForceMultiSelectionClear=true to deselect selected item,only applicable for multi selection dropdown
  final bool isForceMultiSelectionClear;

  ///override default textfield decoration
  final InputDecoration? textFieldDecoration;

  ///by setting isEnabled=false to disable textfield,default value true
  final bool isEnabled;

  final FormFieldValidator<String>? validator;

  ///by setting enableSearch=true enable search option in dropdown,as of now this feature enabled only for single selection dropdown
  final bool enableSearch;

  final bool readOnly;

  ///set displayCompleteItem=true, if you want show complete list of item in textfield else it will display like "number_of_item item selected"
  final bool displayCompleteItem;

  ///Maximum number of dropdown item to display,default value is 6
  final int dropDownItemCount;

  final FocusNode? searchFocusNode;
  final FocusNode? textFieldFocusNode;

  ///override default search keyboard type,only applicable if enableSearch=true,
  final TextInputType? searchKeyboardType;

  ///by setting searchAutofocus=true to autofocus search textfield,only applicable if enableSearch=true,
  ///  ///default value is false
  final bool searchAutofocus;

  ///by setting searchShowCursor=false to hide cursor from search textfield,only applicable if enableSearch=true,
  final bool? searchShowCursor;

  ///by set clearOption=false to hide clear suffix icon button from textfield.
  final bool clearOption;

  ///space between textfield and list ,default value is 0
  final double listSpace;

  ///dropdown List item padding
  final ListPadding? listPadding;

  ///multi dropdown submit button text
  final String? submitButtonText;

  ///multi dropdown submit button color
  final Color? submitButtonColor;

  ///multi dropdown submit button text style
  final TextStyle? submitButtonTextStyle;

  ///dropdown list item text style
  final TextStyle? listTextStyle;

  @override
  _DropDownTextFieldState createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField>
    with TickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  late TextEditingController _cnt;
  late String _hintText;

  late bool _isExpanded;
  OverlayEntry? _entry;
  OverlayEntry? _entry2;
  OverlayEntry? _barrierOverlay;
  final _layerLink = LayerLink();
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  List<bool> _multiSelectionValue = [];
  // late String selectedItem;
  late double _height;
  late List<DropDownValueModel> _dropDownList;
  late int _maxListItem;
  late double _searchWidgetHeight;
  late FocusNode _searchFocusNode;
  late FocusNode _textFieldFocusNode;
  late bool _isOutsideClickOverlay;
  late bool _isScrollPadding;
  final int _duration = 150;
  late StreamSubscription<bool> keyboardSubscription;
  late Offset _offset;
  late bool _searchAutofocus;
  late bool _isPortrait;
  late double _listTileHeight;
  late double _keyboardHeight;
  late TextStyle _listTileTextStyle;
  late ListPadding _listPadding;
  @override
  void initState() {
    _cnt = TextEditingController();
    _keyboardHeight = 450;
    _searchAutofocus = false;
    _isScrollPadding = false;
    _isOutsideClickOverlay = false;
    _searchFocusNode = widget.searchFocusNode ?? FocusNode();
    _textFieldFocusNode = widget.textFieldFocusNode ?? FocusNode();
    _isExpanded = false;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _duration),
    );
    _heightFactor = _controller.drive(_easeInTween);
    _searchWidgetHeight = 60;
    _hintText = "Select Item";
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus &&
          !_textFieldFocusNode.hasFocus &&
          _isExpanded &&
          !widget.isMultiSelection) {
        _isExpanded = !_isExpanded;
        hideOverlay();
      }
    });
    _textFieldFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus &&
          !_textFieldFocusNode.hasFocus &&
          _isExpanded) {
        _isExpanded = !_isExpanded;
        hideOverlay();
      }
    });

    for (int i = 0; i < widget.dropDownList.length; i++) {
      _multiSelectionValue.add(false);
    }

    ///initial value load
    if (widget.initialValue != null) {
      _dropDownList = List.from(widget.dropDownList);
      if (widget.isMultiSelection) {
        for (int i = 0; i < widget.initialValue.length; i++) {
          var index = _dropDownList.indexWhere((element) =>
              element.name.trim() == widget.initialValue[i].trim());
          if (index != -1) {
            _multiSelectionValue[i] = true;
          }
        }
        int count =
            _multiSelectionValue.where((element) => element).toList().length;

        _cnt.text = (count == 0
            ? ""
            : widget.displayCompleteItem
                ? widget.initialValue.join(",")
                : "$count item selected");
      } else {
        var index = _dropDownList.indexWhere(
            (element) => element.name.trim() == widget.initialValue.trim());

        if (index != -1) {
          _cnt.text = widget.initialValue;
        }
      }
    }
    updateFunction();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible && _isExpanded && _isScrollPadding) {
        shiftOverlayEntry2to1();
      }
    });

    super.initState();
  }

  Size _textWidgetSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  updateFunction({DropDownTextField? oldWidget}) {
    Function eq = const DeepCollectionEquality().equals;
    _dropDownList = List.from(widget.dropDownList);
    _listPadding = widget.listPadding ?? ListPadding();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.isMultiSelection) {
        if (oldWidget != null && !eq(oldWidget.dropDownList, _dropDownList)) {
          _multiSelectionValue = [];
          _cnt.text = "";
          for (int i = 0; i < _dropDownList.length; i++) {
            _multiSelectionValue.add(false);
          }
        }
        if (widget.isForceMultiSelectionClear &&
            _multiSelectionValue.isNotEmpty) {
          _multiSelectionValue = [];
          _cnt.text = "";
          for (int i = 0; i < _dropDownList.length; i++) {
            _multiSelectionValue.add(false);
          }
        }

        // if (widget.multiController != null) {
        //   List<DropDownValueModel> multiCnt = [];
        //   for (int i = 0; i < dropDownList.length; i++) {
        //     if (multiSelectionValue[i]) {
        //       multiCnt.add(dropDownList[i]);
        //     }
        //   }
        //   widget.multiController!
        //       .setDropDown(multiCnt.isNotEmpty ? multiCnt : null);
        // }

        if (widget.multiController != null) {
          if (oldWidget != null &&
              oldWidget.multiController!.dropDownValueList != null) {}
          if (widget.multiController!.dropDownValueList != null) {
            _multiSelectionValue = [];
            for (int i = 0; i < _dropDownList.length; i++) {
              _multiSelectionValue.add(false);
            }
            for (int i = 0;
                i < widget.multiController!.dropDownValueList!.length;
                i++) {
              var index = _dropDownList.indexWhere((element) =>
                  element == widget.multiController!.dropDownValueList![i]);
              if (index != -1) {
                _multiSelectionValue[index] = true;
              }
            }
            int count = _multiSelectionValue
                .where((element) => element)
                .toList()
                .length;
            _cnt.text = (count == 0
                ? ""
                : widget.displayCompleteItem
                    ? widget.initialValue.join(",")
                    : "$count item selected");
          } else {
            _multiSelectionValue = [];
            _cnt.text = "";
            for (int i = 0; i < _dropDownList.length; i++) {
              _multiSelectionValue.add(false);
            }
          }
        }
      } else {
        if (widget.singleController != null) {
          if (widget.singleController!.dropDownValue != null) {
            _cnt.text = widget.singleController!.dropDownValue!.name;
          } else {
            _cnt.clear();
          }
        }
      }

      _listTileTextStyle =
          (widget.listTextStyle ?? Theme.of(context).textTheme.subtitle1)!;
      _listTileHeight =
          _textWidgetSize("dummy Text", _listTileTextStyle).height +
              _listPadding.top +
              _listPadding.bottom;
      _maxListItem = widget.dropDownItemCount;

      _height = (!widget.isMultiSelection
              ? (_dropDownList.length < _maxListItem
                  ? _dropDownList.length * _listTileHeight
                  : _listTileHeight * _maxListItem.toDouble())
              : _dropDownList.length < _maxListItem
                  ? _dropDownList.length * _listTileHeight
                  : _listTileHeight * _maxListItem.toDouble()) +
          10;
    });
  }

  @override
  void didUpdateWidget(covariant DropDownTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateFunction(oldWidget: oldWidget);
  }

  @override
  void dispose() {
    if (widget.searchFocusNode == null) _searchFocusNode.dispose();
    if (widget.textFieldFocusNode == null) _textFieldFocusNode.dispose();
    _cnt.dispose();

    super.dispose();
  }

  clearFun() {
    if (_isExpanded) {
      _isExpanded = !_isExpanded;
      hideOverlay();
    }
    _cnt.clear();
    if (widget.isMultiSelection) {
      if (widget.multiController != null) {
        widget.multiController!.setDropDown(null);
      }
      if (widget.onChanged != null) {
        widget.onChanged!([]);
      }

      _multiSelectionValue = [];
      for (int i = 0; i < _dropDownList.length; i++) {
        _multiSelectionValue.add(false);
      }
    } else {
      if (widget.singleController != null) {
        widget.singleController!.setDropDown(null);
      }
      if (widget.onChanged != null) {
        widget.onChanged!("");
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        focusNode: _textFieldFocusNode,
        style: widget.textStyle,
        enabled: widget.isEnabled,
        readOnly: widget.readOnly,
        controller: _cnt,
        onTap: () {
          _searchAutofocus = widget.searchAutofocus;
          if (!_isExpanded) {
            _showOverlay();
          } else {
            hideOverlay();
          }
        },
        validator: (value) =>
            widget.validator != null ? widget.validator!(value) : null,
        decoration: widget.textFieldDecoration != null
            ? widget.textFieldDecoration!.copyWith(
                suffixIcon: (_cnt.text.isEmpty || !widget.clearOption)
                    ? const Icon(
                        Icons.arrow_drop_down_outlined,
                      )
                    : widget.clearOption
                        ? InkWell(
                            onTap: clearFun,
                            child: const Icon(
                              Icons.clear,
                            ),
                          )
                        : null,
              )
            : InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: _hintText,
                hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                suffixIcon: (_cnt.text.isEmpty || !widget.clearOption)
                    ? const Icon(
                        Icons.arrow_drop_down_outlined,
                      )
                    : widget.clearOption
                        ? InkWell(
                            onTap: clearFun,
                            child: const Icon(
                              Icons.clear,
                            ),
                          )
                        : null,
              ),
      ),
    );
  }

  Future<void> _showOverlay() async {
    _controller.forward();
    _isExpanded = true;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _offset = renderBox.localToGlobal(Offset.zero);
    double posFromTop = _offset.dy;
    double posFromBot = MediaQuery.of(context).size.height - posFromTop;

    double dropdownListHeight = _height +
        (widget.enableSearch ? _searchWidgetHeight : 0) +
        widget.listSpace;
    double ht = dropdownListHeight + 120;
    if (_searchAutofocus &&
        !(posFromBot < ht) &&
        posFromBot < _keyboardHeight &&
        !_isScrollPadding &&
        _isPortrait) {
      _isScrollPadding = true;
    }
    _isOutsideClickOverlay = _isScrollPadding ||
        (widget.readOnly &&
            dropdownListHeight >
                (posFromTop - MediaQuery.of(context).padding.top - 15) &&
            posFromBot < ht);
    final double topPaddingHeight = _isOutsideClickOverlay
        ? (dropdownListHeight -
            (posFromTop - MediaQuery.of(context).padding.top - 15))
        : 0;

    final double htPos = posFromBot < ht
        ? size.height - 100 + topPaddingHeight
        : _isScrollPadding
            ? size.height - (_keyboardHeight - posFromBot)
            : size.height;
    if (_isOutsideClickOverlay) {
      _openOutSideClickOverlay(context);
    }
    _entry = OverlayEntry(
      builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
              targetAnchor: posFromBot < ht
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              followerAnchor: posFromBot < ht
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(
                0,
                posFromBot < ht
                    ? htPos - widget.listSpace
                    : htPos + widget.listSpace,
              ),
              child: AnimatedBuilder(
                animation: _controller.view,
                builder: buildOverlay,
              ))),
    );
    _entry2 = OverlayEntry(
      builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
              targetAnchor: Alignment.bottomCenter,
              followerAnchor: Alignment.bottomCenter,
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(
                0,
                htPos,
              ),
              child: AnimatedBuilder(
                animation: _controller.view,
                builder: buildOverlay,
              ))),
    );
    overlay?.insert(_isScrollPadding ? _entry2! : _entry!);
  }

  _openOutSideClickOverlay(BuildContext context) {
    final overlay2 = Overlay.of(context);
    _barrierOverlay = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return GestureDetector(
        onTap: () {
          hideOverlay();
        },
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.transparent,
        ),
      );
    });
    overlay2?.insert(_barrierOverlay!);
  }

  void hideOverlay() {
    if (!_isScrollPadding) {}
    _controller.reverse().then<void>((void value) {
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
      _isScrollPadding = false;
      _isExpanded = false;
    });
  }

  void shiftOverlayEntry1to2() {
    _entry?.remove();
    _entry = null;
    // _isOutsideClickOverlay = true;
    _isScrollPadding = true;
    _showOverlay();
    _textFieldFocusNode.requestFocus();
    Future.delayed(Duration(milliseconds: _duration), () {
      _searchFocusNode.requestFocus();
    });
  }

  void shiftOverlayEntry2to1() {
    _searchAutofocus = false;
    _entry2?.remove();
    _entry2 = null;
    // _isOutsideClickOverlay = true;
    _controller.reset();
    _isScrollPadding = false;
    _showOverlay();
    _textFieldFocusNode.requestFocus();
  }

  Widget buildOverlay(context, child) {
    return ClipRect(
      child: Align(
        heightFactor: _heightFactor.value,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.dropdownRadius)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: !widget.isMultiSelection
                  ? SingleSelection(
                      mainController: _cnt,
                      autoSort: !widget.readOnly,
                      mainFocusNode: _textFieldFocusNode,
                      searchFocusNode: _searchFocusNode,
                      enableSearch: widget.enableSearch,
                      height: _height,
                      listTileHeight: _listTileHeight,
                      dropDownList: _dropDownList,
                      listTextStyle: _listTileTextStyle,
                      onChanged: (item) {
                        setState(() {
                          _cnt.text = item.name;
                          _isExpanded = !_isExpanded;
                        });
                        if (widget.singleController != null) {
                          widget.singleController!.setDropDown(item);
                        }
                        if (widget.onChanged != null) {
                          widget.onChanged!(item);
                        }
                        // Navigator.pop(context, null);

                        hideOverlay();
                      },
                      searchHeight: _searchWidgetHeight,
                      searchKeyboardType: widget.searchKeyboardType,
                      searchAutofocus: _searchAutofocus,
                      searchShowCursor: widget.searchShowCursor,
                      listPadding: _listPadding,
                      onSearchTap: () {
                        double posFromBot =
                            MediaQuery.of(context).size.height - _offset.dy;
                        if (posFromBot < _keyboardHeight &&
                            !_isScrollPadding &&
                            _isPortrait) {
                          shiftOverlayEntry1to2();
                        }
                      },
                      onSearchSubmit: () {
                        if (_isScrollPadding) {
                          shiftOverlayEntry2to1();
                        }
                      })
                  : MultiSelection(
                      buttonTextStyle: widget.submitButtonTextStyle,
                      buttonText: widget.submitButtonText,
                      buttonColor: widget.submitButtonColor,
                      height: _height,
                      listTileHeight: _listTileHeight,
                      list: _multiSelectionValue,
                      dropDownList: _dropDownList,
                      listTextStyle: _listTileTextStyle,
                      listPadding: _listPadding,
                      onChanged: (val) {
                        _isExpanded = !_isExpanded;
                        _multiSelectionValue = val;
                        List<DropDownValueModel> result = [];
                        List completeList = [];
                        for (int i = 0; i < _multiSelectionValue.length; i++) {
                          if (_multiSelectionValue[i]) {
                            result.add(_dropDownList[i]);
                            completeList.add(_dropDownList[i].name);
                          }
                        }
                        int count = _multiSelectionValue
                            .where((element) => element)
                            .toList()
                            .length;

                        _cnt.text = (count == 0
                            ? ""
                            : widget.displayCompleteItem
                                ? completeList.join(",")
                                : "$count item selected");
                        if (widget.multiController != null) {
                          widget.multiController!
                              .setDropDown(result.isNotEmpty ? result : null);
                        }
                        if (widget.onChanged != null) {
                          widget.onChanged!(result);
                        }

                        hideOverlay();

                        setState(() {});
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class SingleSelection extends StatefulWidget {
  const SingleSelection(
      {Key? key,
      required this.dropDownList,
      required this.onChanged,
      required this.height,
      required this.enableSearch,
      required this.searchHeight,
      required this.searchFocusNode,
      required this.mainFocusNode,
      this.searchKeyboardType,
      required this.searchAutofocus,
      this.searchShowCursor,
      required this.mainController,
      required this.autoSort,
      required this.listTileHeight,
      this.onSearchTap,
      this.onSearchSubmit,
      this.listTextStyle,
      required this.listPadding})
      : super(key: key);
  final List<DropDownValueModel> dropDownList;
  final ValueSetter onChanged;
  final double height;
  final double listTileHeight;
  final bool enableSearch;
  final double searchHeight;
  final FocusNode searchFocusNode;
  final FocusNode mainFocusNode;
  final TextInputType? searchKeyboardType;
  final bool searchAutofocus;
  final bool? searchShowCursor;
  final TextEditingController mainController;
  final bool autoSort;
  final Function? onSearchTap;
  final Function? onSearchSubmit;
  final TextStyle? listTextStyle;
  final ListPadding listPadding;

  @override
  State<SingleSelection> createState() => _SingleSelectionState();
}

class _SingleSelectionState extends State<SingleSelection> {
  late List<DropDownValueModel> newDropDownList;
  late TextEditingController _searchCnt;
  late FocusScopeNode _focusScopeNode;
  onItemChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        newDropDownList = List.from(widget.dropDownList);
      } else {
        newDropDownList = widget.dropDownList
            .where(
                (item) => item.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    _focusScopeNode = FocusScopeNode();
    if (widget.searchAutofocus) {
      widget.searchFocusNode.requestFocus();
    }
    _focusScopeNode.requestFocus();
    newDropDownList = List.from(widget.dropDownList);
    _searchCnt = TextEditingController();
    if (widget.autoSort) {
      onItemChanged(widget.mainController.text);
      widget.mainController.addListener(() {
        if (mounted) {
          onItemChanged(widget.mainController.text);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.enableSearch)
          SizedBox(
            height: widget.searchHeight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                focusNode: widget.searchFocusNode,
                showCursor: widget.searchShowCursor,
                keyboardType: widget.searchKeyboardType,
                controller: _searchCnt,
                onTap: () {
                  if (widget.onSearchTap != null) {
                    widget.onSearchTap!();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search Here...',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      widget.mainFocusNode.requestFocus();
                      _searchCnt.clear();
                      onItemChanged("");
                    },
                    child: widget.searchFocusNode.hasFocus
                        ? const InkWell(
                            child: Icon(Icons.close),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                onChanged: onItemChanged,
                onSubmitted: (val) {
                  widget.mainFocusNode.requestFocus();
                  if (widget.onSearchSubmit != null) {
                    widget.onSearchSubmit!();
                  }
                },
              ),
            ),
          ),
        SizedBox(
          height: widget.height,
          child: Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: newDropDownList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    widget.onChanged(newDropDownList[index]);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: widget.listPadding.bottom,
                        top: widget.listPadding.top),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(newDropDownList[index].name,
                            style: widget.listTextStyle),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

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
      this.listTextStyle})
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
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          widget.dropDownList[index].name,
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
              padding: const EdgeInsets.only(right: 8.0, top: 15, bottom: 10),
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

class DropDownValueModel extends Equatable {
  final String name;
  final dynamic value;

  ///as of now only added for multiselection dropdown
  final String? toolTipMsg;

  const DropDownValueModel(
      {required this.name, required this.value, this.toolTipMsg});

  factory DropDownValueModel.fromJson(Map<String, dynamic> json) =>
      DropDownValueModel(
        name: json["name"],
        value: json["value"],
        toolTipMsg: json["toolTipMsg"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "toolTipMsg": toolTipMsg,
      };
  @override
  List<Object> get props => [name, value];
}

class SingleValueDropDownController extends ChangeNotifier {
  DropDownValueModel? dropDownValue;
  SingleValueDropDownController({DropDownValueModel? data}) {
    setDropDown(data);
  }
  setDropDown(DropDownValueModel? model) {
    dropDownValue = model;
    notifyListeners();
  }

  clearDropDown() {
    dropDownValue = null;
    notifyListeners();
  }
}

class MultiValueDropDownController extends ChangeNotifier {
  List<DropDownValueModel>? dropDownValueList;
  MultiValueDropDownController({List<DropDownValueModel>? data}) {
    setDropDown(data);
  }
  setDropDown(List<DropDownValueModel>? modelList) {
    if (modelList != null && modelList.isNotEmpty) {
      List<DropDownValueModel> list = [];
      for (DropDownValueModel item in modelList) {
        if (!list.contains(item)) {
          list.add(item);
        }
      }
      dropDownValueList = list;
    } else {
      dropDownValueList = null;
    }
    notifyListeners();
  }

  clearDropDown() {
    dropDownValueList = null;
    notifyListeners();
  }
}

class ListPadding {
  double top;
  double bottom;
  ListPadding({this.top = 15, this.bottom = 15});
}
