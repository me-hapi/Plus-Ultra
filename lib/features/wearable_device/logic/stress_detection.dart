import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class StressDetection {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Fetch heart rate data for the past 30 minutes.
  Future<List<double>?> fetchHeartRateData(String userId) async {
    final thirtyMinutesAgo = DateTime.now().subtract(Duration(hours: 3));
    final response = await supabase
        .from('vital')
        .select('value, date')
        .eq('uid', userId)
        .eq('type', 'HEART_RATE')
        .gte('date', thirtyMinutesAgo.toIso8601String());

    print('MODEL: $response');
    // Assuming the response is a List of maps.
    List<dynamic> data = response as List<dynamic>;
    List<double> heartRates = [];
    for (var item in data) {
      double? rate = double.tryParse(item['value'].toString());
      if (rate != null) {
        heartRates.add(rate);
      }
    }
    print('MODEL double: $heartRates');
    return heartRates;
  }

  /// Compute the standard deviation of a list.
  double computeStandardDeviation(List<double> data) {
    if (data.isEmpty) return 0.0;
    double mean = data.reduce((a, b) => a + b) / data.length;
    num sumSq = data.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b);
    return sqrt(sumSq / data.length);
  }

  /// Compute SD1 and SD2 from heart rate data.
  /// Here, SD1 is approximated as sqrt(0.5) * std(diff) and
  /// SD2 is computed from the overall variance.
  Map<String, double> computeSD1SD2(List<double> data) {
    if (data.length < 2) return {'SD1': 0.0, 'SD2': 0.0};
    List<double> diffs = [];
    for (int i = 0; i < data.length - 1; i++) {
      diffs.add(data[i + 1] - data[i]);
    }
    double sdDiff = computeStandardDeviation(diffs);
    double sd1 = sqrt(0.5) * sdDiff;
    double sdRR = computeStandardDeviation(data);
    double sd2Squared = 2 * pow(sdRR, 2) - 0.5 * pow(sdDiff, 2);
    double sd2 = sd2Squared > 0 ? sqrt(sd2Squared) : 0.0;
    return {'SD1': sd1, 'SD2': sd2};
  }

  /// Compute Sample Entropy (SampEn) for the data.
  /// m is the embedding dimension and r is the tolerance (defaulting to 0.2 * std).
  double computeSampleEntropy(List<double> data, {int m = 2, double? r}) {
    int N = data.length;
    if (N <= m + 1) return double.nan;
    r ??= 0.2 * computeStandardDeviation(data);
    int count_m = 0;
    int count_m1 = 0;
    for (int i = 0; i < N - m; i++) {
      for (int j = i + 1; j < N - m; j++) {
        bool match_m = true;
        for (int k = 0; k < m; k++) {
          if ((data[i + k] - data[j + k]).abs() > r) {
            match_m = false;
            break;
          }
        }
        if (match_m) {
          count_m++;
          bool match_m1 = true;
          for (int k = 0; k < m + 1; k++) {
            if ((data[i + k] - data[j + k]).abs() > r) {
              match_m1 = false;
              break;
            }
          }
          if (match_m1) count_m1++;
        }
      }
    }
    if (count_m == 0 || count_m1 == 0) return double.infinity;
    return -log(count_m1 / count_m);
  }

  /// Compute the Higuchi Fractal Dimension for the data.
  double computeHiguchi(List<double> data, {int kmax = 10}) {
    int N = data.length;
    if (N < 2) return double.nan;
    List<double> L = [];
    for (int k = 1; k <= kmax; k++) {
      double sumL = 0.0;
      int count = 0;
      for (int m = 0; m < k; m++) {
        double Lmk = 0.0;
        int num = ((N - m - 1) / k).floor();
        if (num <= 0) continue;
        for (int i = 1; i <= num; i++) {
          Lmk += (data[m + i * k] - data[m + (i - 1) * k]).abs();
        }
        Lmk = (Lmk * (N - 1)) / (num * k);
        sumL += Lmk;
        count++;
      }
      if (count > 0) {
        L.add(sumL / count);
      }
    }
    // Prepare data for linear regression on log(1/k) vs. log(L(k)).
    List<double> logKInv = [];
    List<double> logL = [];
    for (int i = 0; i < L.length; i++) {
      int k = i + 1;
      logKInv.add(log(1 / k));
      logL.add(log(L[i]));
    }
    int n = logKInv.length;
    double sumX = logKInv.reduce((a, b) => a + b);
    double sumY = logL.reduce((a, b) => a + b);
    double sumXY = 0.0;
    double sumXX = 0.0;
    for (int i = 0; i < n; i++) {
      sumXY += logKInv[i] * logL[i];
      sumXX += logKInv[i] * logKInv[i];
    }
    double slope = (n * sumXY - sumX * sumY) / (n * sumXX - pow(sumX, 2));
    return slope;
  }

  /// Fetch heart rate data for the past 30 minutes and compute SD1, SD2, SampEn, and Higuchi.
  Future<Map<String, double>?> fetchHeartRateMetrics(String userId) async {
    List<double>? heartRates = await fetchHeartRateData(userId);
    if (heartRates == null || heartRates.isEmpty) return null;

    Map<String, double> sdValues = computeSD1SD2(heartRates);
    double sampen = computeSampleEntropy(heartRates);
    double higuchi = computeHiguchi(heartRates);

    return {
      'SD1': sdValues['SD1']!,
      'SD2': sdValues['SD2']!,
      'SampEn': sampen,
      'Higuchi': higuchi,
    };
  }
}
