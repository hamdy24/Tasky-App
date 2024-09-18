import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<Map<String, dynamic>> items; // List containing title, color, and onClick

  double? iconSize = 24;
  IconData? iconData = Icons.more_vert;
  CustomDropdownButton(
      {
        super.key,
        required this.items,
        this.iconSize,
        this.iconData,
      }
  );

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      position: PopupMenuPosition.under,
      constraints: const BoxConstraints.expand(width: 80,height: 105),
      shape: _CustomDropdownShape(),
      onSelected: (int index) {
        items[index]['onClick'](); // Trigger function on selection
      },
      itemBuilder: (BuildContext context) {
        return List<PopupMenuEntry<int>>.generate(
          items.length * 2 - 1,  // Multiply by 2 minus 1 for dividers between items
              (int index) {
            if (index.isOdd) {
              return const PopupMenuItem<int>(
                padding: EdgeInsets.only(left: 12,right: 12,top: 1),height: 1,
                child: Divider(height: 1,color: Color.fromRGBO(47, 47, 47, 0.3),),
              );  // Add divider between items
            } else {
              final itemIndex = index ~/ 2;
              return PopupMenuItem<int>(
                value: itemIndex,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    items[itemIndex]['title'],
                    style: TextStyle(color: items[itemIndex]['color']),
                  ),
                ),
              );
            }
          },
        );
      },
      child: Icon(Icons.more_vert,size: iconSize , color: Colors.black),
    );
  }
}

// Custom shape for dropdown menu (rectangle with an arrow and rounded edges)
class _CustomDropdownShape extends ShapeBorder {
  final double borderRadius; // The radius of the rounded corners

  _CustomDropdownShape({this.borderRadius = 12.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // const arrowSize = 10.0;
    final arrowHeight = 10.0;

    // Define the rounded rectangle with a radius on each corner
    final roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(rect.left, rect.top + arrowHeight, rect.width+10, rect.height - arrowHeight),
      Radius.circular(borderRadius),
    );

    // Create a path that includes the arrow and the rounded rectangle
    final path = Path();

    // Start drawing the rounded rectangle path
    path.addRRect(roundedRect);

    // Draw the arrow on the top right
    path.moveTo(rect.right - 22, rect.top + arrowHeight);
    path.lineTo(rect.right - 12, rect.top); // Arrow peak
    path.lineTo(rect.right - 2, rect.top + arrowHeight);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // Not implemented because it's unnecessary for the outer shape definition
    throw UnimplementedError();
  }
}
