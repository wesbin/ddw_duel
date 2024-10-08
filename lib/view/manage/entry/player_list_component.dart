import 'package:ddw_duel/provider/selected_entry_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerListComponent extends StatefulWidget {
  const PlayerListComponent({super.key});

  @override
  State<PlayerListComponent> createState() => _PlayerListComponentState();
}

class _PlayerListComponentState extends State<PlayerListComponent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child:
        Consumer<SelectedEntryProvider>(builder: (context, provider, child) {
      if (provider.selectedEntryModel == null) {
        return const Center(
            child: Center(
          child: Text('팀을 선택해주세요.'),
        ));
      }
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(
                      label: Text('이름',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('포지션',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: provider.selectedEntryModel!.players.map((player) {
                  return DataRow(cells: [
                    DataCell(SizedBox(
                      width: constraints.maxWidth * 0.4,
                      child: Text(
                        player.name,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(fontSize: 16),
                      ),
                    )),
                    DataCell(SizedBox(
                      width: constraints.maxWidth * 0.4,
                      child: Text(
                        player.position == 1 ? 'A' : 'B',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(fontSize: 16),
                      ),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      );
    }));
  }
}
