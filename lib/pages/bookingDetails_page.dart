import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/providers/booking_provider.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class UpdateNamePage extends StatelessWidget {
  final int movieId;
  final Seats seat;
  final String currentName;

  const UpdateNamePage({
    super.key,
    required this.movieId,
    required this.seat,
    required this.currentName,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: currentName);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: Text(
            'Book Seat ${seat.seatNumber}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seat ID: ${seat.seatId} | Status: ${seat.status}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<BookingProvider>(
                  builder: (context, bookingProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final customerName = nameController.text.trim();
                          bookingProvider.addBooking(
                            movieId: movieId,
                            seat: seat,
                            customerName: customerName,
                          );

                          if (!context.mounted) return;

                          seat.status = 'Booked';
                          seat.customerName = customerName;

                          context.read<MovieProvider>().getData();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Seat ${seat.seatNumber} booked for $customerName',
                              ),
                            ),
                          );
                          Navigator.pop(context, true);
                        },
                        child: const Text('Save & Book'),
                      ),
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
