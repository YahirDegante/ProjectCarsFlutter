import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/cart_repository.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';

class CarListView extends StatelessWidget {
  const CarListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car List'),
      ),
      body: BlocProvider(
        create: (context) => CarCubit(
          carRepository: RepositoryProvider.of<CarRepository>(context),
        ),
        child: const CarListScreen(),
      ),
    );
  }
}

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carCubit = BlocProvider.of<CarCubit>(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            carCubit.fetchAllCars();
          },
          child: const Text('Fetch Cars'),
        ),
        Expanded(
          child: BlocBuilder<CarCubit, CarState>(
            builder: (context, state) {
              if (state is CarLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CarSuccess) {
                final cars = state.cars;
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    return Card(
                      child: ListTile(
                        title: Text(car.marca),
                        subtitle: Text('${car.modelo} - ${car.cilindrada}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Implementar la funcionalidad de edición aquí
                                print('Edit car: ${car.id}');
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                carCubit.deleteCar(car.id);
                                print('Delete car: ${car.id}');
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is CarError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(
                  child: Text('Press the button to fetch cars'));
            },
          ),
        ),
      ],
    );
  }
}
