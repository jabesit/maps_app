class Result<S, E extends Exception> {
  const Result();
}

final class Success<S, E extends Exception> extends Result<S, E> {
  const Success({required this.value});
  final S value;
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  const Failure({required this.exception});
  final E exception;
}
