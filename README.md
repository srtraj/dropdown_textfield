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
singleController
initialValue
required dropDownList
padding
textStyle
onChanged
validator
isEnabled
enableSearch
dropdownRadius
textFieldDecoration
maxItemCount
searchFocusNode
textFieldFocusNode
searchAutofocus
searchShowCursor
searchKeyboardType
clearOption
```

## Multi selection argument

```dart
    multiController
displayCompleteItem 
initialValue
required dropDownList
padding
textStyle
isForceMultiSelectionClear
onChanged
validator
isEnabled 
dropdownRadius 
textFieldDecoration
maxItemCount
searchFocusNode
textFieldFocusNode
clearOption 
```



### initialValue
initial value ,if it is null or not exist in dropDownList then it will not display value

### dropDownList
List<DropDownValueModel>,List of dropdown values

### onChanged
it is a function,called when value selected from dropdown.
for single Selection Dropdown it will return single DropDownValueModel object,
and for multi Selection Dropdown ,it will return list of DropDownValueModel object,

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


### searchKeyboardType
override default search keyboard type

### searchAutofocus
by setting searchAutofocus=true to autofocus search textfield,default value is false


### searchShowCursor
by setting searchShowCursor=false to hide cursor from search textfield

### clearOption
by set clearOption=false to hide clear suffix icon button from textfield





## Example

### Single Selection dropdown

```dart
DropDownTextField(
                  // initialValue: "name4",
                  validator: (value) {
                    if (value == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownList: [
                    DropDownValueModel(name: 'name1', value: "value1"),
                    DropDownValueModel(name: 'name2', value: "value2"),
                    DropDownValueModel(name: 'name3', value: "value3"),
                    DropDownValueModel(name: 'name4', value: "value4"),
                    DropDownValueModel(name: 'name5', value: "value5"),
                    DropDownValueModel(name: 'name6', value: "value6"),
                    DropDownValueModel(name: 'name7', value: "value7"),
                    DropDownValueModel(name: 'name8', value: "value8"),
                  ],
                  maxItemCount: 6,
                  onChanged: (val) {
                    print(val);
                  },
                )
```





### Single Selection dropdown with search option
```dart
   DropDownTextField(
                  dropDownList: [
                    DropDownValueModel(name: 'aaa', value: "aaa"),
                    DropDownValueModel(name: 'bbb', value: "bbb"),
                    DropDownValueModel(name: 'acc', value: "acc"),
                    DropDownValueModel(name: 'dbb', value: "dbb"),
                  ],
                  enableSearch: true,
                  onChanged: (val) {},
                ),
```


### Multi Selection dropdown with search option
```dart
         DropDownTextField.multiSelection(
                  displayCompleteItem: true,#if true ,it will display complete list of selected item or else it will display in shorten form
                  dropDownList: [
                    DropDownValueModel(name: 'name1', value: "value1"),
                    DropDownValueModel(
                        name: 'name2',
                        value: "value2",
                        toolTipMsg:
                            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                    DropDownValueModel(name: 'name3', value: "value3"),
                    DropDownValueModel(
                        name: 'name4',
                        value: "value4",
                        toolTipMsg:
                            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                    DropDownValueModel(name: 'name5', value: "value5"),
                    DropDownValueModel(name: 'name6', value: "value6"),
                    DropDownValueModel(name: 'name7', value: "value7"),
                    DropDownValueModel(name: 'name8', value: "value8"),
                  ],
                  onChanged: (val) {
                  },
                )
```




<img src="https://github.com/srtraj/imagefiles/blob/main/single%20dropdown.gif" align="left" height="600" width="350" >


<img src="https://github.com/srtraj/imagefiles/blob/main/single_search.gif" align="left" height="600" width="350" >

<img src="https://github.com/srtraj/imagefiles/blob/main/multiselection%20dropdown.gif" align="left" height="600" width="350" >

<img src="https://github.com/srtraj/imagefiles/blob/main/multiSelectionDropdown2.gif" align="left" height="600" width="350" >




