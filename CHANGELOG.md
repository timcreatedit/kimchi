## 0.1.0
* Dependency Upgrades
###BREAKING:
* Removed ``HistoryStateNotifier`` check out the ``history_state_notifier`` package
## 0.0.9
* Better documentation for ``HistoryStateNotifier``
* Added the possibility to transform states from the history before they get applied

## 0.0.8
* Added maxHistoryLength parameter to ``HistoryStateNotifier``

## 0.0.7

* Added a few helper methods to ``HistoryStateNotifier``
* You can now specify whether you want ``HistoryStateNotifier`` to add the initial state to the history
by using a parameter in its constructor.

## 0.0.6

* Fixed: Stupid bug with undo history

## 0.0.5

* ``HistoryStateNotifier`` is now abstract
* Fixed: ``Viewmodel.init()`` is no longer abstract

## 0.0.4

* New ``HistoryStateNotifier`` is like a normal StateNotifier but supports undo and redo functionality

## 0.0.3

* ``init()`` is now protected and optional

## 0.0.2

* Added ``init()`` method to Viewmodel
* Added Repository base class
* Added Datasource base class (empty for now)
* Improved documentation

## 0.0.1

* Added Viewmodel Base Class