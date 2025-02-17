class Utils {
  Map<String, String> parseResponse(String fullResponse) {
    RegExp responseRegExp = RegExp(r'\*\*Response:\*\*\s*(.*)');
    RegExp titleRegExp = RegExp(r'Title\s*:\*\*?\s*([\w\s]+)');
    RegExp iconRegExp = RegExp(r'Icon\s*:\*\*?\s*([\S]+)');
    RegExp emotionRegExp = RegExp(r'Emotion\s*:\*\*?\s*([\w\s]+)');
    RegExp issueRegExp = RegExp(r'Issue\s*:\*\*?\s*([\w\s]+)');

    String responseText = _extractMatch(responseRegExp, fullResponse);
    String title = _extractMatch(titleRegExp, fullResponse);
    String icon = _extractMatch(iconRegExp, fullResponse);
    String emotion = _extractMatch(emotionRegExp, fullResponse);
    String issue = _extractMatch(issueRegExp, fullResponse);

    return {
      'response': responseText,
      'title': title,
      'icon': icon,
      'emotion': emotion,
      'issue': issue,
    };
  }

  String _extractMatch(RegExp regex, String text) {
    Match? match = regex.firstMatch(text);
    return match != null ? match.group(1)?.trim() ?? "" : "";
  }
}
