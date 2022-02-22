import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'repo.dart';

final keyboardProvider = StateNotifierProvider<KeyboardNotifier, double>(
  (ref) => KeyboardNotifier(ref.read),
);

class KeyboardNotifier extends StateNotifier<double> {
  late final KeyboardRepo _repo = _reader(keyboardRepoProvider);
  final Reader _reader;

  KeyboardNotifier(this._reader) : super(0.0) {
    _init();
  }

  double get value => state;

  Future<void> _init() async {
    state = _repo.read() ?? 0;
  }

  void set(double height) {
    _repo.save(height);
    state = height;
  }
}
