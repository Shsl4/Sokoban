import 'package:flutter/material.dart';

class OverlayMenu extends StatelessWidget {

  final String title;
  final String leftButtonText;
  final Function()? leftButtonAction;
  final String rightButtonText;
  final Function()? rightButtonAction;

  const OverlayMenu({super.key, required this.title, required this.leftButtonText, this.leftButtonAction, required this.rightButtonText, this.rightButtonAction});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color.fromARGB(200, 0, 0, 0)),
        Center(
          child: Stack(
            children: [
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(title,
                        style: const TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.none
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
      children: [
        const Spacer(),
        ElevatedButton(
          onPressed: leftButtonAction,
          style: ButtonStyle(
            minimumSize: const MaterialStatePropertyAll<Size>(Size(125, 40)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Text(leftButtonText),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: rightButtonAction,
          style: ButtonStyle(
            minimumSize: const MaterialStatePropertyAll<Size>(Size(125, 40)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Text(rightButtonText),
        ),
        const Spacer()
      ],
    );
  }
}
