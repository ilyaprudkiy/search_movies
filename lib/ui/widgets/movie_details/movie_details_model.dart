import 'package:dart_lesson/domain/api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final int movieId;
  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;

  MovieDetailsModel(
    this.movieId,
  );

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  MovieDetails? get movieDetails => _movieDetails;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    notifyListeners();
  }
}