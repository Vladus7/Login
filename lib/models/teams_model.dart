class TeamsModel {
  List<_TeamsResult> _results = [];

  TeamsModel.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['teams'].length);
    List<_TeamsResult> temp = [];
    for (int i = 0; i < parsedJson['teams'].length; i++) {
      _TeamsResult result = _TeamsResult(parsedJson['teams'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<_TeamsResult> get results => _results;
}

class _TeamsResult {
  String _title;
  String _descriptionEN;
  String _picture;
  String _Youtube;
  String _Instagram;
  String _Facebook;
  String _Website;


  _TeamsResult(result) {
    _title = result["strTeam"];
    _descriptionEN = result["strDescriptionEN"];
    _Youtube = result["strYoutube"];
    _Instagram = result["strInstagram"];
    _Facebook = result["strFacebook"];
    _Website = result["strWebsite"];
    _picture = result["strTeamBadge"];
  }

  String get title => _title;
  String get descriptionEN =>_descriptionEN;
  String get picture => _picture;
  String get Youtube =>_Youtube;
  String get Instagram =>_Instagram;
  String get Facebook =>_Facebook;
  String get Website =>_Website;
}