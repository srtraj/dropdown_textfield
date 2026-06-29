import 'package:flutter/material.dart';

import 'models.dart';

/// Internal widget that renders the single-selection dropdown list,
/// optionally with a search field above the list.
class SingleSelection extends StatefulWidget {
  const SingleSelection({
    super.key,
    required this.dropDownList,
    required this.onChanged,
    required this.height,
    required this.enableSearch,
    required this.searchHeight,
    this.searchTextStyle,
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
    this.searchDecoration,
    required this.listPadding,
    this.clearIconProperty,
    this.selectedItemHighlightColor,
    this.selectedItem,
    this.textAlign,
    this.textDirection,
    required this.maxLines,
  });

  final List<DropDownValueModel> dropDownList;
  final ValueSetter<DropDownValueModel> onChanged;
  final double height;
  final double listTileHeight;
  final bool enableSearch;
  final double searchHeight;
  final TextStyle? searchTextStyle;
  final FocusNode searchFocusNode;
  final FocusNode mainFocusNode;
  final TextInputType? searchKeyboardType;
  final bool searchAutofocus;
  final bool? searchShowCursor;
  final TextEditingController mainController;
  final bool autoSort;
  final VoidCallback? onSearchTap;
  final VoidCallback? onSearchSubmit;
  final TextStyle? listTextStyle;
  final ListPadding listPadding;
  final InputDecoration? searchDecoration;
  final IconProperty? clearIconProperty;
  final Color? selectedItemHighlightColor;
  final DropDownValueModel? selectedItem;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int maxLines;

  @override
  State<SingleSelection> createState() => _SingleSelectionState();
}

class _SingleSelectionState extends State<SingleSelection> {
  late List<DropDownValueModel> _filteredList;
  late TextEditingController _searchController;
  late FocusScopeNode _focusScopeNode;
  late InputDecoration _searchInputDecoration;

  @override
  void initState() {
    super.initState();
    _focusScopeNode = FocusScopeNode();
    _searchInputDecoration = widget.searchDecoration ?? const InputDecoration();
    _filteredList = List.from(widget.dropDownList);
    _searchController = TextEditingController();

    if (widget.searchAutofocus) {
      widget.searchFocusNode.requestFocus();
    }
    _focusScopeNode.requestFocus();

    if (widget.autoSort) {
      _onSearchTextChanged(widget.mainController.text);
      widget.mainController.addListener(() {
        if (mounted) {
          _onSearchTextChanged(widget.mainController.text);
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String value) {
    setState(() {
      _filteredList = value.isEmpty
          ? List.from(widget.dropDownList)
          : widget.dropDownList
                .where(
                  (item) =>
                      item.name.toLowerCase().contains(value.toLowerCase()),
                )
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [if (widget.enableSearch) _buildSearchField(), _buildList()],
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: widget.searchHeight,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          style: widget.searchTextStyle,
          focusNode: widget.searchFocusNode,
          showCursor: widget.searchShowCursor,
          keyboardType: widget.searchKeyboardType,
          controller: _searchController,
          onTap: widget.onSearchTap,
          decoration: _searchInputDecoration.copyWith(
            hintText: _searchInputDecoration.hintText ?? 'Search Here...',
            suffixIcon: GestureDetector(
              onTap: () {
                widget.mainFocusNode.requestFocus();
                _searchController.clear();
                _onSearchTextChanged('');
              },
              child: widget.searchFocusNode.hasFocus
                  ? InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: Icon(
                        widget.clearIconProperty?.icon ?? Icons.close,
                        size: widget.clearIconProperty?.size,
                        color: widget.clearIconProperty?.color,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          onChanged: _onSearchTextChanged,
          onSubmitted: (_) {
            widget.mainFocusNode.requestFocus();
            widget.onSearchSubmit?.call();
          },
        ),
      ),
    );
  }

  Widget _buildList() {
    return SizedBox(
      height: widget.height,
      child: Scrollbar(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _filteredList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _filteredList[index];
            final isSelected = widget.selectedItem == item;

            return SizedBox(
              height:
                  widget.listTileHeight +
                  widget.listPadding.top +
                  widget.listPadding.bottom,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 10,
                  left: 10,
                  bottom: widget.listPadding.bottom,
                  top: widget.listPadding.top,
                ),
                child: Semantics(
                  label: item.name,
                  button: true,
                  child: Material(
                    color:
                        isSelected && widget.selectedItemHighlightColor != null
                        ? widget.selectedItemHighlightColor
                        : Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => widget.onChanged(item),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              isSelected &&
                                  widget.selectedItemHighlightColor != null
                              ? 8.0
                              : 0.0,
                        ),
                        child: Directionality(
                          textDirection:
                              widget.textDirection ??
                              Directionality.of(context),
                          child: Row(
                            children: [
                              item.prefixWidget ?? const SizedBox.shrink(),
                              Expanded(
                                child:
                                    item.customListItem ??
                                    Text(
                                      item.name,
                                      style: widget.listTextStyle,
                                      textAlign: widget.textAlign,
                                      maxLines: widget.maxLines,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
}
