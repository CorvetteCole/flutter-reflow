import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_reflow/models/reflow_curve.dart';
import 'package:flutter_reflow/models/control_status.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<String> saveCurve(ReflowCurve curve) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save_curve/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(curve.toJson()),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to save curve');
    }
  }

  Future<void> deleteCurve(String curveId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/delete_curve/$curveId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete curve');
    }
  }

  Future<List<ReflowCurve>> getCurves() async {
    final response = await http.get(Uri.parse('$baseUrl/curves'));
    if (response.statusCode == 200) {
      final curves = jsonDecode(response.body) as List;
      return curves.map((e) => ReflowCurve.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get curves');
    }
  }

  Future<void> startCurve(ReflowCurve curve) async {
    final response = await http.post(
      Uri.parse('$baseUrl/start_curve'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(curve.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to start curve');
    }
  }

  Future<ControlStatus> getCurveStatus() async {
    final response = await http.get(Uri.parse('$baseUrl/curve_status'));
    if (response.statusCode == 200) {
      return ControlStatus.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get curve status');
    }
  }

  Future<void> stopCurve() async {
    final response = await http.post(Uri.parse('$baseUrl/stop_curve'));
    if (response.statusCode != 200) {
      throw Exception('Failed to stop curve');
    }
  }

  Future<void> reset() async {
    final response = await http.post(Uri.parse('$baseUrl/reset'));
    if (response.statusCode != 200) {
      throw Exception('Failed to reset');
    }
  }
}
