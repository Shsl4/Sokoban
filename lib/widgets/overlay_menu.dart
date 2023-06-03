import 'package:flutter/material.dart';
import 'package:sokoban/widgets/sokoban_button.dart';

class OverlayMenu extends StatelessWidget {

  final String title;
  final String leftButtonText;
  final Function()? leftButtonAction;
  final String? rightButtonText;
  final Function()? rightButtonAction;

  const OverlayMenu({super.key, required this.title, required this.leftButtonText, this.leftButtonAction, this.rightButtonText, this.rightButtonAction});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.transparent),
        Center(
          child: Stack(
            children: [
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    color: Colors.black54,
                    borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(title,
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.none,
                            fontSize: 35
                        )),
                    const Spacer(),
                    buttonRow(),
                    const Spacer()
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buttonRow() {
    return Row(
      children: buttons()
    );
  }

  List<Widget> buttons() {

    List<Widget> widgets = [];

    widgets.add(const Spacer());

    widgets.add(SokobanButton(
        size: const Size(125, 40),
        onPressed: leftButtonAction,
        child: Text(leftButtonText)
    ));

    widgets.add(const Spacer());

    if(rightButtonText != null){

      widgets.add(SokobanButton(
          size: const Size(125, 40),
          onPressed: rightButtonAction,
          child: Text(rightButtonText!)
      ));

      widgets.add(const Spacer());

    }

    return widgets;

  }

}
