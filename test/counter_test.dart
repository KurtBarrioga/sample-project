import 'package:test/test.dart';
import 'package:sampleproject/counter.dart';

void main() {
  test('Counter value should be incremented', () {
    final counter = Counter();

    counter.increment();

    expect(counter.value, 1);
  });

    test('Counter value should be decremented', () {
    final counter = Counter();

    counter.decrement();

    expect(counter.value, -1);
  });
}