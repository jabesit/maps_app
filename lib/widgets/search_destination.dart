import 'package:flutter/material.dart';

class SearchDestination extends StatefulWidget {
  const SearchDestination({super.key});

  @override
  State<SearchDestination> createState() => _SearchAnchorExampleState();
}

class _SearchAnchorExampleState extends State<SearchDestination> {
  final SearchController _searchController = SearchController();

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
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SearchAnchor(
              isFullScreen: false,
              viewElevation: 100,
              searchController: _searchController,
              viewHintText: hintCriteria,
              headerHintStyle: const TextStyle(color: Colors.grey),
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  leading: leading,
                  trailing: trailing,
                  hintText: hintCriteria,
                  onTap: () {
                    _searchController.openView();
                  },
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                final keyword = controller.value.text;
                return List.generate(5, (index) => 'Item $index')
                    .where((element) =>
                        element.toLowerCase().startsWith(keyword.toLowerCase()))
                    .map((item) => ListTile(
                          title: Text(item),
                          onTap: () {
                            print(item);
                            setState(() {
                              controller.closeView(item);
                              FocusScope.of(context).unfocus();
                            });
                          },
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
