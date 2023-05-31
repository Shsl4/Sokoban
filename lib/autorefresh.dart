
import 'dart:async';

import 'package:flutter/material.dart';

class AutoRefresh extends StatefulWidget {

  final int refreshRate;
  final Widget Function() widgetGenerator;

  const AutoRefresh({super.key, required this.refreshRate, required this.widgetGenerator});

  @override
  State<StatefulWidget> createState() => _AutoRefreshState();

}

class _AutoRefreshState extends State<AutoRefresh>{

  @override
  Widget build(BuildContext context) {
    return widget.widgetGenerator();
  }

  @override
  void initState() {
    super.initState();
    var duration = Duration(milliseconds: 1000 ~/ widget.refreshRate);
    Timer.periodic(duration, (timer) {
      setState(() {});
    });

  }


}