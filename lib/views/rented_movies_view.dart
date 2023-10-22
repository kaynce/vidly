import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidly/bloc/rent_movie/rent_movie_bloc.dart';
import 'package:vidly/class/drawer.dart';
import 'package:vidly/model/movie_model.dart';
import 'package:vidly/model/rent_movie.dart';
import 'package:intl/intl.dart';

class RentedMoviesView extends StatefulWidget {
  const RentedMoviesView({Key? key}) : super(key: key);

  @override
  _RentedMoviesViewState createState() => _RentedMoviesViewState();
}

class _RentedMoviesViewState extends State<RentedMoviesView> {
  @override
  void initState() {
    context.read<RentMovieBloc>().add(const FetchRentedMovies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Rented Movies'),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<RentMovieBloc, RentMovieState>(
              builder: (context, state) {
                if (state is RentMovieLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is RentMovieLoaded) {
                  return ListView.builder(
                    itemCount: state.rentMovie.length,
                    itemBuilder: (context, index) {
                      final rentMovie = state.rentMovie[index];

                      DateTime? dtmDateRented = rentMovie.dtmDateRented;
                      String dtmDateRentedFormmated = dtmDateRented != null
                          ? DateFormat.yMMMd().format(dtmDateRented)
                          : 'N/A';

                      return FutureBuilder<Movie?>(
                        future: fetchMovieDetails(rentMovie.strMovieId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final movie = snapshot.data;

                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.all(16.0),
                              margin: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Movie Title: ${movie?.strTitle ?? 'N/A'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Date Rented: ${rentMovie.dtmDateRented?.toString() ?? 'N/A'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Price: ${movie?.dblPrice ?? 'N/A'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Release Date: ${movie?.dtmReleaseDate?.toString() ?? 'N/A'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Duration: ${_formatDuration(movie?.intDuration) ?? 'N/A'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Description: ${movie?.strDescription ?? 'N/A'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Date Rented: ${dtmDateRentedFormmated}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                } else if (state is RentMovieError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return Center(child: Text('No data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Movie?> fetchMovieDetails(String? movieId) async {
    try {
      print('movieId of rentmovie: ' + movieId.toString());
      final rentMovieService = RentMovieService();
      final movies = await rentMovieService.getMovies();
      return movies
          .firstWhere((movie) => movie.docId.toString() == movieId.toString());
    } catch (e) {
      print("Error fetching movie details: $e");
      return null;
    }
  }

  String _formatDuration(int? duration) {
    if (duration == null) {
      return 'N/A';
    }

    final int minutes = duration ~/ 60;
    final int seconds = duration % 60;

    return '$minutes min $seconds sec';
  }
}
