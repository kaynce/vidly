part of 'movie_bloc.dart';

@immutable
sealed class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final Set<String> selectedItems;

  MovieLoaded(this.movies, this.selectedItems);

  @override
  List<Object> get props => [movies, selectedItems];
}

class MovieError extends MovieState {
  final String error;

  MovieError(this.error);
}

// State to track selected items
class MovieSelectionState extends MovieState {
  final Set<int> selectedItems;

  MovieSelectionState(this.selectedItems);

  @override
  List<Object> get props => [selectedItems];
}