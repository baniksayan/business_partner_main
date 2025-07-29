import 'package:flutter/material.dart';
import '../enums/view_state.dart';

abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    _state = ViewState.error;
    notifyListeners();
  }

  bool get isLoading => _state == ViewState.busy;
  bool get hasError => _state == ViewState.error;
  bool get isIdle => _state == ViewState.idle;
}
