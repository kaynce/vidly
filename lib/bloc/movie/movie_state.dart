part of 'movie_bloc.dart';

@immutable
sealed class MovieState {}

final class MovieInitial extends MovieState {}

final class MovieLoading extends MovieState {}

final class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final Set<String> selectedItems;

  MovieLoaded(this.movies, this.selectedItems);

  @override
  List<Object> get props => [movies, selectedItems];
}

final class MovieError extends MovieState {
  final String error;

  MovieError(this.error);
}

// State to track selected items
final class MovieSelectionState extends MovieState {
  final Set<int> selectedItems;

  MovieSelectionState(this.selectedItems);

  @override
  List<Object> get props => [selectedItems];
}