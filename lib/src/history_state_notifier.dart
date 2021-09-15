import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

class HistoryStateNotifier<T> extends StateNotifier<T> {
  HistoryStateNotifier(T state) : super(state) {
    _undoHistory = [state];
  }

  late List<T> _undoHistory;
  int _undoIndex = 0;

  @override
  set state(T value) {
    _commitToHistory(value);
    super.state = value;
  }

  @protected
  set temporaryState(T value) {
    super.state = value;
  }

  void undo() {
    if (_undoIndex + 1 < _undoHistory.length) {
      state = _undoHistory[++_undoIndex];
    }
  }

  void redo() {
    if (_undoIndex > 0) {
      state = _undoHistory[--_undoIndex];
    }
  }

  void _commitToHistory(T state) {
    if (_undoHistory.isNotEmpty && state == _undoHistory[0]) return;
    if (_undoIndex > 0) {
      _undoHistory = _undoHistory.sublist(_undoIndex, _undoHistory.length);
      _undoIndex = 0;
    }
    _undoHistory.insert(0, state);
  }
}
