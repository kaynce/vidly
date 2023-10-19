import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vidly/model/rent_movie.dart';

part 'rent_movie_event.dart';
part 'rent_movie_state.dart';

class RentMovieBloc extends Bloc<RentMovieEvent, RentMovieState> {
  final RentMovieService _rentMovieService = RentMovieService();

  RentMovieBloc() : super(RentMovieInitial()) {
     on<AddRentMovie>((event, emit) async {
      try {
        final List<RentMovie> rentedMovies = event.rentMovies;

        await _rentMovieService.addRentMovies(rentedMovies);

        print('Movies rented saved successfully');
      } catch (e) {
        emit(RentMovieError("Failed to add rented movie: $e"));
      }
    });
  }
}
