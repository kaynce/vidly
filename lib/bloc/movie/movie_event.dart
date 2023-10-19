part of 'movie_bloc.dart';

@immutable

sealed class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

final class FetchMovies extends MovieEvent {
  const FetchMovies();
}

// Event to handle item selection
final class ToggleItemSelection extends MovieEvent {
  final String index;

  const ToggleItemSelection(this.index);

  @override
  List<Object> get props => [index];
}

final class AddMovie extends MovieEvent {
  final Movie movie;

  const AddMovie(this.movie);

  @override
  List<Object> get props  => [movie];
}

final class RemoveMovie extends MovieEvent {
  final Set<String> docIds;

  const RemoveMovie(this.docIds);

  @override
  List<Object> get props => [docIds];
}

final class UpdateMovie extends MovieEvent {
  final String docId;
  final Movie updatedMovie;

  const UpdateMovie(this.docId, this.updatedMovie);

  @override
  List<Object> get props => [docId, updatedMovie];
}
