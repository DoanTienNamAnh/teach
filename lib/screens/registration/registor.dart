import 'package:flutter/material.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Stepper Sample')),
        body: const Center(
          child: StepperExample(),
        ),
      ),
    );
  }
}

class StepperExample extends StatefulWidget {
  const StepperExample({super.key});

  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      // onStepCancel: () {
      //   if (_index > 0) {
      //     setState(() {
      //       _index -= 1;
      //     });
      //   }
      // },
      // onStepContinue: () {
      //   if (_index <= 0) {
      //     setState(() {
      //       _index += 1;
      //     });
      //   }
      // },
      controlsBuilder: (context, detail) => const SizedBox(),
      stepIconBuilder: (index, detail) => const SizedBox(),
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      type: StepperType.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      steps: <Step>[
        Step(
          title: const Text('Step 1 title'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: const SizedBox(),
          ),
        ),
        Step(
          title: Text('Step 2 title'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: const SizedBox(),
          ),
          stepStyle: StepStyle()
        ),
        Step(
          title: Text('Step 3 title'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: const SizedBox(),
          ),
          stepStyle: StepStyle()
        ),
        Step(
          title: Text('Step 4 title'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: const SizedBox(),
          ),
        ),
      ],
    );
  }
}
