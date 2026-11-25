import 'package:flutter/material.dart';
import 'package:movie_app/pages/booking_page.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class MoviePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MovieProvider>();
    if (provider.model == null &&
        !provider.isLoading &&
        provider.errorMessage == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.getData();
      });
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: Text('Movies', style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<MovieProvider>(
                builder: ((context, value, child) {
                  if (value.errorMessage != null) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        value.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (value.isLoading || value.model == null) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    );
                  }

                  final movies = value.model!.movies;
                  if (movies.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No movies found'),
                    );
                  }
                  final movie = value.model?.movies ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movie.length,
                    itemBuilder: (context, index) {
                      final item = movie[index];
                      return CustomCard(
                        image: item.poster,
                        title: item.name,
                        showDate: item.showDate,
                        showTime: item.showTime,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingPage(movie: item),
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String image;
  final String title;
  final String showDate;
  final String showTime;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.image,
    required this.title,
    required this.showDate,
    required this.showTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            Image.network(
              image,
              width: 90,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                width: 90,
                height: 120,
                child: Icon(Icons.movie),
              ),
            ),
            const SizedBox(width: 12),

            Column(
              children: [
                Text(title),
                Row(children: [Icon(Icons.calendar_month), Text(showDate)]),
                Row(children: [Icon(Icons.timelapse_outlined), Text(showTime)]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
