import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AutoRefresh extends StatefulWidget {

  final Widget Function(double) widgetGenerator;

  const AutoRefresh({super.key, required this.widgetGenerator});

  @override
  State<StatefulWidget> createState() => _AutoRefreshState();

}

class _AutoRefreshState extends State<AutoRefresh>{

  Ticker? ticker;
  Duration lastTime = Duration.zero;
  double dt = 0.0;

  @override
  Widget build(BuildContext context) {
    return widget.widgetGenerator(dt);
  }

  @override
  void dispose() {
    super.dispose();
    if(ticker != null){
      ticker!.stop();
    }
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
    ticker = Ticker(tick);
    ticker!.start();
  }


}