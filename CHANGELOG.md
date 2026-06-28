# Changelog

## 1.3.1
- **Code structure**: Split monolithic `dropdown_textfield.dart` into `src/` modules
  (`models.dart`, `controllers.dart`, `single_selection.dart`, `multi_selection.dart`,
  `tooltip_widget.dart`, `keyboard_visibility_builder.dart`)
- **Bug fix**: `DropDownValueModel.props` now includes `toolTipMsg` for correct Equatable equality
- **Bug fix**: Removed redundant manual `==` / `hashCode` override on `DropDownValueModel`
  (conflicted with Equatable)
- **Bug fix**: Removed listener leak — `removeListener` is now called in `dispose()`
- **Naming**: Renamed internal methods to Dart conventions (`clearFun` → `_clearSelection`,
  `updateFunction` → `_updateDropdownState`, `onItemChanged` → `_onSearchTextChanged`)
- **Theming**: Submit button and tooltip colors now use `Theme.of(context).colorScheme`
  instead of hard-coded `Colors.green` / `Colors.white`
- **Accessibility**: Added `Semantics` wrappers to list items, checkboxes, clear icon, and tooltip
- **DRY**: Extracted `_buildSuffixIcon()` and `_buildInputDecoration()` to eliminate
  copy-pasted decoration code
- **Tooltip**: Removed dead `toolTipDialogue` / `showAnimatedAlertDialog` methods;
  tap-barrier now dismisses the tooltip overlay; overlay is disposed on widget dispose
- **API**: `onChanged` in `SingleSelection` / `MultiSelection` now uses typed callbacks
- **SDK**: Raised minimum SDK to `>=3.0.0 <4.0.0`, Flutter `>=3.10.0`
- **pub.dev**: Added `topics` for improved discoverability
- **Lints**: Strengthened `analysis_options.yaml` with strict-casts, strict-inference,
  and additional lint rules

## 1.2.0
- 'WidgetStateProperty' not found - fixed

## 1.1.0
- Deprecated bug fixes
- README updated
- Search text customization
- RTL support added
- Animated controller dispose fix added

## 1.0.7
- Fixed clear validation error (#14)
- Autovalidate option added

## 1.0.6
- Fixed keyboard failed to show (#10)

## 1.0.5
- Option added to customize clear and dropdown icon properties
- `checkBoxProperty` added, now you can customize the default property of multiple checkbox style
- Fixed "InitialValue in multiSelection" bug (#9)

## 1.0.4
- Input decoration added for search textfield
- `singleController` and `multiController` renamed to `controller`

## 1.0.3
- Fixed animated GIF not displaying in pub page

## 1.0.1
- Fixed `keyboardSubscription` bug

## 1.0.0
- Added option to customize multiple dropdown okay button:
  - Color
  - Text and textStyle
- Added option to customize padding and text style of dropdown list tile
- Fixed setState bug on onChange function
- Added outside click to hide dropdown if textfield is hidden
- Updated to new version of Flutter (Flutter 3.0.0)

## 0.0.8
- Fixed single dropdown controller text clear function

## 0.0.7
- Added attribute to add space between textfield and list widget

## 0.0.6
- Added controller for dropdown

## 0.0.5
- Fixed state change issue

## 0.0.4
- Added attribute to hide clear suffix icon button from textfield
- Changed class name to `DropDownTextField`

## 0.0.3
- Bug fix

## 0.0.2
- Fixed bug ([#1](https://github.com/srtraj/dropdown_textfield/issues/1))

## 0.0.1
- First publication
