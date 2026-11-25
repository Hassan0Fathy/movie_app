import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/bookingDetails_page.dart';
import 'package:movie_app/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatelessWidget {
  final MovieData movie;
  const BookingPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: Text(movie.name, style: const TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      movie.poster,
                      width: 100,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            width: 100,
                            height: 140,
                            child: Icon(Icons.movie),
                          ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, size: 18),
                              const SizedBox(width: 6),
                              Text(movie.showDate),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.timelapse_outlined, size: 18),
                              const SizedBox(width: 6),
                              Text(movie.showTime),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Select a Seat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Consumer<BookingProvider>(
                  builder: (context, value, child) {
                    final currentMovie =
                        value.model?.movies
                            .where((m) => m.id == movie.id)
                            .firstOrNull ??
                        movie;

                    final seats = currentMovie.seat;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: seats.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.2,
                          ),
                      itemBuilder: (context, index) {
                        final seatItem = seats[index];
                        final isBooked =
                            seatItem.status.toLowerCase() == 'booked';

                        return InkWell(
                          onTap: () {
                            if (isBooked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    seatItem.customerName != null
                                        ? 'Seat ${seatItem.seatNumber} is booked by ${seatItem.customerName}'
                                        : 'Seat ${seatItem.seatNumber} is already booked',
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateNamePage(
                                  movieId: movie.id,
                                  seat: seatItem,
                                  currentName: seatItem.customerName ?? '',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isBooked ? Colors.red : Colors.green,
                              border: Border.all(
                                color: isBooked ? Colors.red : Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  seatItem.seatNumber,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  seatItem.status,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
