import 'package:dart_lesson/domain/api_client/api_client.dart';
import 'package:dart_lesson/domain/data_providers/session_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();

  final int movieId;
  MovieDetails? _movieDetails;
  bool _isFavorite = true;
  String _locale = '';
  late DateFormat _dateFormat;

  Future<void>? Function()? onSessionExpired;

  MovieDetailsModel(
    this.movieId,
  );

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  MovieDetails? get movieDetails => _movieDetails;

  bool get isFavorites => _isFavorite;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    try {
      _movieDetails = await _apiClient.movieDetails(movieId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _apiClient.isFavorite(movieId, sessionId);
      }
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  Future<void> toggleFavorite() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    _isFavorite = !_isFavorite;
    notifyListeners();
    try {
      await _apiClient.markAsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.Movie,
        mediaId: movieId,
        isFavorite: _isFavorite,
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }
  void _handleApiClientException(ApiClientException exception) async {
    switch (exception.type) {
    case ApiClientExceptionType.SessionExpired:
    await onSessionExpired?.call();
    break;
    default:
    print(exception);
    }
  }
}
