import 'package:flutter/material.dart';

class PageUpdated extends Notification {
  final int pageNumber;

  PageUpdated({required this.pageNumber});
}
