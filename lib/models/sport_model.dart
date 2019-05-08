class ItemModel {
  List<_Result> _results = [];

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['sports'].length);
    List<_Result> temp = [];
    for (int i = 0; i < parsedJson['sports'].length; i++) {
      _Result result = _Result(parsedJson['sports'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<_Result> get results => _results;
}

class _Result {
  String _title;
  String _subtitle;
  String _picture;


  _Result(result) {
    _title = result["strSport"];
    _subtitle = result["strSportDescription"];
    _picture = result["strSportThumb"];
  }

  String get picture => _picture;

  String get subtitle => _subtitle;

  String get title => _title;
}