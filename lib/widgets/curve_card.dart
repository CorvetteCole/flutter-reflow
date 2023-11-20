import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/heat_curve.dart';
import 'package:flutter_reflow/models/reflow_profile.dart';

class CurveCard extends StatelessWidget {
  final ReflowProfile profile;
  final void Function()? onTap;

  const CurveCard(this.profile, {Key? key, this.onTap}) : super(key: key);

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
                        profile.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 22),
                      ),
                      Text('${profile.manufacturer} ${profile.model}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${profile.highestTemperature}°C',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                      Text('${profile.duration.inSeconds} seconds',
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
