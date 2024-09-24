import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_onboard/features/app/widgets/app.widget.dart';

void main() {
  usePathUrlStrategy();
  runApp(const AppWidget());
}
