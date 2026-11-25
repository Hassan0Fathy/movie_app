import 'package:dio/dio.dart';
import 'package:movie_app/models/movie_model.dart';

class MovieService {
  static Dio dio = Dio();

  static Future<MovieModel> fetchData() async {
    try {
      final response = await dio.get('https://apimovie.runasp.net/api/Movies');
      return MovieModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Dio error ${e.message}');
    } catch (e) {
      throw Exception('error feild ${e.toString()}');
    }
  }
}
