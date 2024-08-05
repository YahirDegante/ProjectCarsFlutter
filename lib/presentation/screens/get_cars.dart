import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/cart_repository.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';
import '../../data/models/car_model.dart';

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

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final _formKey = GlobalKey<FormState>();
  late CarModel _carToEdit;
  final _newCarFormKey = GlobalKey<FormState>();
  late CarModel _newCar;

  @override
  void initState() {
    super.initState();
    _newCar =
        CarModel(id: '', marca: '', color: '', modelo: '', cilindrada: '');
  }

  void _resetNewCarForm() {
    setState(() {
      _newCar =
          CarModel(id: '', marca: '', color: '', modelo: '', cilindrada: '');
      _newCarFormKey.currentState
          ?.reset(); // Resetear el formulario de registro
    });
  }

  @override
  Widget build(BuildContext context) {
    final carCubit = BlocProvider.of<CarCubit>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  carCubit.fetchAllCars();
                },
                child: const Text('Fetch Cars'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Registrar Nuevo Carro'),
                      content: Form(
                        key: _newCarFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              initialValue: _newCar.marca,
                              decoration: const InputDecoration(
                                labelText: 'Marca',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa la marca';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _newCar.marca = value!;
                              },
                            ),
                            TextFormField(
                              initialValue: _newCar.color,
                              decoration: const InputDecoration(
                                labelText: 'Color',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa el color';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _newCar.color = value!;
                              },
                            ),
                            TextFormField(
                              initialValue: _newCar.modelo,
                              decoration: const InputDecoration(
                                labelText: 'Modelo',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa el modelo';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _newCar.modelo = value!;
                              },
                            ),
                            TextFormField(
                              initialValue: _newCar.cilindrada,
                              decoration: const InputDecoration(
                                labelText: 'Cilindrada',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa la cilindrada';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _newCar.cilindrada = value!;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _resetNewCarForm();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_newCarFormKey.currentState!.validate()) {
                              _newCarFormKey.currentState!.save();
                              carCubit.createCar(_newCar);
                              Navigator.of(context).pop();
                              _resetNewCarForm();
                            }
                          },
                          child: const Text('Registrar'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Registrar Carro'),
              ),
            ],
          ),
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
                        title: Text('${car.marca} - ${car.color}'),
                        subtitle: Text('${car.modelo} - ${car.cilindrada}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _carToEdit =
                                      car; // Inicializando _carToEdit con el objeto car
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Edit Car'),
                                    content: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            initialValue: _carToEdit.marca,
                                            decoration: const InputDecoration(
                                              labelText: 'Marca',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ingresa la marca';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _carToEdit.marca = value!;
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: _carToEdit.color,
                                            decoration: const InputDecoration(
                                              labelText: 'Color',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ingresa el color';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _carToEdit.color = value!;
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: _carToEdit.modelo,
                                            decoration: const InputDecoration(
                                              labelText: 'Modelo',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ingresa el modelo';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _carToEdit.modelo = value!;
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: _carToEdit.cilindrada,
                                            decoration: const InputDecoration(
                                              labelText: 'Cilindrada',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Ingresa la cilindrada';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _carToEdit.cilindrada = value!;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            carCubit.updateCar(_carToEdit);
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                carCubit.deleteCar(car.id);
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
