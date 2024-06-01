# Flutter DropdownTextfield

A `DropdownTextfield` is a Material Design `TextField`. The `DropDownButton` is a widget that can be used to select one unique value or multiple values from a set of options.

## Key Features

1. Searchable dropdown
2. Single & multi-selection
3. Material dropdown
4. Easily customizable UI
5. Easy implementation into `StatelessWidget`
6. ToolTip dialogue for multi-selection dropdown items

## Examples

<table>
  <tr>
    <th>Single Dropdown</th>
    <th>Single Dropdown with Search Option</th>
    <th>Single Dropdown with Clear Option</th>
  </tr>
  <tr>
    <td><img src="https://github.com/srtraj/dropdown_textfield/raw/development/example/examples/single-dropdown.gif" alt="Single Dropdown" height="500" width="260"></td>
    <td><img src="https://github.com/srtraj/dropdown_textfield/raw/development/example/examples/single-dropdown-with-search-option.gif" alt="Single Dropdown with Search Option" height="500" width="260"></td>
    <td><img src="https://github.com/srtraj/dropdown_textfield/raw/development/example/examples/single-dropdown-with-clearOption.gif" alt="Single Dropdown with Clear Option" height="500" width="260"></td>
  </tr>
</table>

<table>
  <tr>
    <th>Multiple Dropdown</th>
    <th>Multiple Dropdown with All Selected Items</th>
  </tr>
  <tr>
    <td><img src="https://github.com/srtraj/dropdown_textfield/raw/development/example/examples/multiselection-dropdown.gif" alt="Multiple Dropdown" height="500" width="260"></td>
    <td><img src="https://github.com/srtraj/dropdown_textfield/raw/development/example/examples/multiselection-with-all-selected-items.gif" alt="Multiple Dropdown with All Selected Items" height="500" width="260"></td>
  </tr>
</table>

## Usage

### Controllers
You need to use `SingleValueDropDownController` for single dropdown and `MultiValueDropDownController` for multiple dropdown.

### Properties

- **dropdownRadius**: Defines the radius of the dropdown list. Default value is 12.
- **initialValue**: Sets the initial value. If null or not in the `dropDownList`, it will not display any value.
- **dropDownList**: A list of dropdown values of type `<DropDownValueModel>`.
- **onChanged**: Listens for item selection changes. Returns a single `DropDownValueModel` object for single selection dropdown, and a list of `DropDownValueModel` objects for multi-selection dropdown.
- **textFieldDecoration**: Overrides the default text field decoration.
- **dropDownIconProperty**: Customizes the dropdown icon size and color.
- **isEnabled**: Set to `false` to disable the text field. Default value is `true`.
- **enableSearch**: Set to `true` to enable the search option in the dropdown. Currently available only for single selection dropdown.
- **displayCompleteItem**: Set to `true` to display the complete list of selected items in the text field. Otherwise, it will display as "number_of_items selected".
- **dropDownItemCount**: Maximum number of dropdown items to display. Default value is 6.
- **searchKeyboardType**: Overrides the default search keyboard type. Applicable only if `enableSearch=true`.
- **searchAutofocus**: Set to `true` to autofocus the search text field. Applicable only if `enableSearch=true`. Default value is `false`.
- **searchShowCursor**: Set to `false` to hide the cursor from the search text field. Applicable only if `enableSearch=true`.
- **clearOption**: Set to `false` to hide the clear suffix icon button from the text field.
- **clearIconProperty**: Customizes the clear icon size and color.
- **listSpace**: Space between the text field and the list. Default value is 0.
- **listPadding**: Padding for dropdown list items.
- **submitButtonText**: Text for the multi-dropdown submit button.
- **submitButtonColor**: Color of the multi-dropdown submit button.
- **submitButtonTextStyle**: Text style for the multi-dropdown submit button.
- **listTextStyle**: Text style for dropdown list items.
- **checkBoxProperty**: Customizes the properties of multiple checkboxes.
