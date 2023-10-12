import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:flutter_reflow/models/reflow_profile.dart';

class ReflowProfileList extends ChangeNotifier {
  final Set<ReflowProfile> _profiles;
  int? _selectedProfileIndex;

  ReflowProfileList(this._profiles);

  UnmodifiableSetView<ReflowProfile> get profiles =>
      UnmodifiableSetView(_profiles);

  /// Add a new profile to the list of profiles.
  ///
  /// Returns `true` if the profile was added, `false` otherwise.
  bool add(ReflowProfile profile) {
    if (_profiles.add(profile)) {
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Remove a profile from the list of profiles.
  ///
  /// Returns `true` if the profile was removed, `false` otherwise.
  bool remove(ReflowProfile profile) {
    if (_profiles.remove(profile)) {
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Select a profile from the list of profiles.
  void select(int? index) {
    _selectedProfileIndex = index;
    notifyListeners();
  }

  ReflowProfile? get selectedProfile {
    if (_selectedProfileIndex != null) {
      return _profiles.toList()[_selectedProfileIndex!];
    }
    return null;
  }

  bool get hasSelectedProfile => _selectedProfileIndex != null;
}
