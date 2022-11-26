import 'package:asmr_maker/util/util.dart';
import 'package:test/test.dart';

@Timeout(Duration(seconds: 5))
void main() {
  test("Getting the right value.", () {
    List<double> list = [0, 1, 2, 3, 4, 5];
    expect(3, getCeilInList(3, list));
    expect(0, getCeilInList(0, list));
    expect(0, getCeilInList(-1, list));
    expect(5, getCeilInList(5, list));
    expect(3, getCeilInList(2.9, list));
    expect(2, getCeilInList(1.1, list));
  });
}
