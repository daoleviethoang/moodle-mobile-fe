import 'package:flutter_html/flutter_html.dart';

CustomRenderMatcher imgMatcher() =>
    (context) => context.tree.element?.localName == 'img';
