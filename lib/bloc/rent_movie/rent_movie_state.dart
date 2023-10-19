part of 'rent_movie_bloc.dart';

sealed class RentMovieState extends Equatable {
  const RentMovieState();
  
  @override
  List<Object> get props => [];
}

final class RentMovieInitial extends RentMovieState {}

class RentMovieError extends RentMovieState {
  final String error;

  RentMovieError(this.error);
}