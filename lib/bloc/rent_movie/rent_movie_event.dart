part of 'rent_movie_bloc.dart';

sealed class RentMovieEvent extends Equatable {
  const RentMovieEvent();

  @override
  List<Object> get props => [];
}

final class FetchRentedMovies extends RentMovieEvent {
  const FetchRentedMovies();
}
final class AddRentMovie extends RentMovieEvent {
  final List<RentMovie> rentMovies;

  const AddRentMovie(this.rentMovies);

  @override
  List<Object> get props  => [rentMovies];
}
