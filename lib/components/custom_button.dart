import 'package:flutter/material.dart';

enum CustomButtonType { primary, secondary, icon, image, coloredIcon }

class CustomButton extends StatelessWidget {
  final CustomButtonType type;
  final String title;
  final VoidCallback onPressed;
  final IconData? iconData; // For icon button
  final ImageProvider? image; // For image button
  final Color? color;
  final Color? overlayColor;

  const CustomButton({
    super.key,
    required this.type,
    required this.title,
    required this.onPressed,
    this.iconData,
    this.image,
    this.color,
    this.overlayColor,
  }) : assert(
            (type == CustomButtonType.icon && iconData != null) ||
                (type == CustomButtonType.coloredIcon && iconData != null) ||
                (type == CustomButtonType.image && image != null) ||
                (type == CustomButtonType.primary ||
                    type == CustomButtonType.secondary),
            'Icon must be provided for icon button, Image must be provided for image button');

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CustomButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            foregroundColor: Colors.white,
            backgroundColor: color ?? Theme.of(context).primaryColor,
            overlayColor: overlayColor ?? Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          child: Text(title),
        );
      case CustomButtonType.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
            side: BorderSide(color: Theme.of(context).primaryColor),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          child: Text(title),
        );
      case CustomButtonType.icon:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            size: 20,
          ),
          label: Text(
            title,
          ),
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            elevation: WidgetStateProperty.all(0),
            backgroundColor:
                WidgetStateProperty.all(Colors.white), // Always white bg
            overlayColor: WidgetStateProperty.all(
                Colors.white), // Always white bg when pressed
            foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.pressed)) {
                // pressed state color, faded or grey
                return Colors.grey.withValues(alpha: 0.6);
              }
              // default color
              return color ?? Theme.of(context).primaryColor;
            }),
            iconColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.pressed)) {
                // pressed state color, faded or grey
                return Colors.grey.withValues(alpha: 0.6);
              }
              // default color
              return color ?? Theme.of(context).primaryColor;
            }),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        );
      case CustomButtonType.coloredIcon:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            size: 20,
          ),
          label: Text(
            title,
          ),
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(
                color ?? Theme.of(context).primaryColor), // Always white bg
            overlayColor: WidgetStateProperty.all(overlayColor ??
                Colors
                    .deepPurpleAccent.shade100), // Always white bg when pressed
            foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              // if (states.contains(WidgetState.pressed)) {
              //   // pressed state color, faded or grey
              //   return Colors.grey.withValues(alpha: 0.2);
              // }
              // default color
              return Colors.white;
            }),
            iconColor: WidgetStateProperty.resolveWith<Color>((states) {
              // if (states.contains(WidgetState.pressed)) {
              //   // pressed state color, faded or grey
              //   return Colors.grey.withValues(alpha: 0.6);
              // }
              // default color
              return Colors.white;
            }),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        );
      case CustomButtonType.image:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (image != null)
                Image(
                  image: image!,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
    }
  }
}
