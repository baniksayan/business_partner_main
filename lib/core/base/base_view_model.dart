import 'package:flutter/material.dart';
import '../enums/view_state.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String _errorMessage = '';
  String _message = '';

  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  String get message => _message;
  bool get isBusy => _state == ViewState.busy;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setError(String error) {
    _errorMessage = error;
    _message = '';
    _state = ViewState.error;
    notifyListeners();
  }

  void setMessage(String msg) {
    _message = msg;
    _errorMessage = '';
    _state = ViewState.success;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    if (_state == ViewState.error) {
      _state = ViewState.idle;
      notifyListeners();
    }
  }
}
