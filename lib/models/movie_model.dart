class MovieModel {
  bool status;
  String message;
  List<MovieData> movies;
  MovieModel({
    required this.message,
    required this.movies,
    required this.status,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      message: json['message'],
      movies: json['data']
          .map(
            (e) => MovieData(
              id: e['id'],
              name: e['name'],
              poster: e['poster'],
              seat: e['seats']
                  .map(
                    (item) => Seats(
                      customerName: item['customerName'],
                      seatId: item['seatId'],
                      status: item['status'],
                      seatNumber: item['seatNumber'],
                      bookingId: item['bookingId'],
                    ),
                  )
                  .toList()
                  .cast<Seats>(),
              showDate: e['showDate'],
              showTime: e['showTime'],
            ),
          )
          .toList()
          .cast<MovieData>(),
      status: json['status'],
    );
  }
}

class MovieData {
  int id;
  String name;
  String poster;
  String showDate;
  String showTime;
  List<Seats> seat;
  MovieData({
    required this.id,
    required this.name,
    required this.poster,
    required this.seat,
    required this.showDate,
    required this.showTime,
  });
}

class Seats {
  int seatId;
  int? bookingId;
  String seatNumber;
  String status;
  String? customerName;
  Seats({
    this.bookingId,
    this.customerName,
    required this.seatId,
    required this.status,
    required this.seatNumber,
  });
}
