# Flutter DropdownTextfield

A DropdownTextfield is a material design TextField. The DropDownButton is a widget that we can use to select one unique value or multivalue from a set of values.

## Key Features

1. Searchable dropdown
2. Single & multi selection
3. Material dropdown
4. Easy customizable UI
5. Easy implementation into statelessWidget
6. ToolTip dialogue for multi selection dropdown item.


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
),
```

<a href="url"><img src="https://drive.google.com/uc?export=view&id=1jMFMeMwPDnQnvaemzE6fnx3Gb-vy_NMk" align="left" height="600" width="350" ></a>
