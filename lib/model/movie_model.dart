import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String? docId;
  final String? strTitle;
  final String? strDescription;
  final int? intDuration;
  final DateTime? dtmReleaseDate;
  final double? dblPrice;

  Movie(
      {this.docId,
      this.strTitle,
      this.strDescription,
      this.intDuration,
      this.dtmReleaseDate,
      this.dblPrice});
}

class MovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Movie>> getMovies() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('tblMovie').get();

      print('===== Step 1 =====');
      return snapshot.docs
          .map((doc) => Movie(
                docId: doc.id,
                strTitle: doc['strTitle'],
                strDescription: doc['strDescription'],
                intDuration: doc['intDuration'],
                dtmReleaseDate: doc['dtmReleaseDate'].toDate(),
                dblPrice: doc['dblPrice']?.toDouble(),
              ))
          .toList();
    } catch (e) {
      throw Exception("Failed to get movies: $e");
    }
  }

  // Method to add a new movie to your service
  Future<List<Movie>> addMovie(Movie newMovie) async {
    try {
      await _firestore.collection('tblMovie').add({
        'strTitle': newMovie.strTitle,
        'strDescription': newMovie.strDescription,
        'intDuration': newMovie.intDuration,
        'dtmReleaseDate': newMovie.dtmReleaseDate,
        'dblPrice': newMovie.dblPrice,
      });

      return getMovies(); // Return the updated list of movies
    } catch (e) {
      throw Exception("Failed to add the movie to Firestore: $e");
    }
  }

  // Method to remove a movie from your service
  Future<void> removeMovie(Set<String> docIds) async {
    try {
      for (String docId in docIds) {
        await _firestore.collection('tblMovie').doc(docId).delete();
      }
    } catch (e) {
      throw Exception("Failed to remove the movie from Firestore: $e");
    }
  }

  Future<List<Movie>> updateMovie(String docId, Movie updatedMovie) async {
    try {
      await _firestore.collection('tblMovie').doc(docId).update({
        'strTitle': updatedMovie.strTitle,
        'strDescription': updatedMovie.strDescription,
        'intDuration': updatedMovie.intDuration,
        'dtmReleaseDate': updatedMovie.dtmReleaseDate,
        'dblPrice': updatedMovie.dblPrice,
      });

      return getMovies();
    } catch (e) {
      throw Exception("Failed to update the movie in Firestore: $e");
    }
  }
}
