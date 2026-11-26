import 'package:flutter/foundation.dart';

import '../core/app_exception.dart';

/// Shared loading / error handling for every ViewModel.
abstract class BaseViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  /// Runs a list-loading action and updates [isLoading] / [errorMessage].
  Future<void> load(Future<void> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      errorMessage = friendlyError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Runs a create/update/delete action. Returns true on success,
  /// otherwise false with [errorMessage] filled in.
  Future<bool> perform(Future<void> Function() action) async {
    errorMessage = null;
    try {
      await action();
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = friendlyError(e);
      notifyListeners();
      return false;
    }
  }
}
