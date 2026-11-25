import 'package:flutter/foundation.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  MovieModel? model;

  Future<void> addBooking({
    required int movieId,
    required Seats seat,
    required String customerName,
  }) async {
    model = await BookingService.addBooking(
      movieId: movieId,
      seatId: seat.seatId,
      customerName: customerName,
    );
    seat.status = 'Booked';
    seat.customerName = customerName;
    notifyListeners();
  }
}
