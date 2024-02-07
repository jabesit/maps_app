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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            leading: const Icon(Icons.search),
            hintText: "Buscar Ubicacion...",
            trailing: const [
              Tooltip(
                message: 'Change brightness mode',
                child: Icon(Icons.wb_sunny_outlined),
              )
            ],
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
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
