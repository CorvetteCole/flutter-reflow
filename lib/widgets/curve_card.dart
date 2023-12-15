import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/reflow_curve.dart';


class CurveCard extends StatelessWidget {
  final ReflowCurve curve;
  final void Function()? onTap;

  const CurveCard(this.curve, {Key? key, this.onTap}) : super(key: key);

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
        child: InkWell(
          onTap: onTap,
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
                    children: [
                      Text(
                        curve.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 22),
                      ),
                      Text(curve.description!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${curve.maxTemperature}°C',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                      Text('${curve.duration.inSeconds} seconds',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
