import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/reflow_curve.dart';
import 'package:flutter_reflow/services/api_service.dart';
import 'package:logging/logging.dart';

final log = Logger('curve_provider');

class CurveProvider with ChangeNotifier {
  final ApiService _apiService;
  List<ReflowCurve> _curves = [];
  bool _isLoading = true;

  CurveProvider(this._apiService);

  List<ReflowCurve> get curves => _curves;

  bool get isLoading => _isLoading;

  Future<void> fetchCurves() async {
    _isLoading = true;
    notifyListeners();
    try {
      _curves = await _apiService.getCurves();
    } catch (e) {
      // If fetching curves fails, we can log the error and retry.
      // For now, we'll just print the error to the console.
      log.warning('Error fetching curves: $e');
      // Optionally, you could schedule a retry using a Future.delayed
      // Future.delayed(Duration(seconds: 5), () => fetchCurves());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
