import 'package:ddw_duel/base/snackbar_helper.dart';
import 'package:ddw_duel/db/domain/player.dart';
import 'package:ddw_duel/db/model/entry_model.dart';
import 'package:ddw_duel/db/repository/player_repository.dart';
import 'package:ddw_duel/provider/entry_model_provider.dart';
import 'package:ddw_duel/provider/selected_entry_provider.dart';
import 'package:ddw_duel/provider/selected_event_provider.dart';
import 'package:ddw_duel/view/manage/entry/player_form_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerManageComponent extends StatefulWidget {
  const PlayerManageComponent({super.key});

  @override
  State<PlayerManageComponent> createState() => _PlayerManageComponentState();
}

class _PlayerManageComponentState extends State<PlayerManageComponent> {
  final PlayerRepository playerRepo = PlayerRepository();

  final _playerAFormKey = GlobalKey<FormState>();
  final TextEditingController _playerANameController = TextEditingController();

  final _playerBFormKey = GlobalKey<FormState>();
  final TextEditingController _playerBNameController = TextEditingController();

  void _onPressed() async {
    await _savePlayer(_playerAFormKey, _playerANameController, 1);
    await _savePlayer(_playerBFormKey, _playerBNameController, 2);
    await _afterSavePlayer();
  }

  Future<void> _savePlayer(GlobalKey<FormState> formKey,
      TextEditingController nameController, int position) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      EntryModel entryModel =
          Provider.of<SelectedEntryProvider>(context, listen: false)
              .selectedEntryModel!;

      Player? playerA = _getPlayerByPosition(entryModel.players, position);
      if (playerA == null) {
        Player player = Player(
          name: nameController.text,
          teamId: entryModel.team.teamId!,
          position: position,
        );
        await playerRepo.savePlayer(player);
      } else {
        playerA.name = nameController.text;
        await playerRepo.updatePlayer(playerA);
      }
    }
  }

  Future<void> _afterSavePlayer() async {
    int eventId = Provider.of<SelectedEventProvider>(context, listen: false)
        .selectedEvent!
        .eventId!;
    await Provider.of<EntryModelProvider>(context, listen: false)
        .fetchEntryModels(eventId);

    if (mounted) {
      Provider.of<SelectedEntryProvider>(context, listen: false).notify();
      SnackbarHelper.showInfoSnackbar(context,
          "${_playerANameController.text}, ${_playerBNameController.text} 선수 저장이 완료되었습니다.");
    }

    _playerAFormKey.currentState!.reset();
    _playerBFormKey.currentState!.reset();
  }

  Player? _getPlayerByPosition(List<Player> players, int position) {
    for (Player player in players) {
      if (player.position == position) {
        return player;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedEntryProvider>(
      builder: (context, provider, child) {
        if (provider.selectedEntryModel == null) {
          return const Center(
              child: Center(
            child: Text('팀을 선택해주세요.'),
          ));
        }
        List<Player> players = provider.selectedEntryModel!.players;
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '포지션 A',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      PlayerFormComponent(
                        position: 1,
                        playerNameController: _playerANameController,
                        formKey: _playerAFormKey,
                        player: _getPlayerByPosition(players, 1),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '포지션 B',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      PlayerFormComponent(
                        position: 2,
                        playerNameController: _playerBNameController,
                        formKey: _playerBFormKey,
                        player: _getPlayerByPosition(players, 2),
                      )
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _onPressed,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 150.0),
                    ),
                    child: const Text('저장'),
                  ),
                ),
              ],
            ));
      },
    );
  }
}