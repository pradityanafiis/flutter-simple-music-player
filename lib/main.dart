import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubit/audio_player_cubit.dart';
import 'package:music_player_app/cubit/search_artist_cubit.dart';
import 'package:music_player_app/data/api/api_service.dart';
import 'package:music_player_app/ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => SearchArtistCubit(apiService: ApiService())),
        BlocProvider(create: (_) => AudioPlayerCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.brown,
          appBarTheme: AppBarTheme(),
        ),
        home: HomePage(),
      ),
    );
  }
}
