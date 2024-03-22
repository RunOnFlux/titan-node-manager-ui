import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';

class ProviderPage extends StatelessWidget with GetItMixin {
  ProviderPage({super.key});
  @override
  Widget build(BuildContext context) {
    var providers = watchOnly((NodeManagerInfo info) => info.info.providers);
    return _ProviderTable(providers);
  }
}

class _ProviderTable extends StatefulWidget {
  final List<String> providers;

  const _ProviderTable(this.providers);

  @override
  _ProviderTableState createState() => _ProviderTableState(providers);
}

class _ProviderTableState extends State<_ProviderTable> {
  _ProviderTableState(this.providers);
  List<String> providers;

  @override
  Widget build(BuildContext context) {
    processProviders();
    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapCol(
          //  White space
          sizes: 'col-12 col-sm-6 col-md-9 col-lg-9 col-xl-9',
          child: const SizedBox(height: 50),
        ),
        BootstrapCol(
          sizes: 'col-12 col-sm-3 col-md-3 col-lg-3 col-xl-3',
          child: SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
              child: Text('Add Provider {NOT IMPLEMENTED}'),
              onPressed: () {
                print('Button pressed');
              },
            ),
          ),
        ),
        BootstrapCol(
          child: _buildProviderTable(),
        )
      ],
    );
  }

  void processProviders() {
    providers.remove('ADD NEW');
    providers.remove('--');
  }

  Widget _buildProviderTable() {
    return DataTable(
      columns: [
        DataColumn(
          label: Text('Provider'),
        )
      ],
      rows: providers.map<DataRow>(
        (provider) {
          return DataRow(cells: [DataCell(Text(provider))]);
        },
      ).toList(),
    );
  }
}
