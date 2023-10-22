import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidly/model/movie_model.dart';

class RentMovie {
  final String? docId;
  final String? strCustomerId;
  final String? strMovieId;
  final DateTime? dtmDateRented;

  RentMovie({
    this.docId,
    this.strCustomerId,
    this.strMovieId,
    this.dtmDateRented,
  });

  factory RentMovie.fromFirestore(Map<String, dynamic> data) {
    return RentMovie(
      docId: data['docId'] as String?,
      strCustomerId: data['strCustomerId'] as String?,
      strMovieId: data['strMovieId'] as String?,
      dtmDateRented: (data['dtmDateRented'] as Timestamp?)?.toDate(),
    );
  }
}

class RentMovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RentMovie>> getRentMovies() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('tblRentMovie').get();

      final List<Movie> movies = await getMovies(); // Retrieve movie data

      return snapshot.docs.map((doc) {
        final movieId = doc['strMovieId'] as String?;
        final movie = movies.firstWhere((m) => m.docId == movieId,
            orElse: () => Movie(
                  docId: '',
                  strTitle: '',
                  strDescription: '',
                  intDuration: 0,
                  dtmReleaseDate: DateTime(1900, 1, 1), // Provide a default date
                  dblPrice: 0.0,
                ));

        return RentMovie.fromFirestore(doc.data());
      }).toList();
    } catch (e) {
      throw Exception("Failed to get RentMovies: $e");
    }
  }

  Future<List<Movie>> getMovies() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('tblMovie').get();

      return snapshot.docs
          .map((doc) => Movie.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception("Failed to get Movies: $e");
    }
  }

  Future<List<RentMovie?>> addRentMovies(List<RentMovie> newRentMovies) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      for (final rentMovie in newRentMovies) {
        final documentRef =
            FirebaseFirestore.instance.collection('tblRentMovie').doc();
        batch.set(documentRef, {
          'strCustomerId': rentMovie.strCustomerId,
          'strMovieId': rentMovie.strMovieId,
          'dtmDateRented':
              Timestamp.fromDate(rentMovie.dtmDateRented ?? DateTime.now()),
        });
      }

      await batch.commit();
      print("Rented movies added successfully to Firestore.");

      return getRentMovies();
    } catch (e) {
      throw Exception("Failed to add the RentMovies to Firestore: $e");
    }
  }
}
