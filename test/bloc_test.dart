import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// import 'package:test/test.dart' show TypeMatcher;
import 'package:weather_app/bloc_testing/github_api.dart';
import 'package:weather_app/bloc_testing/search_bloc.dart';
import 'package:weather_app/bloc_testing/states_bloc.dart';

class MockGithubSearchImpl extends Mock implements GithubApi {}

const noTerm = TypeMatcher<SearchNoTerm>();
const loading = TypeMatcher<SearchLoading>();
const empty = TypeMatcher<SearchEmpty>();
const populated = TypeMatcher<SearchPopulated>();
const error = TypeMatcher<SearchError>();

void main() {
  SearchBloc searchBloc;
  MockGithubSearchImpl mockGithubSearch;

  setUp(() {
    mockGithubSearch = MockGithubSearchImpl();
    searchBloc = SearchBloc(mockGithubSearch);
  });

  tearDown(() {
    searchBloc?.dispose();
  });

  group('Search bloc', () {
    test('throws AssertionError if contract is null', () {
      expect(
        () => SearchBloc(null),
        throwsA(isAssertionError),
      );
    });

    test('initial state should be NoTerm', () async {
      await expectLater(searchBloc.state, emitsInOrder([noTerm]));
    });

    test('hardcoded empty term', () async {
      expect(searchBloc.state, emitsInOrder([noTerm, empty]));
      searchBloc.onTextChanged.add('');

      /// OR
      // scheduleMicrotask(() {
      //   searchBloc.onTextChanged.add('');
      // });

      // expect(
      //   searchBloc.state,
      //   emitsInOrder([noTerm, empty]),
      // );
    });

    test('api returns results', () async {
      const term = 'aseem';

      when(searchBloc.api.search(term)).thenAnswer((_) async {
        return SearchResult([SearchResultItem('aseem wangoo', 'xyz', 'abc')]);
      });

      expect(searchBloc.state, emitsInOrder([noTerm, loading, populated]));
      searchBloc.onTextChanged.add(term);
    });

    test('emit empty state if no results', () async {
      const term = 'aseem';

      when(searchBloc.api.search(term)).thenAnswer(
        (_) async => SearchResult([]),
      );

      expect(searchBloc.state, emitsInOrder([noTerm, loading, empty]));
      searchBloc.onTextChanged.add(term);
    });

    test('emit error state if API is down', () async {
      const term = 'aseem';

      when(searchBloc.api.search(term)).thenThrow(Exception());

      expect(searchBloc.state, emitsInOrder([noTerm, loading, error]));
      searchBloc.onTextChanged.add(term);
    });

    test('stream is closed', () async {
      when(searchBloc.dispose());

      expect(searchBloc.state, emitsInOrder([noTerm, emitsDone]));
    });
  });
}
