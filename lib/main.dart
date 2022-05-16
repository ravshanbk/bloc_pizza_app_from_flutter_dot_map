import 'dart:math';

import 'package:bloc_pizza/bloc/pizza_bloc.dart';
import 'package:bloc_pizza/models/pizza_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PizzaBloc()..add(LoadPizzaCounter()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'The Pizza Bloc',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen(),
        ));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color co800 = const Color.fromRGBO(239, 108, 0, 1);
    Color co500 = const Color.fromRGBO(255, 152, 0, 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Pizza Bloc"),
        centerTitle: true,
        backgroundColor: co800,
      ),
      body: Center(
        child: BlocBuilder<PizzaBloc, PizzaState>(
          builder: (context, state) {
            if (state is PizzaInitial) {
              return CircularProgressIndicator(
                color: co800,
              );
            }
            if (state is PizzaLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${state.pizzas.length}',
                    style: const TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        for (int index = 0;
                            index < state.pizzas.length;
                            index++)
                          Positioned(
                            left: Random().nextInt(250).toDouble(),
                            top: Random().nextInt(400).toDouble(),
                            child: SizedBox(
                              height: 150.0,
                              width: 150.0,
                              child: state.pizzas[index].image,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Text("Something went wrong");
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.local_pizza_outlined),
            backgroundColor: co800,
            onPressed: () {
              context.read<PizzaBloc>().add(AddPizza(pizza: Pizza.pizzas[0]));
            },
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            backgroundColor: co800,
            onPressed: () {
              context
                  .read<PizzaBloc>()
                  .add(RemovePizza(pizza: Pizza.pizzas[0]));
            },
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            child: const Icon(Icons.local_pizza_outlined),
            backgroundColor: co500,
            onPressed: () {
              context.read<PizzaBloc>().add(AddPizza(pizza: Pizza.pizzas[1]));
            },
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            backgroundColor: co500,
            onPressed: () {
              context
                  .read<PizzaBloc>()
                  .add(RemovePizza(pizza: Pizza.pizzas[1]));
            },
          ),
        ],
      ),
    );
  }
}
