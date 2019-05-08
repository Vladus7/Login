import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/teams_model.dart';

class TeamsBloc {
  final _repository = TeamsRepository();
  final _teamsFetcher = PublishSubject<TeamsModel>();

  Observable<TeamsModel> get allTeams => _teamsFetcher.stream;

  fetchAllTeams(id) async {
    TeamsModel itemModel = await _repository.fetchAllTeams(id);
    _teamsFetcher.sink.add(itemModel);
  }

  dispose() {
    _teamsFetcher.close();
  }
}

final teamsBloc = TeamsBloc();