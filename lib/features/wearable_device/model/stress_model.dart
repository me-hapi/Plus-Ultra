import 'dart:math';
import 'package:lingap/core/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StressModel {
  // A simple logistic regression model with 3 classes (low, moderate, high) and 6 features.
  List<List<double>> weights;
  List<double> biases;

  StressModel({required this.weights, required this.biases});

  // Softmax to convert logits into probabilities.
  List<double> softmax(List<double> logits) {
    double maxLogit = logits.reduce(max);
    List<double> expValues = logits.map((x) => exp(x - maxLogit)).toList();
    double sumExp = expValues.reduce((a, b) => a + b);
    return expValues.map((x) => x / sumExp).toList();
  }

  // Predicts the class probabilities for the given features.
  List<double> predict(List<double> features) {
    List<double> logits = [];
    for (int i = 0; i < weights.length; i++) {
      double logit = biases[i];
      for (int j = 0; j < features.length; j++) {
        logit += weights[i][j] * features[j];
      }
      logits.add(logit);
    }
    return softmax(logits);
  }

  // Performs one training step using gradient descent.
  void trainStep(List<double> features, int label, double learningRate) {
    List<double> probs = predict(features);
    List<double> target = [0.0, 0.0, 0.0];
    target[label] = 1.0;
    for (int i = 0; i < weights.length; i++) {
      double error = probs[i] - target[i];
      biases[i] -= learningRate * error;
      for (int j = 0; j < features.length; j++) {
        weights[i][j] -= learningRate * error * features[j];
      }
    }
  }
}

class StressTrainer {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Fetches the dataset from the 'stress_dataset' table.
  Future<List<Map<String, dynamic>>> fetchStressDataset() async {
    final response = await supabase.from('stress_dataset').select();

    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetches the model parameter (weights and biases) from the 'parameter' table.
  Future<Map<String, dynamic>?> fetchModelParameters() async {
    final response =
        await supabase.from('parameter').select().eq('uid', uid).single();

    return Map<String, dynamic>.from(response);
  }

  /// Trains the model if the dataset has 50 or more rows, then updates the 'parameter' table.
  Future<void> trainModelIfReady() async {
    final dataset = await fetchStressDataset();
    if (dataset.length < 50) {
      print('Not enough data to train. Dataset size: ${dataset.length}');
      return;
    }

    // Prepare features and labels.
    // Feature order: [hrWeightedAvg, hrStd, spo2WeightedAvg, spo2Std, avgSleep, avgMood]
    List<List<double>> X = [];
    List<int> y = [];
    // Map stress confirmation to numerical labels.
    Map<String, int> labelMapping = {
      'low': 0,
      'moderate': 1,
      'high': 2,
    };

    for (var row in dataset) {
      double hrWeightedAvg = row['hrWeightedAvg'] is num
          ? (row['hrWeightedAvg'] as num).toDouble()
          : double.parse(row['hrWeightedAvg'].toString());
      double hrStd = row['hrStd'] is num
          ? (row['hrStd'] as num).toDouble()
          : double.parse(row['hrStd'].toString());
      double spo2WeightedAvg = row['spo2WeightedAvg'] is num
          ? (row['spo2WeightedAvg'] as num).toDouble()
          : double.parse(row['spo2WeightedAvg'].toString());
      double spo2Std = row['spo2Std'] is num
          ? (row['spo2Std'] as num).toDouble()
          : double.parse(row['spo2Std'].toString());
      double avgSleep = row['avgSleep'] is num
          ? (row['avgSleep'] as num).toDouble()
          : double.parse(row['avgSleep'].toString());
      double avgMood = row['avgMood'] is num
          ? (row['avgMood'] as num).toDouble()
          : double.parse(row['avgMood'].toString());
      String confirmedStress = row['confirmedStress'].toString().toLowerCase();
      int label = labelMapping[confirmedStress] ?? 0;

      X.add(
          [hrWeightedAvg, hrStd, spo2WeightedAvg, spo2Std, avgSleep, avgMood]);
      y.add(label);
    }

    // Initialize or fetch model parameter.
    int numClasses = 3;
    int numFeatures = 6;
    List<List<double>> weights;
    List<double> biases;
    Map<String, dynamic>? params = await fetchModelParameters();

    if (params != null) {
      // Assuming the parameter are stored as JSON arrays.
      weights = (params['weights'] as List)
          .map<List<double>>((row) => List<double>.from(row))
          .toList();
      biases = List<double>.from(params['biases'] as List);
      print('Fetched existing model parameter.');
    } else {
      // Random initialization if no parameter exist.
      Random rand = Random();
      weights = List.generate(
        numClasses,
        (_) => List.generate(numFeatures, (_) => rand.nextDouble() * 0.01),
      );
      biases = List.generate(numClasses, (_) => 0.0);
      print('No existing parameter found, initializing randomly.');
    }

    StressModel model = StressModel(weights: weights, biases: biases);

    // Set training parameter.
    int epochs = 100;
    double learningRate = 0.01;

    // Train the model over multiple epochs.
    for (int epoch = 0; epoch < epochs; epoch++) {
      for (int i = 0; i < X.length; i++) {
        model.trainStep(X[i], y[i], learningRate);
      }
    }

    // Prepare the parameter to be upserted into the 'parameter' table.
    final newParams = {
      'uid':
          uid, // Assuming you are updating/inserting a single record with id 1.
      'weights': model.weights,
      'biases': model.biases,
    };

    final updateResponse = await supabase.from('parameter').upsert(newParams);
    if (updateResponse.error != null) {
      print('Error updating parameter: ${updateResponse.error!.message}');
    } else {
      print('Model parameter updated successfully.');
    }
  }
}
