import 'package:ddw_duel/view/event/event_form_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/domain/event/domain/event.dart';
import '/domain/event/repository/event_repository.dart';
import '../../provider/event_provider.dart';

class EventListComponent extends StatefulWidget {
  const EventListComponent({super.key});

  @override
  State<EventListComponent> createState() => _EventListComponentState();
}

class _EventListComponentState extends State<EventListComponent> {
  final EventRepository eventRepo = EventRepository();

  List<Event> _events = [];
  int? _selectedEventId;

  void _onSelectEvent(int eventId) {
    setState(() {
      _selectedEventId = eventId;
    });
    Provider.of<EventProvider>(context, listen: false).setEventId(eventId);
  }

  void _onPressed() async {
    bool? needRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EventFormPage()),
    );

    if (needRefresh != null && needRefresh) {
      fetchEvent();
    }
  }

  void fetchEvent() async {
    List<Event> events = await eventRepo.findEvents();
    setState(() {
      _events = events;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: _onPressed,
                  child: const Text(
                    '등록',
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
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
                            label: Text('설명',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _events.map((event) {
                        return DataRow(
                          selected: _selectedEventId == event.eventId,
                          onSelectChanged: (_) {
                            _onSelectEvent(event.eventId!);
                          },
                          cells: [
                            DataCell(
                              SizedBox(
                                width: constraints.maxWidth * 0.4,
                                child: Text(
                                  event.name,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: constraints.maxWidth * 0.5,
                                child: Text(
                                  event.description ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
