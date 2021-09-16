<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Kimchi is a lightweight framework for developing mobile applications using Riverpod for dependency injection and the
MVVM architecture. It is similar to the [Stacked](https://pub.dev/packages/stacked) package, however greatly reduced in
scope.

> Note: Kimchi is still under development and contains very little functionality at the moment.

## Features

* HistoryStateNotifier as a variation on StateNotifier that includes undo/redo functionality
* A base Viewmodel class based on ChangeNotifier that makes it easy to implement the MVVM architecture.
* Base classes for repositories that are currently almost blank but will include useful features at some point (hopefully).

## Usage

### HistoryStateNotifier
This abstract class works just like ``StateNotifier``, with a few added bonuses:

* Each change to the ``state`` gets recorded in an internal history
* Using ``undo()`` and ``redo()`` you can navigate through this history
* If you want to update the state without adding it to the history (e.g. for loading states), use the ``temporaryState``
  setter.

### Viewmodels
#### Creating Viewmodels

A basic Viewmodel would look like this.

```dart
import 'package:kimchi/viewmodel.dart';

final exampleViewmodelProvider = ChangeNotifierProvider.autoDispose(
        (ref) => ExampleViewmodel(ref.read),
);

class ExampleViewmodel extends Viewmodel {

  ExampleViewmodel(Reader reader) : super(reader);
  
  int _counter = 0;
  
  int get counter => _counter;
  
  void increment() {
    _counter++;
    notifyListeners();
  }
  
}
```
Note the use of ``notifyListeners();`` after a change that is supposed to update the UI.

#### Using Viewmodels
Kimchi doesn't force you to use a specific flavor of Riverpod, the concepts apply to all of them.

Using [hooks_riverpod](https://pub.dev/packages/hooks_riverpod) for example, you can then obtain access to the viewmodel from the
build method of your ``HookWidget``:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Widget extends HookWidget {
  const Widget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = useProvider(exampleViewmodelProvider);
    return Scaffold(
      body: Center(child: Text(model.counter.toString())),
      floatingActionButton: FloatingActionButton(
        onPressed: model.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```


