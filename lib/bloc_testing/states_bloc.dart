import 'package:flutter/foundation.dart';
import 'package:weather_app/bloc_testing/bloc_event_state_component.dart';
import 'package:weather_app/bloc_testing/github_api.dart';

enum States {
  noTerm,
  error,
  loading,
  populated,
  empty,
}

@immutable
class SearchState extends BlocState {
  SearchState({this.state});

  final States state;
}

class SearchNoTerm extends SearchState {
  SearchNoTerm() : super(state: States.noTerm);
}

class SearchError extends SearchState {
  SearchError() : super(state: States.error);
}

class SearchLoading extends SearchState {
  SearchLoading() : super(state: States.loading);
}

class SearchPopulated extends SearchState {
  final SearchResult result;

  SearchPopulated(this.result) : super(state: States.populated);
}

class SearchEmpty extends SearchState {
  SearchEmpty() : super(state: States.empty);
}
