import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidly/bloc/movie/movie_bloc.dart';
import 'package:vidly/bloc/rent_movie/rent_movie_bloc.dart';
import 'package:vidly/class/main.dart';
import 'package:vidly/views/home_view.dart';
import 'package:vidly/views/login_view.dart';
import 'package:vidly/views/rented_movies_view.dart';

void main() async {
   final mainBloc = MainBloc();

  // Initialize Firebase.
  await mainBloc.initializeFirebase();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (context) => MovieBloc(),
        ),
        BlocProvider<RentMovieBloc>(
          create: (context) => RentMovieBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a MaterialColor from the primary color
    MaterialColor primarySwatch = MaterialColor(0xFF0E2D52, <int, Color>{
      50: Color(0xFF0E2D52),
      100: Color(0xFF0E2D52),
      200: Color(0xFF0E2D52),
      300: Color(0xFF0E2D52),
      400: Color(0xFF0E2D52),
      500: Color(0xFF0E2D52),
      600: Color(0xFF0E2D52),
      700: Color(0xFF0E2D52),
      800: Color(0xFF0E2D52),
      900: Color(0xFF0E2D52),
    });

    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(
        primarySwatch: primarySwatch,
        // You can also use 'primarySwatch' for your primary color.
      ),
      home: const RentedMoviesView(),
    );
  }
}
