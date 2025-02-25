class DASInterpreter {
  Map<String, dynamic> getInterpretation(String type, int score) {
    switch (type.toLowerCase()) {
      case 'depression':
        return {
          'score': score,
          'interpretation': _interpretDepression(score),
          'meanings': {
            'Normal': 'Minimal or no symptoms of depression.',
            'Mild': 'Slight depressive symptoms, but manageable.',
            'Moderate':
                'Moderate depressive symptoms that may affect daily life.',
            'Severe':
                'Severe depressive symptoms that significantly impact daily activities.',
            'Extremely Severe':
                'Extremely high level of depressive symptoms requiring professional help.'
          }[_interpretDepression(score)]
        };
      case 'anxiety':
        return {
          'score': score,
          'interpretation': _interpretAnxiety(score),
          'meanings': {
            'Normal': 'Minimal or no symptoms of anxiety.',
            'Mild': 'Mild symptoms of anxiety, generally manageable.',
            'Moderate':
                'Moderate symptoms that may interfere with some activities.',
            'Severe':
                'Severe anxiety symptoms that significantly impact daily life.',
            'Extremely Severe':
                'Extreme anxiety symptoms that require professional intervention.'
          }[_interpretAnxiety(score)]
        };
      case 'stress':
        return {
          'score': score,
          'interpretation': _interpretStress(score),
          'meanings': {
            'Normal':
                'Minimal stress with no significant impact on daily life.',
            'Mild': 'Slight stress but manageable.',
            'Moderate': 'Moderate stress levels that may affect performance.',
            'Severe':
                'Severe stress symptoms that significantly impact daily activities.',
            'Extremely Severe':
                'Extremely high stress levels that require coping strategies or professional help.'
          }[_interpretStress(score)]
        };
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
