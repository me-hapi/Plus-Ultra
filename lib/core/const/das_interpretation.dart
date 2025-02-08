class DASInterpreter {
  String getInterpretation(String type, int score) {
    switch (type.toLowerCase()) {
      case 'depression':
        return _interpretDepression(score);
      case 'anxiety':
        return _interpretAnxiety(score);
      case 'stress':
        return _interpretStress(score);
      default:
        throw ArgumentError('Invalid type: $type');
    }
  }

  String _interpretDepression(int score) {
    if (score <= 2) {
      return "Normal";
    } else if (score <= 4) {
      return "Mild";
    } else if (score <= 6) {
      return "Moderate";
    } else if (score <= 9) {
      return "Severe";
    } else {
      return "Extremely Severe";
    }
  }

  String _interpretAnxiety(int score) {
    if (score <= 0) {
      return "Normal";
    } else if (score <= 1) {
      return "Mild";
    } else if (score <= 3) {
      return "Moderate";
    } else if (score <= 5) {
      return "Severe";
    } else {
      return "Extremely Severe";
    }
  }

  String _interpretStress(int score) {
    if (score <= 3) {
      return "Normal";
    } else if (score <= 5) {
      return "Mild";
    } else if (score <= 7) {
      return "Moderate";
    } else if (score <= 9) {
      return "Severe";
    } else {
      return "Extremely Severe";
    }
  }
}
