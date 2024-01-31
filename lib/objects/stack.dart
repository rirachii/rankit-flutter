class Stack<T> {
  final List<T> _items = [];

  void push(T item) {
    _items.add(item);
  }

  T pop() {
    final item = _items.last;
    _items.removeLast();
    return item;
  }

  T get top {
    return _items.last;
  }

  bool get isEmpty {
    return _items.isEmpty;
  }
}