import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/sport_model.dart';

class SportBloc {
  final _repository = SportRepository();
  final _sportFetcher = PublishSubject<ItemModel>();

  Observable<ItemModel> get allSport => _sportFetcher.stream;

  fetchAllSport() async {
    ItemModel itemModel = await _repository.fetchAllSport();
    _sportFetcher.sink.add(itemModel);
  }

  dispose() {
    _sportFetcher.close();
  }
}

final sportBloc = SportBloc();