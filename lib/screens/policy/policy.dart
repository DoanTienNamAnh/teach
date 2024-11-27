import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PolicyDialog extends StatefulWidget {
  const PolicyDialog({super.key});

  @override
  State<PolicyDialog> createState() => _PolicyDialogState();
}

class _PolicyDialogState extends State<PolicyDialog> {
  bool _isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Teams of Service"),
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.black,
                  margin: const EdgeInsets.all(16),
                ),
                const Text("Teams of Service")
              ],
            ),
            const Gap(16),
            Row(
              children: [
                Checkbox(
                    value: _isAgree,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {
                      setState(() {
                        _isAgree = value ?? false;
                      });
                    }),
                const Text("Teams of Service")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(onPressed: () {}, child: const Text("Cancel")),
                const Spacer(),
                OutlinedButton(onPressed: () {}, child: const Text("Cancel")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
