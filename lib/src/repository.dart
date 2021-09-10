import 'package:riverpod/riverpod.dart';

abstract class Repository {
  Repository(this.reader);

  /// A reference to a Riverpod [Reader] which can be user for reading
  /// dependencies like datasources or other Repositories.
  final Reader reader;

}