import 'package:flutter/material.dart';

class CustomChoiceChip extends StatelessWidget {

  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final double height;

  const CustomChoiceChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width * .4,
      height: height,
      child: ChoiceChip(
        showCheckmark: false,
        label: SizedBox(
          width: double.infinity,
          height: 100,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFF6C63FF)
                  : Colors.black54,
            ),
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFF6C63FF).withOpacity(.12),
        side: BorderSide(
          color: isSelected
              ? const Color(0xFF6C63FF)
              : Colors.white,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onSelected: (_) {
          onTap();
        },
      ),
    );
  }
}