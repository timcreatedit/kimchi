import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

abstract class HistoryStateNotifier<T> extends StateNotifier<T> {
  HistoryStateNotifier(
    T state, {
    bool temporary = false,
    this.maxHistoryLength = 30,
  }) : super(state) {
    _undoHistory = temporary ? [] : [state];
  }

  /// How many states this state notifier will keep track of
  final int maxHistoryLength;

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
    if (_undoHistory.isEmpty || value != _undoHistory[0]) {
      clearRedoQueue();
      _undoHistory.insert(0, value);
      if (_undoHistory.length > maxHistoryLength) {
        _undoHistory = _undoHistory.sublist(0, maxHistoryLength);
      }
    }

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

  /// You can override this to prevent undo/redo operations in certain cases
  /// (e.g. when in a loading state)
  bool get allowOperations => true;

  /// You can override this function if you want to transform states from the
  /// history before they get applied.
  ///
  /// This can be useful if your state contains values that aren't supposed
  /// to be changed upon undoing for example.
  T applyHistoryState(T state) {
    return state;
  }

  /// Returns to the previous state in the history.
  void undo() {
    if (canUndo && allowOperations) {
      temporaryState = _undoHistory[++_undoIndex];
    }
  }

  /// Proceeds to the next state in the history.
  void redo() {
    if (canRedo && allowOperations) {
      temporaryState = _undoHistory[--_undoIndex];
    }
  }

  /// Removes all history items from the queue.
  void clearQueue() {
    _undoHistory = [];
    _undoIndex = 0;
    temporaryState = state;
  }

  /// Removes all history items that happened after the current undo position.
  ///
  /// Internally this is used whenever a change occurs, but you might want to
  /// use it for something else.
  void clearRedoQueue() {
    if (canRedo) {
      _undoHistory = _undoHistory.sublist(_undoIndex, _undoHistory.length);
      _undoIndex = 0;
    }
    temporaryState = state;
  }
}
