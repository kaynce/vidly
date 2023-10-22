part of 'rent_movie_bloc.dart';

sealed class RentMovieState extends Equatable {
  const RentMovieState();
  
  @override
  List<Object> get props => [];
}

final class RentMovieInitial extends RentMovieState {}

final class RentMovieLoading extends RentMovieState {}
final class RentMovieLoaded extends RentMovieState {
  final List<RentMovie> rentMovie;
  final Set<String> selectedItems;

  const RentMovieLoaded(this.rentMovie, this.selectedItems);

  @override
  List<Object> get props => [rentMovie, selectedItems];
}
final class RentMovieError extends RentMovieState {
  final String error;

  const RentMovieError(this.error);
}