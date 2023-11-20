import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/reflow_profile.dart';
import 'package:flutter_reflow/widgets/curve_card.dart';

final leadedProfile = ReflowProfile.fromJson(jsonDecode(
    r'{"name": "Leaded", "model":"SMD4300AX10", "manufacturer":"Chip Quik©", "points":[[0,25],[30,100],[120,150],[150,183],[210,235],[240,183]]}'));

final unleadedProfile = ReflowProfile.fromJson(jsonDecode(
    r'{"name": "Unleaded","model":"TS391LT","manufacturer":"Chip Quik©","points":[[0,25],[90,90],[180,130],[210,138],[240,165],[270,138]]}'));

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
              children: [CurveCard(unleadedProfile), CurveCard(leadedProfile)],
            )));
  }
}
