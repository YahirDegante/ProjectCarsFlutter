import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repository/cart_repository.dart';
import 'presentation/screens/get_cars.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CarRepository(
            apiUrl:
                'https://shmsuo9jhk.execute-api.us-east-1.amazonaws.com/yahir',
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Car Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home:
            const CarListView(), // Cambia esto para mostrar la vista de carros
      ),
    );
  }
}
