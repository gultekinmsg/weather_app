import 'package:rxdart/rxdart.dart';
import 'package:weather_app/bloc_testing/github_contract.dart';
import 'package:weather_app/bloc_testing/states_bloc.dart';

class SearchBloc {
  factory SearchBloc(GithubSearchContract api) {
    final onTextChanged = PublishSubject<String>();

    final state = onTextChanged
        .distinct()
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap<SearchState>((String term) => _helpers.eventTyping(term))
        .startWith(SearchNoTerm());

    return SearchBloc._(api, onTextChanged, state);
  }

  /// Sink exposed to UI
  final Sink<String> onTextChanged;

  /// State exposed to UI
  final Stream<SearchState> state;

  SearchBloc._(this.api, this.onTextChanged, this.state)
      : assert(api != null),
        super() {
    _helpers = _Internals(api);
  }

  final GithubSearchContract api;

  void dispose() {
    onTextChanged?.close();
  }

  static _Internals _helpers;
}

class _Internals {
  _Internals(this.api);

  final GithubSearchContract api;

  Stream<SearchState> eventTyping(String term) async* {
    // print('Searching for >>> $term');

    if (term.isEmpty) {
      yield SearchEmpty();
    } else {
      yield* Rx.fromCallable(() => api.search(term))
          .map((result) =>
              result.isEmpty ? SearchEmpty() : SearchPopulated(result))
          .startWith(SearchLoading())
          .onErrorReturn(SearchError());
    }
  }
}
