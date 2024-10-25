import 'package:flutter/widgets.dart' show WidgetsFlutterBinding, runApp;
import 'app/widgets/app.widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppWidget());
}
