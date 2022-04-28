import 'package:flutter/material.dart';

class ChipTile extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback? onDelete;
  const ChipTile(
      {Key? key,
      required this.label,
      required this.backgroundColor,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.all(2.0),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: backgroundColor,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(8.0),
      useDeleteButtonTooltip: true,
      deleteIcon: const Icon(Icons.cancel),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onDeleted: onDelete,
      deleteIconColor: Colors.white,
    );
  }
}
