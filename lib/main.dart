import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidly/bloc/movie/movie_bloc.dart';
import 'package:vidly/bloc/rent_movie/rent_movie_bloc.dart';
import 'package:vidly/class/main.dart';
import 'package:vidly/views/home_view.dart';
import 'package:vidly/views/login_view.dart';

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
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.deepPurpleAccent),
        // You can also use 'primarySwatch' for your primary color.
      ),
      home: const LoginView(),
    );
  }
}
