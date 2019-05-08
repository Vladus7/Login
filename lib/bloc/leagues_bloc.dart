import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/lig_model.dart';

class LeaguesBloc {
  final _repository = LeaguesRepository();
  final _leaguesFetcher = PublishSubject<leaguesModel>();

  Observable<leaguesModel> get allLeagues => _leaguesFetcher.stream;

  fetchAllLeagues(sport, country) async {
    leaguesModel itemModel = await _repository.fetchAllLeagues(sport, country);
    _leaguesFetcher.sink.add(itemModel);
  }

  dispose() {
    _leaguesFetcher.close();
  }
}

final leaguesBloc = LeaguesBloc();