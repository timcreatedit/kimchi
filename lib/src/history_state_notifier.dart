import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

abstract class HistoryStateNotifier<T> extends StateNotifier<T> {
  HistoryStateNotifier(T state) : super(state) {
    _undoHistory = [state];
  }

  late List<T> _undoHistory;
  int _undoIndex = 0;

  /// The current "state" of this [HistoryStateNotifier] and adds the new state
  /// to the undo history.
  ///
  /// Updating this variable will synchronously call all the listeners.
  /// Notifying the listeners is O(N) with N the number of listeners.
  ///
  /// Updating the state will throw if at least one listener throws.
  @override
  set state(T value) {
    _commitToHistory(value);
    super.state = value;
  }

  /// The current "state" of this [HistoryStateNotifier] **without** adding
  /// the new state to the undo history.
  ///
  /// This is helpful for loading states or in general any other state that the
  /// user should not be able to undo to.
  ///
  /// Updating this variable will synchronously call all the listeners.
  /// Notifying the listeners is O(N) with N the number of listeners.
  ///
  /// Updating the state will throw if at least one listener throws.
  @protected
  set temporaryState(T value) {
    super.state = value;
  }

  /// Whether currently an undo operation is possible.
  bool get canUndo => (_undoIndex + 1 < _undoHistory.length);

  /// Whether a redo operation is currently possible.
  bool get canRedo => (_undoIndex > 0);

  /// Returns to the previous state in the history.
  void undo() {
    if (_undoIndex + 1 < _undoHistory.length) {
      state = _undoHistory[++_undoIndex];
    }
  }

  /// Proceeds to the next state in the history.
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
