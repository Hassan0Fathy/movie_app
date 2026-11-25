import 'package:dio/dio.dart';
import 'package:movie_app/models/movie_model.dart';

class BookingService {
  static Dio dio = Dio();

  static Future<MovieModel> addBooking({
    required int movieId,
    required int seatId,
    required String customerName,
  }) async {
    try {
      final response = await dio.post(
        'https://apimovie.runasp.net/api/Bookings',
        data: {'seatId': seatId, 'id': movieId, 'customerName': customerName},
      );
      return MovieModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Dio error ${e.message}');
    } catch (e) {
      throw Exception('error feild ${e.toString()}');
    }
  }
}
