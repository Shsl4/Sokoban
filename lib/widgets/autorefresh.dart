import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AutoRefresh extends StatefulWidget {

  final int refreshRate;
  final Widget Function(double) widgetGenerator;

  const AutoRefresh({super.key, required this.refreshRate, required this.widgetGenerator});

  @override
  State<StatefulWidget> createState() => _AutoRefreshState();

}

class _AutoRefreshState extends State<AutoRefresh>{

  Duration lastTime = Duration.zero;
  double dt = 0.0;

  @override
  Widget build(BuildContext context) {
    return widget.widgetGenerator(dt);
  }

  void tick(Duration elapsed){
    setState(() {
      Duration diff = elapsed - lastTime;
      lastTime = elapsed;
      dt = diff.inMilliseconds / 1000.0;
    });

  }

  @override
  void initState() {
    super.initState();
    Ticker(tick).start();
  }


}