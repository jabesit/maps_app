import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';

class SearchBarCustom extends StatelessWidget {
  const SearchBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => state.displayManualMarker
            ? const SizedBox()
            : SafeArea(
                child: FadeInDown(
                    duration: const Duration(milliseconds: 300),
                    child: const _SearchBarBody())));
  }
}

class _SearchBarBody extends StatefulWidget {
  const _SearchBarBody();

  @override
  State<_SearchBarBody> createState() => _SearchBarBodyState();
}

class _SearchBarBodyState extends State<_SearchBarBody> {
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    _searchController.addListener(() {
      print("_searchController: ${_searchController.text}");
    });
    super.initState();
  }

  // these will be reused later
  final leading = const Icon(Icons.search);
  final trailing = [
    IconButton(
      icon: const Icon(Icons.keyboard_voice),
      onPressed: () {
        print('Use voice command');
      },
    ),
    IconButton(
      icon: const Icon(Icons.camera_alt),
      onPressed: () {
        print('Use image search');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final String hintCriteria = _searchController.text.isEmpty
        ? 'Escribir Criterio...'
        : _searchController.value.text;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
        isFullScreen: false,
        viewElevation: 100,
        searchController: _searchController,
        viewHintText: hintCriteria,
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: _searchController,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            hintText: "Buscar Ubicacion...",
            leading: leading,
            trailing: trailing,
            onTap: () {
              _searchController.openView();
            },
            onChanged: (String value) {
              print('value: $value');
            },
            onSubmitted: (value) {
              print("onSubmitted $value");
            },
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          final List<ListTile> list = [];

          list.add(ListTile(
              title: const Text("choose location"),
              onTap: () {
                final searchBloc = BlocProvider.of<SearchBloc>(context);
                searchBloc.add(OnActivateManualMarkerEvent());
                controller.closeView("choose location");
                /*
                  setState(() {
                    
                    controller.closeView("choose location");
                  });*/
              }));

          list.addAll(List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              leading: const Icon(
                Icons.location_on_outlined,
                color: Colors.black,
              ),
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          }));
          return list;
        },
      ),
    );
  }
}
