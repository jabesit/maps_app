import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';

import 'package:maps_app/screens/screens.dart';
import 'package:maps_app/services/services.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => LocationBloc()),
      BlocProvider(
          create: (context) =>
              MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
      BlocProvider(create: (context) => SearchBloc(trafficService: TrafficService()))
    ],
    child: const MapsApp(),
  ));
}

class MapsApp extends StatelessWidget {
  const MapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    GpsBloc bloc = BlocProvider.of<GpsBloc>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MapsApp',
      home: FutureBuilder(
        future: bloc.verifyPermissionGranted(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there was an error
            return Text('Error: ${snapshot.error}');
          } else {
            // If the future completed successfully
            return const LoadingScreen();
          }
        },
      ),
      routes: {},
    );
  }
}
