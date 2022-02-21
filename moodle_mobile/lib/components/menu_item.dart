import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Create a menu with icon on the left, and text on the right
///
/// Arguments:
///   - icon: The icon that shows on the left
///   - color: Color of the icon above and its background
///   - title: The title shows on the right
///   - subtitle: The optional subtitle that shows below the title above
///               (title will be centered with the icon if subtitle is empty)
///   - onPressed: The function called when the user presses this menu
///
/// See also:
///   https://www.figma.com/file/PQEG0jYNYm9ob534tAOZiI/MOODLE-MOBILE-HCMUS?node-id=0%3A1
///   Link to Figma containing a prototype of this widget
class MenuItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;

  const MenuItem({
    Key? key,
    this.icon = CupertinoIcons.doc,
    this.color = Colors.blue,
    required this.title,
    this.subtitle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          primary: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: onPressed,

        // Icon enclosed in a circle on the left
        icon: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: CircleAvatar(
            backgroundColor: color.withOpacity(.25),
            child: Text(String.fromCharCode(icon.codePoint),
              style: TextStyle(
                inherit: false,
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: icon.fontFamily,
                package: icon.fontPackage,
              ),
            ),
          ),
        ),

        // 1-2 rows of text on the right
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                height: 1,
              ),
            ),

            // Optional subtitle
            Builder(builder: (context) {
              if (subtitle != null) {
                if (subtitle!.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Opacity(
                      opacity: .25,
                      child: Text(
                        subtitle!,
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          height: 1,
                        ),
                      ),
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}