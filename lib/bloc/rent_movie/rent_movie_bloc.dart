import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vidly/model/rent_movie.dart';

part 'rent_movie_event.dart';
part 'rent_movie_state.dart';

final class RentMovieBloc extends Bloc<RentMovieEvent, RentMovieState> {
  final RentMovieService _rentMovieService = RentMovieService();

  RentMovieBloc() : super(RentMovieInitial()) {
    on<FetchRentedMovies>((event, emit) async {
      try {
        emit(RentMovieLoading());
        try {
          final List<RentMovie> rentedMovies = await _rentMovieService.getRentMovies();
          emit(RentMovieLoaded(rentedMovies, Set<String>()));
        } catch (e) {
          emit(RentMovieError("Failed to load movies: $e"));
        }
      } catch (e) {
        emit(RentMovieError('An error occurred: $e'));
        print('An error occurred $e');
      }
    });

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
