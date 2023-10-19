import 'package:bloc/bloc.dart';
import 'package:vidly/model/movie_model.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService _movieService = MovieService();

  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async {
      try {
        emit(MovieLoading());
        try {
          final List<Movie> movies = await _movieService.getMovies();
          emit(MovieLoaded(movies, Set<String>()));
        } catch (e) {
          emit(MovieError("Failed to load movies: $e"));
        }
      } catch (e) {
        emit(MovieError('An error occurred: $e'));
        print('An error occurred $e');
      }
    });

    on<ToggleItemSelection>((event, emit) {
      final currentState = state;
      if (currentState is MovieLoaded) {
        final selectedItems = Set<String>.from(currentState.selectedItems);

        if (selectedItems.contains(event.index)) {
          selectedItems.remove(event.index);
        } else {
          selectedItems.add(event.index);
        }

        emit(MovieLoaded(currentState.movies, selectedItems));
      }
    });

    on<AddMovie>((event, emit) async {
      try {
        final Movie newMovie = event.movie;

        emit(MovieLoading()); // Emit MovieLoading to show a loading message

        final List<Movie> updatedMovies =
            await _movieService.addMovie(newMovie);

        emit(MovieLoaded(updatedMovies, Set<String>()));

        print('Movie saved successfully');
      } catch (e) {
        emit(MovieError("Failed to add the movie: $e"));
      }
    });

    on<RemoveMovie>((event, emit) async {
      try {
        final Set<String> docIds = event.docIds;

        emit(MovieLoading()); // Emit MovieLoading to show a loading message

        // Call your movie service method to remove the movie by doc ID
        await _movieService.removeMovie(docIds);

        final List<Movie> updatedMovies =
            await _movieService.getMovies(); // Update the list of movies

        emit(MovieLoaded(updatedMovies, Set<String>()));

        print('Movie removed successfully');
      } catch (e) {
        emit(MovieError("Failed to remove the movie: $e"));
      }
    });

    on<UpdateMovie>((event, emit) async {
      try {
        final String docId = event.docId;
        final Movie updatedMovie = event.updatedMovie;

        emit(MovieLoading()); 

        final List<Movie> updatedMovies =
            await _movieService.updateMovie(docId, updatedMovie);

        emit(MovieLoaded(updatedMovies, Set<String>()));

        print('Movie updated successfully');
      } catch (e) {
        emit(MovieError("Failed to update the movie: $e"));
      }
    });
  }
}
