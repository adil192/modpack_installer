class ValueErrorPair<T> {
  const ValueErrorPair.value(T this.value) : error = null;
  const ValueErrorPair.error(this.error) : value = null;

  final T? value;
  final dynamic error;

  bool get hasError => error != null;
  bool get hasValue => error == null;
}
