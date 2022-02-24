# Flutter DropdownTextfield

A DropdownTextfield is a material design TextField. The DropDownButton is a widget that we can use to select one unique value or multivalue from a set of values.

## Key Features

1. Searchable dropdown
2. Single & multi selection
3. Material dropdown
4. Easy customizable UI
5. Easy implementation into statelessWidget
6. ToolTip dialogue for multi selection dropdown item.


## Single selection argument
```dart
    initialValue,
    dropDownList,
    padding,
    textStyle,
    onChanged,
    validator,
    isEnabled,
    enableSearch,
    dropdownRadius,
    textFieldDecoration,
    maxItemCount,
```

## Multi selection argument

```dart
    displayCompleteItem,
    initialValue,
    dropDownList,
    padding,
    textStyle,
    isForceMultiSelectionClear,
    onChanged,
    validator,
    isEnabled ,
    dropdownRadius ,
    textFieldDecoration,
    maxItemCount ,
```



### initialValue
initial value ,if it is null or not exist in dropDownList then it will not display value

### dropDownList
List<DropDownValues>,List of dropdown values

### onChanged
it is a function,called when value selected from dropdown.
for single Selection Dropdown it will return single DropDownValues object,
and for multi Selection Dropdown ,it will return list of DropDownValues object,

### isForceMultiSelectionClear
by setting isForceMultiSelectionClear=true to deselect selected item,only applicable for multi selection dropdown

### textFieldDecoration
to override default textfield decoration

### isEnabled
by setting isEnabled=false to disable textfield,default value true


### enableSearch
by setting enableSearch=true enable search option in dropdown,as of now this feature enabled only for single selection dropdown

### displayCompleteItem
set displayCompleteItem=true, if you want display complete list of selected item in textfield else it will display in shorten form.

### maxItemCount
you can define maximum number of dropdown item length,default value is 6

### dropdownRadius
define the radius of dropdown List widget ,default value is 12




## Example

### Single Selection dropdown

```dart
CustomDropDown(
                  // initialValue: "name4",
                  validator: (value) {
                    if (value == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownList: [
                    DropDownValues(name: 'name1', value: "value1"),
                    DropDownValues(name: 'name2', value: "value2"),
                    DropDownValues(name: 'name3', value: "value3"),
                    DropDownValues(name: 'name4', value: "value4"),
                    DropDownValues(name: 'name5', value: "value5"),
                    DropDownValues(name: 'name6', value: "value6"),
                    DropDownValues(name: 'name7', value: "value7"),
                    DropDownValues(name: 'name8', value: "value8"),
                  ],
                  maxItemCount: 6,
                  onChanged: (val) {
                    print(val);
                  },
                )
```





### Single Selection dropdown with search option
```dart
   CustomDropDown(
                  dropDownList: [
                    DropDownValues(name: 'aaa', value: "aaa"),
                    DropDownValues(name: 'bbb', value: "bbb"),
                    DropDownValues(name: 'acc', value: "acc"),
                    DropDownValues(name: 'dbb', value: "dbb"),
                  ],
                  enableSearch: true,
                  onChanged: (val) {},
                ),
```


### Multi Selection dropdown with search option
```dart
         CustomDropDown.multiSelection(
                  displayCompleteItem: true,#if true ,it will display complete list of selected item or else it will display in shorten form
                  dropDownList: [
                    DropDownValues(name: 'name1', value: "value1"),
                    DropDownValues(
                        name: 'name2',
                        value: "value2",
                        toolTipMsg:
                            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                    DropDownValues(name: 'name3', value: "value3"),
                    DropDownValues(
                        name: 'name4',
                        value: "value4",
                        toolTipMsg:
                            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                    DropDownValues(name: 'name5', value: "value5"),
                    DropDownValues(name: 'name6', value: "value6"),
                    DropDownValues(name: 'name7', value: "value7"),
                    DropDownValues(name: 'name8', value: "value8"),
                  ],
                  onChanged: (val) {
                  },
                )
```




<img src="https://github.com/srtraj/imagefiles/blob/main/single%20dropdown.gif" align="left" height="600" width="350" >


<img src="https://github.com/srtraj/imagefiles/blob/main/single_search.gif" align="left" height="600" width="350" >

<img src="https://github.com/srtraj/imagefiles/blob/main/multiselectionDropdown.gif" align="left" height="600" width="350" >

<img src="https://github.com/srtraj/imagefiles/blob/main/multiselection_fullList.gif" align="left" height="600" width="350" >




