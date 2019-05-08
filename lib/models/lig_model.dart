class leaguesModel {
  List<_LeaguesResult> _results = [];

  leaguesModel.fromJson(Map<String, dynamic> parsedJson, sport, key) {
    print(parsedJson[key].length);
    List<_LeaguesResult> temp = [];
    for (int i = 0; i < parsedJson[key].length; i++) {
      if (((sport != null) & (sport == parsedJson[key][i]["strSport"])) | (sport == null)) {
      _LeaguesResult result = _LeaguesResult(parsedJson[key][i]);
      temp.add(result);}
    }
    _results = temp;
  }

  List<_LeaguesResult> get results => _results;
}

class _LeaguesResult {
  String _leaguesName;
  String _sport;
  String _id;


  _LeaguesResult(result) {
    _leaguesName = result["strLeague"];
    _sport = result["strSport"];
    _id = result["idLeague"];
  }

  String get id => _id;

  String get subtitle => _sport;

  String get title => _leaguesName;
}