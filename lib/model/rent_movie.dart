import 'package:cloud_firestore/cloud_firestore.dart';

class RentMovie {
  final String? docId;
  final String? strCustomerId;
  final String? strMovieId;
  final DateTime? dtmDateRented;

  RentMovie(
      {this.docId, this.strCustomerId, this.strMovieId, this.dtmDateRented});
}

class RentMovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RentMovie?>> getRentMovies() async {
    try {
      final querySnapshot = await _firestore.collection('tblRentMovie').get();
      final rentMovies = querySnapshot.docs.map((document) {
        final data = document.data() as Map<String, dynamic>;
        if (data.containsKey('strCustomerId') &&
            data.containsKey('strMovieId') &&
            data.containsKey('dtmDateRented')) {
          return RentMovie(
            strCustomerId: data['strCustomerId'],
            strMovieId: data['strMovieId'],
            dtmDateRented: data['dtmDateRented'],
          );
        }
        return null; // If any of the required fields are missing
      }).toList();

      return rentMovies;
    } catch (e) {
      throw Exception("Failed to get RentMovies: $e");
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
          'dtmDateRented': DateTime.now(),
        });
      }

      await batch.commit();
      print("Rented movies added successfully to Firestore.");

      // Note: You should handle the result properly where you call this method.
      // You might want to use a 'then' or 'await' to handle the result.
      // For example: await addRentMovies(newRentMovies);

      // Return the updated list of RentMovies after adding.
      return getRentMovies();
    } catch (e) {
      throw Exception("Failed to add the RentMovies to Firestore: $e");
    }
  }

  // // Method to remove a RentMovie from your service
  // Future<void> removeRentMovie(Set<String> docIds) async {
  //   try {
  //     for (String docId in docIds) {
  //       await _firestore.collection('tblRentMovie').doc(docId).delete();
  //     }
  //   } catch (e) {
  //     throw Exception("Failed to remove the RentMovie from Firestore: $e");
  //   }
  // }

  // Future<List<RentMovie>> updateRentMovie(String docId, RentMovie updatedRentMovie) async {
  //   try {
  //     await _firestore.collection('tblRentMovie').doc(docId).update({
  //       'strTitle': updatedRentMovie.strTitle,
  //       'strDescription': updatedRentMovie.strDescription,
  //       'intDuration': updatedRentMovie.intDuration,
  //       'dtmReleaseDate': updatedRentMovie.dtmReleaseDate,
  //       'dblPrice': updatedRentMovie.dblPrice,
  //     });

  //     return getRentMovies();
  //   } catch (e) {
  //     throw Exception("Failed to update the RentMovie in Firestore: $e");
  //   }
  // }
}
