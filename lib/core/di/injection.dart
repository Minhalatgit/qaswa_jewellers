import 'package:get_it/get_it.dart';

import 'auth_injection.dart';
import 'core_injection.dart';

final sl = GetIt.instance;

Future<void> setupDI() async {
  _setupCore();
  _setupAuth();
}

void _setupCore() => setupCoreDependencies(sl);
void _setupAuth() => setupAuthDependencies(sl);
