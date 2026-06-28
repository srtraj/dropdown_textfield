import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'models.dart';

/// Sealed base class for all dropdown controllers.
///
/// Use [SingleValueDropDownController] for single-selection dropdowns
/// and [MultiValueDropDownController] for multi-selection dropdowns.
///
/// Because this is a sealed class, Dart's exhaustive pattern matching
/// guarantees that every subtype is handled:
/// ```dart
/// switch (controller) {
///   case SingleValueDropDownController s: ...
///   case MultiValueDropDownController m: ...
/// }
/// ```
sealed class DropDownController extends ChangeNotifier {}

/// Controller for a single-value dropdown.
///
/// Use [setDropDown] to programmatically set a value, and [clearDropDown]
/// to clear the selection. Listen to changes via [addListener].
class SingleValueDropDownController extends DropDownController {
  DropDownValueModel? dropDownValue;

  SingleValueDropDownController({DropDownValueModel? data}) {
    setDropDown(data);
  }

  /// Sets the current dropdown selection. Notifies listeners only when the
  /// value actually changes.
  void setDropDown(DropDownValueModel? model) {
    if (dropDownValue != model) {
      dropDownValue = model;
      notifyListeners();
    }
  }

  /// Clears the current dropdown selection. Notifies listeners only when
  /// there was a value to clear.
  void clearDropDown() {
    if (dropDownValue != null) {
      dropDownValue = null;
      notifyListeners();
    }
  }
}

/// Controller for a multi-value dropdown.
///
/// Use [setDropDown] to programmatically set selected values, and
/// [clearDropDown] to clear all selections. Duplicate items are deduplicated
/// automatically.
class MultiValueDropDownController extends DropDownController {
  List<DropDownValueModel>? dropDownValueList;

  MultiValueDropDownController({List<DropDownValueModel>? data}) {
    setDropDown(data);
  }

  /// Sets the current dropdown selection, deduplicating items.
  /// Notifies listeners only when the list actually changes (order-independent).
  void setDropDown(List<DropDownValueModel>? modelList) {
    List<DropDownValueModel>? deduplicated;

    if (modelList != null && modelList.isNotEmpty) {
      final seen = <DropDownValueModel>[];
      for (final item in modelList) {
        if (!seen.contains(item)) {
          seen.add(item);
        }
      }
      deduplicated = seen;
    }

    final unorderedEquals = const DeepCollectionEquality.unordered().equals;
    if (!unorderedEquals(deduplicated, dropDownValueList)) {
      dropDownValueList = deduplicated;
      notifyListeners();
    }
  }

  /// Clears all selections. Notifies listeners only if there were selections.
  void clearDropDown() {
    if (dropDownValueList != null) {
      dropDownValueList = null;
      notifyListeners();
    }
  }
}
