import 'package:asp/asp.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/data/extensions/extensions.dart';
import '../../../shared/data/types/open_protocol.dart';
import '../../../shared/external/datasources/implementations.dart';
import '../../../shared/ui/widgets/empty_collection.dart';
import '../../preferences/atoms/preferences_atom.dart';

class SelectImplementationPage extends StatefulWidget {
  const SelectImplementationPage({super.key});

  @override
  State<SelectImplementationPage> createState() =>
      _SelectImplementationPageState();
}

class _SelectImplementationPageState extends State<SelectImplementationPage> {
  DataSourceImplementation? implementation;
  OpenProtocolSpec? protocolSpec;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Escolha sua Instituição',
              style: context.textTheme.displayMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: DropdownSearch<DataSourceImplementation>(
              popupProps: PopupProps.modalBottomSheet(
                  itemBuilder: (context, e, _) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      title: Text(
                          e == DataSourceImplementation.none ? '--' : e.title),
                    );
                  },
                  modalBottomSheetProps: ModalBottomSheetProps(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: context.colors.surface,
                  ),
                  searchFieldProps: TextFieldProps(
                    padding: const EdgeInsets.all(24),
                    decoration: InputDecoration(
                      hintText: "Pesquisar Instituição",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  showSearchBox: true,
                  searchDelay: Duration.zero,
                  emptyBuilder: (_, __) {
                    return const EmptyCollection(
                      icon: Icons.search_off_outlined,
                      text: 'Nenhum Resultado',
                    );
                  }),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: "Escolha sua Instituição",
                  border: OutlineInputBorder(),
                ),
              ),
              onChanged: (e) {
                setState(() {
                  implementation = e;
                  if (implementation == DataSourceImplementation.openProtocol) {
                    fetchProtocolSpecs();
                  }
                });
              },
              items: DataSourceImplementation.values,
              filterFn: (e, filter) {
                return e.title.toLowerCase().contains(filter.toLowerCase());
              },
              itemAsString: (e) =>
                  e == DataSourceImplementation.none ? '--' : e.title,
              selectedItem: implementation,
            ),
          ),
          const SizedBox(height: 24),
          if (implementation == DataSourceImplementation.openProtocol)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: RxBuilder(builder: (context) {
                final isLoading = preferencesLoadingState.value;
                final specs = protocolSpecsState.value;

                return DropdownSearch<OpenProtocolSpec>(
                  onChanged: (e) {
                    setState(() {
                      protocolSpec = e;
                    });
                  },
                  itemAsString: (e) => e.title,
                  selectedItem: protocolSpec,
                  items: specs,
                  enabled: specs.isNotEmpty && !isLoading,
                  popupProps: PopupProps.modalBottomSheet(
                      itemBuilder: (context, i, _) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          title: Text(i.title),
                        );
                      },
                      modalBottomSheetProps: ModalBottomSheetProps(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: context.colors.surface,
                      ),
                      searchFieldProps: TextFieldProps(
                        padding: const EdgeInsets.all(24),
                        decoration: InputDecoration(
                          hintText: "Pesquisar Instituição",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      showSearchBox: true,
                      searchDelay: Duration.zero,
                      emptyBuilder: (_, __) {
                        return const EmptyCollection(
                          icon: Icons.search_off_outlined,
                          text: 'Nenhum Resultado',
                        );
                      }),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Instituição",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  filterFn: (e, filter) {
                    return e.title.toLowerCase().contains(filter.toLowerCase());
                  },
                );
              }),
            ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FilledButton(
              onPressed: implementation == null ||
                      implementation == DataSourceImplementation.none ||
                      (implementation ==
                              DataSourceImplementation.openProtocol &&
                          protocolSpec == null)
                  ? null
                  : () {
                      changeProtocolSpec.setValue(protocolSpec);
                      changeImplementation.setValue(implementation);
                      Modular.to.navigate('/auth/');
                    },
              child: const Text('Continuar'),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
