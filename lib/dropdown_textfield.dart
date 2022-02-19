library dropdown_textfield;

import 'package:dropdown_textfield/tooltip_widget.dart';
import 'package:flutter/material.dart';

import 'dropdown_model.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown(
      {Key? key,
      this.initialValue,
      required this.dropDownList,
      this.isMultiSelection = false,
      this.padding,
      this.textStyle,
      this.toolTipMsg,
      this.hintText,
      this.isForceMultiSelectionClear = false,
      this.onChanged,
      this.validatorMsg,
      this.isEnabled = true,
      this.enableSearch = false,
      this.textFieldDecoration})
      : super(key: key);
  final String? initialValue;
  final List<DropDownValues> dropDownList;
  final ValueSetter? onChanged;
  final bool isMultiSelection;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final String? hintText;
  final List? toolTipMsg;
  final bool isForceMultiSelectionClear;
  final InputDecoration? textFieldDecoration;
  final bool isEnabled;
  final String? validatorMsg;
  final bool enableSearch;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown>
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
  late List<DropDownValues> newDropDownList;
  late int maxListItem;
  late double searchWidgetHeight;

  @override
  void initState() {
    newDropDownList = List.from(widget.dropDownList);
    isExpanded = false;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _heightFactor = _controller.drive(_easeInTween);
    for (int i = 0; i < newDropDownList.length; i++) {
      multiSelectionValue.add(false);
    }
    searchWidgetHeight = 60;
    hintText = "Select Item";
    _cnt = TextEditingController(text: widget.initialValue);
    maxListItem = 6;
    height = !widget.isMultiSelection
        ? newDropDownList.length < maxListItem
            ? newDropDownList.length * 50
            : 50 * maxListItem.toDouble()
        : newDropDownList.length < 6
            ? newDropDownList.length * 50
            : 50 * maxListItem.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isForceMultiSelectionClear) {
      multiSelectionValue = [];
      _cnt.text = "";
      for (int i = 0; i < newDropDownList.length; i++) {
        multiSelectionValue.add(false);
      }
    }
    return CompositedTransformTarget(
      link: layerLink,
      child: FocusScope(
        child: Focus(
          onFocusChange: (focus) {
            if (!focus && isExpanded && !widget.isMultiSelection) {
              isExpanded = !isExpanded;
              hideOverlay();
            }
          },
          child: TextFormField(
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
                if (widget.isMultiSelection) {
                } else {}
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                if (widget.validatorMsg != null) return widget.validatorMsg;
                return "Please select item";
              }
              return null;
            },
            decoration: widget.textFieldDecoration != null
                ? widget.textFieldDecoration!.copyWith(
                    hintText: hintText,
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down_outlined,
                    ),
                  )
                : InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: hintText,
                    hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down_outlined,
                    ),
                  ),
          ),
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: !widget.isMultiSelection
                  ? SingleSelection(
                      enableSearch: widget.enableSearch,
                      height: height,
                      dropDownList: newDropDownList,
                      onChanged: (item) {
                        setState(() {
                          _cnt.text = item.name;
                          isExpanded = !isExpanded;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(item.value);
                        }
                        // Navigator.pop(context, null);
                        hideOverlay();
                      },
                      searchHeight: searchWidgetHeight,
                    )
                  : MultiSelection(
                      height: height,
                      toolTipMsg: widget.toolTipMsg,
                      list: multiSelectionValue,
                      dropDownList: newDropDownList,
                      onChanged: (val) {
                        hideOverlay();
                        setState(() {
                          isExpanded = !isExpanded;
                          multiSelectionValue = val;
                          int count = multiSelectionValue
                              .where((element) => element)
                              .toList()
                              .length;

                          _cnt.text =
                              (count == 0 ? "" : "$count item selected");
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(multiSelectionValue);
                        }
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// setState(() {
// _cnt.text = newDropDownList[index].name;
// isExpanded = !isExpanded;
// });
// hideOverlay();

class SingleSelection extends StatefulWidget {
  const SingleSelection(
      {Key? key,
      required this.dropDownList,
      required this.onChanged,
      required this.height,
      required this.enableSearch,
      required this.searchHeight})
      : super(key: key);
  final List<DropDownValues> dropDownList;
  final ValueSetter onChanged;
  final double height;
  final bool enableSearch;
  final double searchHeight;

  @override
  State<SingleSelection> createState() => _SingleSelectionState();
}

class _SingleSelectionState extends State<SingleSelection> {
  late List<DropDownValues> newDropDownList;
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
                controller: _searchCnt,
                decoration: InputDecoration(
                  hintText: 'Search Here...',
                  suffixIcon: GestureDetector(
                      onTap: () {
                        if (_searchCnt.text.isNotEmpty) {
                          _searchCnt.clear();
                          FocusScope.of(context).unfocus();
                          onItemChanged("");
                        }
                      },
                      child: const Icon(Icons.close)),
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
                }),
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
    this.toolTipMsg,
  }) : super(key: key);
  final List<DropDownValues> dropDownList;
  final ValueSetter onChanged;
  final List<bool> list;
  final List? toolTipMsg;
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
                                if (widget.toolTipMsg != null &&
                                    index < widget.toolTipMsg!.length)
                                  ToolTipWidget(
                                    msg: widget.toolTipMsg![index],
                                    outSideClickToClose: false,
                                  )
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
                  child: const Text(
                    "Ok",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

// class CustomDialog extends PopupRoute {
//   @override
//   Color get barrierColor => Colors.transparent;
//
//   @override
//   bool get barrierDismissible => true;
//
//   @override
//   String? get barrierLabel => null;
//
//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return _builder(context);
//   }
//
//   Widget _builder(BuildContext context) {
//     return Container();
//   }
//
//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 300);
// }
