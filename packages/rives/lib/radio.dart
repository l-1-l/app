import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

///
class RRadio extends StatefulWidget {
  ///
  const RRadio({
    Key? key,
    this.onChange,
  }) : super(key: key);

  ///
  final void Function(bool)? onChange;

  @override
  State<RRadio> createState() => _RRadioState();
}

class _RRadioState extends State<RRadio> {
  SMITrigger? bump;

  void handleInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'radio');
    artboard.addController(controller!);
    bump = controller.findInput<bool>('bump') as SMITrigger;
  }

  void hitBump() => bump?.fire();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hitBump,
      child: SizedBox(
        width: 14,
        height: 14,
        child: RiveAnimation.asset(
          'assets/radio.riv',
          fit: BoxFit.cover,
          onInit: handleInit,
        ),
      ),
    );
  }
}
