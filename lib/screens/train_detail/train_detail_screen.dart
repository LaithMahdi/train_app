import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:train/core/constants/app_color.dart';
import 'package:train/core/styles/style.dart';
import 'package:train/data/model/destination_model.dart';
import 'package:train/data/model/train_model.dart';
import 'package:train/main.dart';
import 'package:train/screens/train_detail/widgets/text_inline.dart';
import 'package:train/widgets/form/primary_button.dart';

class TrainDetailScreen extends StatefulWidget {
  const TrainDetailScreen({super.key});

  @override
  State<TrainDetailScreen> createState() => _TrainDetailScreenState();
}

class _TrainDetailScreenState extends State<TrainDetailScreen> {
  String? _id;
  TrainModel? _train;
  List<DestinationModel>? _destinations;
  bool _isLoading = false;
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _id = ModalRoute.of(context)!.settings.arguments as String;
        getTrain(_id!);
      });
    });

    super.initState();
  }

  void getTrain(String id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await supabase.from("train").select("*").match({"id": id});
      final dest = await supabase
          .from("destination")
          .select("*")
          .match({"train_id": id});

      setState(() {
        _train = data.isNotEmpty ? TrainModel.fromJson(data.first) : null;
        _destinations = dest.isNotEmpty
            ? dest.map((e) => DestinationModel.fromJson(e)).toList()
            : [];

        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching train data: $error');
    }
    setState(() {
      _isLoading = false;
    });
  }

  String formatTime(String time) {
    final parts = time.split(":");
    return "${parts[0]}:${parts[1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Train Detail")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Image.network(
                  _train?.image ??
                      "https://dbvutxgbawehhppbpbnv.supabase.co/storage/v1/object/sign/upload/train-png-13682.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJ1cGxvYWQvdHJhaW4tcG5nLTEzNjgyLnBuZyIsImlhdCI6MTcxMjQ4NjYyOSwiZXhwIjoxNzE3NjcwNjI5fQ.OIQmsLBDDI7E5LIxjjysLamwL-oWjoIJM1SrDG9FvV8&t=2024-04-07T10%3A43%3A47.103Z",
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : const Center(child: CircularProgressIndicator()),
                )),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInline(
                        title: "Name : ",
                        subtitle: _train?.name ?? '',
                        large: true,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Destinations",
                        style:
                            Style.body16.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (_destinations != null)
                        ..._destinations!.map(
                          (destination) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: AppColor.grey, width: 0.5),
                              ),
                            ),
                            child: Row(children: [
                              const Icon(Icons.swap_vert_rounded,
                                  size: 35, color: AppColor.grey),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextInline(
                                      title: "From : ",
                                      subtitle: destination.startStation ?? ''),
                                  TextInline(
                                      title: "To : ",
                                      subtitle: destination.endStation ?? '')
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.swap_vert_rounded,
                                      size: 30, color: AppColor.grey),
                                  const SizedBox(width: 5),
                                  Column(
                                    children: [
                                      Text(
                                        formatTime(destination.startTime ?? ''),
                                        style: Style.body14
                                            .copyWith(color: AppColor.black),
                                      ),
                                      Text(
                                        formatTime(destination.endTime ?? ''),
                                        style: Style.body14
                                            .copyWith(color: AppColor.black),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                          ),
                        ),
                    ],
                  ),
                )),
                // Text(_train?.description ?? ''),
                // Text(_train?.price.toString() ?? ''),
              ],
            ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Price:", style: Style.body12),
                Text(
                  "${_train?.price?.toStringAsFixed(3) ?? 0.0} TND",
                  style: Style.headline20.copyWith(fontSize: 17),
                ),
              ],
            )),
            Expanded(
              child: PrimaryButton(name: "Book Ticket", onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }
}
