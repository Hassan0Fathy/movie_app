import 'package:flutter/foundation.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  MovieModel? model;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      model = await MovieService.fetchData();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
