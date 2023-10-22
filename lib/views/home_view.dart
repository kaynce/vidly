import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vidly/bloc/movie/movie_bloc.dart';
import 'package:vidly/bloc/rent_movie/rent_movie_bloc.dart';
import 'package:vidly/class/drawer.dart';
import 'package:vidly/class/user_email.dart';
import 'package:vidly/model/movie_model.dart';
import 'package:vidly/model/rent_movie.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Define a set to keep track of selected items
  //Set<String> selectedItems = Set<String>();
  List<Movie> selectedItems = [];

  DateTime selectedDate =
      DateTime.now(); // Initialize selectedDate with the current date

  // Define text controllers for the form fields
  final TextEditingController docIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController releaseDateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    // When the view is initialized, trigger the FetchMovies event.
    //BlocProvider.of<MovieBloc>(context).add(FetchMovies());
    context.read<MovieBloc>().add(const FetchMovies());
    super.initState();
  }

  String _formatDuration(int? duration) {
    if (duration == null) {
      return 'N/A';
    }

    final int minutes = duration ~/ 60;
    final int seconds = duration % 60;

    return '$minutes min $seconds sec';
  }

  // Function to toggle the selection of an item
  void toggleSelection(String docId, String strTitle, String strDescription,
      int duration, DateTime dtmReleaseDate, double dblPrice) {
    setState(() {
      // Check if the item with the given docId is already in the selectedItems list
      bool itemSelected = selectedItems.any((movie) => movie.docId == docId);

      if (itemSelected) {
        // If it's already selected, remove it from the list
        selectedItems.removeWhere((movie) => movie.docId == docId);
      } else {
        // If it's not selected, add it to the list
        selectedItems.add(Movie(
          docId: docId,
          strTitle: strTitle,
          strDescription: strDescription,
          intDuration: duration,
          dtmReleaseDate: dtmReleaseDate,
          dblPrice: dblPrice,
        ));
      }
    });
    //BlocProvider.of<MovieBloc>(context).add(ToggleItemSelection(selectedItems.indexOf(docId)));
  }

  Future<void> _showReleaseDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Use selectedDate as the initial date
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate; // Update selectedDate with the picked date
        releaseDateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  // =================== Show seleted movies
//  void _showSelectedMoviesDialog(BuildContext context) {
//   final selectedMovies = selectedItems.map((docId) {
//     // Assuming you have a function to retrieve movie information by docId
//     Movie movie = getMovieInfoByDocId(docId);

//     return ListTile(
//       title: Text(movie.title),
//       subtitle: Text('Director: ${movie.director}\nRelease Year: ${movie.releaseYear}'),
//       // You can customize the display of movie information here
//     );
//   }).toList();

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Selected Movies'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: selectedMovies, // Add the selected movies to the dialog
//           ),
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               // Confirm rent logic
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: Text('Confirm Rent'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // Cancel rent logic
//             },
//             child: Text('Cancel'),
//           ),
//         ],
//       );
//     },
//   );
// }

  void _showRentMovie(BuildContext context, List<Movie> rentedMovies) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Rent Movies"),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: rentedMovies.length,
              itemBuilder: (context, index) {
                final movie = rentedMovies[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${index + 1}. Title: ${movie.strTitle}"),
                    Text("    Description: ${movie.strDescription}"),
                    Text("    Duration: ${movie.intDuration} minute/s"),
                    Text(
                        "    Release Date: ${DateFormat('MMM dd, yyyy').format(movie.dtmReleaseDate!)}"),
                    Text(
                        "    Price: ${movie.dblPrice?.toStringAsFixed(2) ?? 'N/A'}"),

                    SizedBox(height: 10), // Add spacing between movies
                  ],
                );
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _rentMovies(context, selectedItems);
              },
              child: Text('Rent'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // ===================== CRUD Operations =====================
  void _showAddMovieDialog(BuildContext context, String actionType) {
    if (actionType == "Add") {
      _clearFormFields();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(actionType),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: false, // Set this to false to hide the TextField
                  child: TextField(
                    controller: docIdController,
                    decoration: InputDecoration(labelText: 'Id'),
                  ),
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: durationController,
                  decoration: InputDecoration(labelText: 'Duration'),
                ),
                TextFormField(
                  controller: releaseDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Release Date',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {},
                    ),
                  ),
                  onTap: () {
                    _showReleaseDatePicker();
                  },
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final docId = docIdController.text;
                final title = titleController.text;
                final description = descriptionController.text;
                final duration = int.tryParse(durationController.text) ?? 0;
                //final releaseDate = DateTime.parse(releaseDateController.text);
                DateTime releaseDate;
                try {
                  releaseDate = DateTime.parse(releaseDateController.text);
                } catch (e) {
                  releaseDate =
                      DateTime.now(); // Handle the date parsing error as needed
                }
                final price = double.tryParse(priceController.text) ?? 0.0;

                print('releasdDate: ' + releaseDate.toString());
                final newMovie = Movie(
                  strTitle: title,
                  strDescription: description,
                  intDuration: duration,
                  dtmReleaseDate: releaseDate,
                  dblPrice: price,
                );

                if (actionType == "Add") {
                  _clearFormFields();
                  //BlocProvider.of<MovieBloc>(context).add(AddMovie(newMovie));
                  context.read<MovieBloc>().add(AddMovie(newMovie));
                } else {
                  //BlocProvider.of<MovieBloc>(context).add(UpdateMovie(docId, newMovie));
                  context.read<MovieBloc>().add(UpdateMovie(docId, newMovie));
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(actionType),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _removeMovie(Set<String> docIds) {
    //BlocProvider.of<MovieBloc>(context).add(RemoveMovie(docIds));
    context.read<MovieBloc>().add(RemoveMovie(docIds));
  }

  void _updateMovie(String docId, Movie updatedMovie) {
    //BlocProvider.of<MovieBloc>(context).add(UpdateMovie(docId, updatedMovie));
    context.read<MovieBloc>().add(UpdateMovie(docId, updatedMovie));
  }

  // void _rentMovies(BuildContext context, List<Movie> selectedItems){
  //    BlocProvider.of<RentMovieBloc>(context).add(AddRentMovie(selectedItems.getDocid, getmovieltitle));
  // }
  void _rentMovies(BuildContext context, List<Movie> selectedItems) {
    final List<RentMovie> rentedMovies = selectedItems.map((movie) {
      return RentMovie(
        strCustomerId: '0001',
        strMovieId: movie.docId,
      );
    }).toList();

    context.read<RentMovieBloc>().add(AddRentMovie(rentedMovies));
    //BlocProvider.of<RentMovieBloc>(context).add(AddRentMovie(rentedMovies));
  }

  // Function to set the form fields with movie data
  void _setFormFieldsWithMovieData(Movie movie) {
    docIdController.text = movie.docId ?? '';
    titleController.text = movie.strTitle ?? '';
    descriptionController.text = movie.strDescription ?? '';
    durationController.text = movie.intDuration?.toString() ?? '';
    releaseDateController.text =
        DateFormat('yyyy-MM-dd').format(movie.dtmReleaseDate ?? DateTime.now());
    priceController.text = movie.dblPrice?.toString() ?? '';
  }

  // Function to set the form fields with movie data
  void _clearFormFields() {
    docIdController.clear();
    titleController.clear();
    descriptionController.clear();
    durationController.clear();
    releaseDateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    priceController.clear();
  }

  UserEmail userEmail = UserEmail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Movies'),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            child: Wrap(
              spacing: 10,
              children: [
                if (userEmail.email.toString() != "kleoabelido01@gmail.com")
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                      onPressed: () {
                        _showRentMovie(context, selectedItems);
                      },
                      child: const Text('Rent'),
                    ),
                  ),
                if (userEmail.email.toString() == "kleoabelido01@gmail.com")
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                      onPressed: () {
                        _showAddMovieDialog(context, 'Add');
                      },
                      child: const Text('Add Movie'),
                    ),
                  ),
                if (userEmail.email.toString() == "kleoabelido01@gmail.com")
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                      onPressed: () async {
                        if (selectedItems.isNotEmpty) {
                          //Get the first element
                          final selectedMovieId = selectedItems.first.docId;
                            
                          final movieSnapshot = await FirebaseFirestore.instance
                              .collection('tblMovie')
                              .doc(selectedMovieId.toString())
                              .get();

                          if (movieSnapshot.exists) {
                            final movieData =
                                movieSnapshot.data() as Map<String, dynamic>;

                            final selectedMovie = Movie(
                              docId: selectedMovieId.toString(),
                              strTitle: movieData['strTitle'],
                              strDescription: movieData['strDescription'],
                              intDuration: movieData['intDuration'],
                              dtmReleaseDate:
                                  movieData['dtmReleaseDate'].toDate(),
                              dblPrice: movieData['dblPrice']?.toDouble(),
                            );

                            _setFormFieldsWithMovieData(selectedMovie);
                            _showAddMovieDialog(context, 'Update');
                          }
                        }
                      },
                      child: Text('Update Movie'),
                    ),
                  ),
                if (userEmail.email.toString() == "kleoabelido01@gmail.com")
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 10), // Adjust the margin as needed
                    child: OutlinedButton(
                      onPressed: () {
                        if (selectedItems.isNotEmpty) {
                          Set<String> docIds = selectedItems
                              .map((movie) => movie.docId.toString())
                              .toSet();
                          _removeMovie(docIds);
                        }
                      },
                      child: Text('Remove Movie'),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MovieLoaded) {
                  return ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];

                      // Check if the item is selected
                      //bool isSelected = selectedItems.contains(movie.docId);
                      bool isSelected = selectedItems
                          .map((movie) => movie.docId)
                          .contains(movie.docId);

                      return GestureDetector(
                        onTap: () {
                          toggleSelection(
                            movie.docId.toString(),
                            movie.strTitle.toString(),
                            movie.strDescription.toString(),
                            movie.intDuration ?? 0,
                            movie.dtmReleaseDate ?? DateTime.now(),
                            movie.dblPrice ?? 0,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Checkbox to select/deselect the item
                              Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  toggleSelection(
                                    movie.docId.toString(),
                                    movie.strTitle.toString(),
                                    movie.strDescription.toString(),
                                    movie.intDuration ?? 0,
                                    movie.dtmReleaseDate ?? DateTime.now(),
                                    movie.dblPrice ?? 0,
                                  );
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Title: ${movie.strTitle ?? 'N/A'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      'Description: ${movie.strDescription ?? 'N/A'}'),
                                  Text(
                                    'Duration: ${_formatDuration(movie.intDuration)}',
                                  ),
                                  Text(
                                      'Release Date: ${movie.dtmReleaseDate?.toString() ?? 'N/A'}'),
                                  Text(
                                      'Price: ${movie.dblPrice?.toStringAsFixed(2) ?? 'N/A'}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is MovieError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return Center(child: Text('No data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
