import 'package:flutter/material.dart';

class DropListModel {
  DropListModel(this.listOptionItems);

  final List<OptionItem> listOptionItems;

  static DropListModel dropListModel = DropListModel([
    OptionItem(id: "1", title: "All (except removed from view)"),
    OptionItem(id: "2", title: "In progress"),
    OptionItem(id: "3", title: "Future"),
    OptionItem(id: "4", title: "Past"),
    OptionItem(id: "5", title: "Starred"),
    OptionItem(id: "6", title: "Removed from view"),
  ]);
}

class OptionItem {
  final String id;
  final String title;

  OptionItem({required this.id, required this.title});

  static OptionItem optionItemSelected = OptionItem(id: '1', title: "Status");
}
