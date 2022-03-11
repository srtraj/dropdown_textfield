import 'package:collection/collection.dart';
import 'package:dropdown_textfield/tooltip_widget.dart';
import 'package:flutter/material.dart';

bool calledFromOutside = true;

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
      this.dropdownRadius = 12,
      this.textFieldDecoration,
      this.maxItemCount = 6,
      this.searchFocusNode,
      this.textFieldFocusNode,
      this.searchAutofocus = false,
      this.searchShowCursor,
      this.searchKeyboardType,
      this.clearOption = true})
      : assert(!(initialValue != null && singleController != null),
            "you cannot add both,add initial value by SingleValueDropDownController(data:initial value) "),
        isMultiSelection = false,
        isForceMultiSelectionClear = false,
        displayCompleteItem = false,
        multiController = null,
        super(key: key);
  const DropDownTextField.multiSelection(
      {Key? key,
      this.multiController,
      this.displayCompleteItem = false,
      this.initialValue,
      required this.dropDownList,
      this.padding,
      this.textStyle,
      this.isForceMultiSelectionClear = false,
      this.onChanged,
      this.validator,
      this.isEnabled = true,
      this.dropdownRadius = 12,
      this.textFieldDecoration,
      this.maxItemCount = 6,
      this.searchFocusNode,
      this.textFieldFocusNode,
      this.clearOption = true})
      : assert(initialValue == null || multiController == null,
            "you cannot add both,add initial value by MultiValueDropDownController(data:initial value) "),
        isMultiSelection = true,
        enableSearch = false,
        searchAutofocus = false,
        searchKeyboardType = null,
        searchShowCursor = null,
        singleController = null,
        super(key: key);

  ///single dropdown controller,
  final SingleValueDropDownController? singleController;

  ///multi dropdown controlleer
  final MultiValueDropDownController? multiController;

  ///define the radius of dropdown List ,default value is 12
  final double dropdownRadius;

  ///initial value ,if it is null or not exist in dropDownList then it will not display value
  final dynamic initialValue;

  ///List<DropDownValueModel>,List of dropdown values
  final List<DropDownValueModel> dropDownList;

  ///it is a function,called when value selected from dropdown.
  ///for single Selection Dropdown it will return single DropDownValueModel object,
  ///and for multi Selection Dropdown ,it will return list of DropDownValueModel object,
  final ValueSetter? onChanged;

  ///by setting isMultiSelection=true to make multi selection dropdown
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

  ///set displayCompleteItem=true, if you want show complete list of item in textfield else it will display like "number_of_item item selected"
  final bool displayCompleteItem;

  ///you can define maximum number dropdown item length,default value is 6
  final int maxItemCount;

  final FocusNode? searchFocusNode;
  final FocusNode? textFieldFocusNode;

  ///override default search keyboard type,only applicable if enableSearch=true,
  final TextInputType? searchKeyboardType;

  ///by setting searchAutofocus=true to autofocus search textfield,only applicable if enableSearch=true,
  ///  ///default value is false
  final bool searchAutofocus;

  ///by setting searchShowCursor=false to hide cursor from search textfield,only applicable if enableSearch=true,
  final bool? searchShowCursor;

  ///by set clearOption=false to hide clear suffix icon button from textfield
  final bool clearOption;

  @override
  _DropDownTextFieldState createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField>
    with TickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  late TextEditingController _cnt;
  late String hintText;

  late bool isExpanded;
  OverlayEntry? entry;
  final layerLink = LayerLink();
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  List<bool> multiSelectionValue = [];
  // late String selectedItem;
  late double height;
  late List<DropDownValueModel> dropDownList;
  late int maxListItem;
  late double searchWidgetHeight;
  late FocusNode searchFocusNode;
  late FocusNode textFieldFocusNode;
  @override
  void initState() {
    _cnt = TextEditingController();
    searchFocusNode = widget.searchFocusNode ?? FocusNode();
    textFieldFocusNode = widget.textFieldFocusNode ?? FocusNode();
    isExpanded = false;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _heightFactor = _controller.drive(_easeInTween);
    searchWidgetHeight = 60;
    hintText = "Select Item";
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus &&
          !textFieldFocusNode.hasFocus &&
          isExpanded &&
          !widget.isMultiSelection) {
        isExpanded = !isExpanded;
        hideOverlay();
      }
    });
    textFieldFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus &&
          !textFieldFocusNode.hasFocus &&
          isExpanded) {
        isExpanded = !isExpanded;
        hideOverlay();
      }
    });
    for (int i = 0; i < widget.dropDownList.length; i++) {
      multiSelectionValue.add(false);
    }
    updateFunction();
    super.initState();
  }

  updateFunction({DropDownTextField? oldWidget}) {
    Function eq = const ListEquality().equals;
    dropDownList = List.from(widget.dropDownList);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.isMultiSelection) {
        if (oldWidget != null && !eq(oldWidget.dropDownList, dropDownList)) {
          multiSelectionValue = [];
          _cnt.text = "";
          for (int i = 0; i < dropDownList.length; i++) {
            multiSelectionValue.add(false);
          }
        }
        if (widget.isForceMultiSelectionClear &&
            multiSelectionValue.isNotEmpty) {
          multiSelectionValue = [];
          _cnt.text = "";
          for (int i = 0; i < dropDownList.length; i++) {
            multiSelectionValue.add(false);
          }
        }

        if (widget.multiController != null) {
          List<DropDownValueModel> multiCnt = [];
          for (int i = 0; i < dropDownList.length; i++) {
            if (multiSelectionValue[i]) {
              multiCnt.add(dropDownList[i]);
            }
          }
          widget.multiController!
              .setDropDown(multiCnt.isNotEmpty ? multiCnt : null);
        }
        if (widget.initialValue != null) {
          for (int i = 0; i < widget.initialValue.length; i++) {
            var index = dropDownList.indexWhere((element) =>
                element.name.trim() == widget.initialValue[i].trim());
            if (index != -1) {
              multiSelectionValue[i] = true;
            }
          }
          int count =
              multiSelectionValue.where((element) => element).toList().length;

          _cnt.text = (count == 0
              ? ""
              : widget.displayCompleteItem
                  ? widget.initialValue.join(",")
                  : "$count item selected");
        }
        if (widget.multiController != null &&
            widget.multiController!.dropDownValueList != null) {
          for (int i = 0;
              i < widget.multiController!.dropDownValueList!.length;
              i++) {
            var index = dropDownList.indexWhere((element) =>
                element.value ==
                widget.multiController!.dropDownValueList![i].value);
            if (index != -1) {
              multiSelectionValue[i] = true;
            }
          }
          int count =
              multiSelectionValue.where((element) => element).toList().length;

          _cnt.text = (count == 0
              ? ""
              : widget.displayCompleteItem
                  ? widget.initialValue.join(",")
                  : "$count item selected");
        }
      } else {
        if (widget.initialValue != null) {
          var index = dropDownList.indexWhere(
              (element) => element.name.trim() == widget.initialValue.trim());
          if (index != -1) {
            WidgetsBinding.instance!
                .addPostFrameCallback((_) => _cnt.text = widget.initialValue);
            // if (widget.singleController != null) {
            //   widget.singleController!.setDropDown(widget.dropDownList[index]);
            // }
          }
        }
        if (widget.singleController != null &&
            widget.singleController!.dropDownValue != null) {
          _cnt.text = widget.singleController!.dropDownValue!.name;
        }
      }
    });
    maxListItem = widget.maxItemCount;
    height = !widget.isMultiSelection
        ? dropDownList.length < maxListItem
            ? dropDownList.length * 50
            : 50 * maxListItem.toDouble()
        : dropDownList.length < maxListItem
            ? dropDownList.length * 50
            : 50 * maxListItem.toDouble();
  }

  @override
  void didUpdateWidget(covariant DropDownTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateFunction(oldWidget: oldWidget);
  }

  @override
  void dispose() {
    if (widget.searchFocusNode == null) searchFocusNode.dispose();
    if (widget.textFieldFocusNode == null) textFieldFocusNode.dispose();
    super.dispose();
  }

  clearFun() {
    if (isExpanded) {
      isExpanded = !isExpanded;
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

      multiSelectionValue = [];
      for (int i = 0; i < dropDownList.length; i++) {
        multiSelectionValue.add(false);
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
    return CompositedTransformTarget(
      link: layerLink,
      child: TextFormField(
        focusNode: textFieldFocusNode,
        style: widget.textStyle,
        enabled: widget.isEnabled,
        readOnly: true,
        controller: _cnt,
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
          if (isExpanded) {
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
                hintText: hintText,
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
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    double posFromTop = offset.dy;
    double posFromBot = MediaQuery.of(context).size.height - posFromTop;
    double ht = height + 120 + (widget.enableSearch ? searchWidgetHeight : 0);
    final double htPos = posFromBot < ht ? size.height - 100 : size.height;
    entry = OverlayEntry(
      builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
              targetAnchor:
                  posFromBot < ht ? Alignment.bottomCenter : Alignment.topLeft,
              followerAnchor:
                  posFromBot < ht ? Alignment.bottomCenter : Alignment.topLeft,
              link: layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, htPos),
              child: AnimatedBuilder(
                animation: _controller.view,
                builder: buildOverlay,
              ))),
    );
    overlay?.insert(entry!);
  }

  void hideOverlay() {
    _controller.reverse().then<void>((void value) {
      entry?.remove();
      entry = null;
    });
  }

  Widget buildOverlay(context, child) {
    return ClipRect(
      child: Align(
        heightFactor: _heightFactor.value,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
                      mainFocusNode: textFieldFocusNode,
                      searchFocusNode: searchFocusNode,
                      enableSearch: widget.enableSearch,
                      height: height,
                      dropDownList: dropDownList,
                      onChanged: (item) {
                        setState(() {
                          _cnt.text = item.name;
                          isExpanded = !isExpanded;
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
                      searchHeight: searchWidgetHeight,
                      searchKeyboardType: widget.searchKeyboardType,
                      searchAutofocus: widget.searchAutofocus,
                      searchShowCursor: widget.searchShowCursor,
                    )
                  : MultiSelection(
                      height: height,
                      list: multiSelectionValue,
                      dropDownList: dropDownList,
                      onChanged: (val) {
                        isExpanded = !isExpanded;
                        multiSelectionValue = val;
                        List<DropDownValueModel> result = [];
                        List completeList = [];
                        for (int i = 0; i < multiSelectionValue.length; i++) {
                          if (multiSelectionValue[i]) {
                            result.add(dropDownList[i]);
                            completeList.add(dropDownList[i].name);
                          }
                        }
                        int count = multiSelectionValue
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
      this.searchShowCursor})
      : super(key: key);
  final List<DropDownValueModel> dropDownList;
  final ValueSetter onChanged;
  final double height;
  final bool enableSearch;
  final double searchHeight;
  final FocusNode searchFocusNode;
  final FocusNode mainFocusNode;
  final TextInputType? searchKeyboardType;
  final bool searchAutofocus;
  final bool? searchShowCursor;

  @override
  State<SingleSelection> createState() => _SingleSelectionState();
}

class _SingleSelectionState extends State<SingleSelection> {
  late List<DropDownValueModel> newDropDownList;
  late TextEditingController _searchCnt;

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
    if (widget.searchAutofocus) {
      widget.searchFocusNode.requestFocus();
    }
    newDropDownList = List.from(widget.dropDownList);
    _searchCnt = TextEditingController();
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
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(newDropDownList[index].name,
                          style: Theme.of(context).textTheme.subtitle1),
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
  const MultiSelection({
    Key? key,
    required this.onChanged,
    required this.dropDownList,
    required this.list,
    required this.height,
  }) : super(key: key);
  final List<DropDownValueModel> dropDownList;
  final ValueSetter onChanged;
  final List<bool> list;
  final double height;

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
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(widget.dropDownList[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
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
                  );
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 5, top: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
                height: 40,
                width: 50,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.green,
                  child: const FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "Ok",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    widget.onChanged(multiSelectionValue);
                  },
                )),
          ),
        ),
      ],
    );
  }
}

class DropDownValueModel {
  final String name;
  final dynamic value;

  ///as of now only added for multiselection dropdown
  final String? toolTipMsg;

  DropDownValueModel(
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
    setDropDown(dropDownValueList);
  }
  setDropDown(List<DropDownValueModel>? modelList) {
    dropDownValueList = modelList;
    notifyListeners();
  }

  clearDropDown() {
    dropDownValueList = null;
    notifyListeners();
  }
}
