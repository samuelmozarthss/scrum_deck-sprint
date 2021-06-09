import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cad_sprint/app/screens/sprint/shared/models/sprint.dart';
import 'package:cad_sprint/app/screens/sprint/sprint_api.dart';
import 'package:rxdart/rxdart.dart';

class SprintBloc extends BlocBase {

  final SprintApi _api;
  SprintBloc(this._api);

  late final _sprintFetcher = PublishSubject<List<Sprint>>();
  late final _loading = BehaviorSubject<bool>();
  late final _sprintAdded = PublishSubject<String>();

  Stream<List<Sprint>> get sprints => _sprintFetcher.stream;
  Stream<bool> get loading => _loading.stream;
  Stream<String> get addResult => _sprintAdded.stream;

  doFetch() async {
    _loading.sink.add(true);

    final sprints = await _api.fetchSprints();
    sprints.shuffle();

    _sprintFetcher.sink.add(sprints);

    _loading.sink.add(false);
  }

  doPost(sprint) async {
    _loading.sink.add(true);
    // print(sprint);
    final addResult = await _api.postSprint(sprint);
    _sprintAdded.sink.add(addResult);

    await doFetch();
    print(sprint);
  }

  doUpdate(sprint) async {

  }

  doDelete(sprint) async {

  }

  @override
  void dispose() {
    _sprintFetcher.close();
    _sprintAdded.close();
    _loading.close();
    super.dispose();
  }

}