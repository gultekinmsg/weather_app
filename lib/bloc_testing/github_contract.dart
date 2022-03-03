import 'package:weather_app/bloc_testing/github_api.dart';

abstract class GithubSearchContract {
  Future<SearchResult> search(String term);
}
