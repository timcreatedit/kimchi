import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:rxdart/rxdart.dart';

abstract class Viewmodel extends ChangeNotifier {
  @mustCallSuper
  Viewmodel(this.reader) {
    busy = true;
    init().then((_) => busy = false);
  }

  /// A reference to a Riverpod [Reader] which can be user for reading
  /// dependencies from the Service Layer.
  final Reader reader;

  /// A composite subscription useful for adding subscriptions to that should
  /// be disposed when the Viewmodel gets disposed.
  final CompositeSubscription compositeSubscription = CompositeSubscription();

  bool _busy = false;

  /// Helper boolean for busy state.
  ///
  /// Can be used to display a progress indicator for example.
  bool get busy => _busy;

  /// Helper boolean for busy state.
  ///
  /// Can be used to display a progress indicator for example.
  set busy(bool value) {
    _busy = value;
    notifyListeners();
  }

  /// This method can be used to initialize the repository asynchronously.
  ///
  /// The Viewmodel is [busy] while this method runs, this is useful for
  /// fetching data for example.
  Future<void> init();

  /// Discards any resources used by the viewmodel and also disposes all
  /// subscriptions in [compositeSubscription].
  ///
  /// After this is called, the object is not in a usable state and should be
  /// discarded.
  @override
  @mustCallSuper
  void dispose() {
    compositeSubscription.dispose();
    super.dispose();
  }
}
