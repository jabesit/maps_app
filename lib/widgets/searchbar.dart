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
    _searchController.addListener(_handleFocusChange);
    super.initState();
  }

  void _handleFocusChange() {
    if (_searchController.text.length >= 5) {
      final searchBloc = BlocProvider.of<SearchBloc>(context);
      searchBloc.searchByCriteria(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

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
        viewLeading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _searchController.clear();
            Navigator.of(context).pop();
          },
          style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ),
        viewTrailing: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ],
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: _searchController,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            hintText: "Buscar Ubicacion...",
            leading: const Icon(Icons.search),
            trailing: [
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
            ],
            onTap: () {
              print('openView');
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
        suggestionsBuilder: (context, controller) {
          return [
            BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              if (state is OnResultSuggestionsEvent) {
                print("OnResultSuggestionsEvent");
              }
              if (state is OnErrorSuggestionsEvent) {
                print("OnErrorSuggestionsEvent");
              }
              final list = state.suggestionsList;
              if (list.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String item = list[index];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        controller.removeListener(_handleFocusChange);
                        controller.closeView(item);
                      },
                    );
                  },
                );
              }
              if (state.message.isNotEmpty) {
                return Text(state.message);
              }
              return ListTile(
                  leading: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                  ),
                  title: const Text("choose location"),
                  onTap: () {
                    searchBloc.add(OnActivateManualMarkerEvent());
                    controller.closeView("choose location");
                  });
            })
          ];
        },
      ),
    );
  }
}
