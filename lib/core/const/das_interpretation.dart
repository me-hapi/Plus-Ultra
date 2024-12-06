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
    if (score <= 9) {
      return "Normal";
    } else if (score <= 12) {
      return "Mild";
    } else if (score <= 20) {
      return "Moderate";
    } else if (score <= 27) {
      return "Severe";
    } else {
      return "Extremely Severe";
    }
  }

  String _interpretAnxiety(int score) {
    if (score <= 6) {
      return "Normal";
    } else if (score <= 9) {
      return "Mild";
    } else if (score <= 14) {
      return "Moderate";
    } else if (score <= 19) {
      return "Severe";
    } else {
      return "Extremely Severe";
    }
  }

  String _interpretStress(int score) {
    if (score <= 10) {
      return "Normal";
    } else if (score <= 18) {
      return "Mild";
    } else if (score <= 26) {
      return "Moderate";
    } else if (score <= 34) {
      return "Severe";
    } else {
      return "Extremely Severe";
    }
  }
}
