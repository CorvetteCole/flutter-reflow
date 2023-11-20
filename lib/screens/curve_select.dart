import 'package:flutter/material.dart';
import 'package:flutter_reflow/widgets/curve_card.dart';

class CurveSelectPage extends StatelessWidget {
  const CurveSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                CurveCard(),
                CurveCard(),
              ],
            )));
  }
}
