import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/heat_curve.dart';

class CurveCard extends StatelessWidget {
  // final HeatCurve2 curve;

  const CurveCard({Key? key /*, required this.curve*/
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          // width: 300,
          height: 84,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Unleaded',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
                    ),
                    Text('Chip Quik© TS391LT',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('165°C',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14)),
                    Text('270 seconds',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
