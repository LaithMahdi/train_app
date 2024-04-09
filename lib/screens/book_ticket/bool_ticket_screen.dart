import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:train/core/cache/app_cache.dart';
import 'package:train/core/functions/format_time.dart';
import 'package:train/core/styles/style.dart';
import 'package:train/data/model/destination_model.dart';
import 'package:train/data/model/ticket_model.dart';
import 'package:train/data/model/train_model.dart';
import 'package:train/main.dart';
import 'package:train/screens/train_detail/widgets/text_inline.dart';
import 'package:train/widgets/form/input.dart';
import 'package:train/widgets/form/primary_button.dart';
import 'package:train/widgets/snackbar/snackbar.dart';

class BoolTicketScreen extends StatefulWidget {
  const BoolTicketScreen({super.key});

  @override
  State<BoolTicketScreen> createState() => _BoolTicketScreenState();
}

class _BoolTicketScreenState extends State<BoolTicketScreen> {
  TrainModel? _train;
  DestinationModel? _selectedDestination;
  double? _price = 0.0;
  final TextEditingController _nbPlace = TextEditingController(text: "0");
  final TextEditingController _nbPersonHond = TextEditingController(text: "0");
  bool _isHodicap = false;
  bool _loading = false;
  bool _disabled = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final arguments =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        _train = arguments["train"] as TrainModel?;
        _selectedDestination = arguments["destination"] as DestinationModel?;
        _price = _train?.price;
      });
    });

    super.initState();
  }

  void handlePrice() {
    final int numberOfPersons = int.tryParse(_nbPlace.text) ?? 0;
    final int numberOfHandicappedPersons =
        int.tryParse(_nbPersonHond.text) ?? 0;

    setState(() {
      double originalPrice = _train!.price! * numberOfPersons;

      if (_isHodicap) {
        final double handicappedPrice =
            _train!.price! * 0.5 * numberOfHandicappedPersons;
        originalPrice -= handicappedPrice;
      }

      _price = originalPrice;
    });
  }

  handleHondicap(bool value) {
    setState(() {
      _isHodicap = value;
      if (!value) {
        _nbPersonHond.text = "0";
        _price = _train!.price! * int.tryParse(_nbPlace.text)!.toDouble();
      }
    });
  }

  Future<void> bookTicket() async {
    try {
      final int? numberOfPersons = int.tryParse(_nbPlace.text);
      if (numberOfPersons == null || numberOfPersons == 0) {
        showSnackbar(
          context: context,
          isError: true,
          message: "Please enter a valid number of persons.",
        );

        return;
      }

      setState(() {
        _loading = true;
        _disabled = true;
      });

      TicketModel ticket = TicketModel(
        userId: AppCache().getUserId(),
        trainId: _train?.id,
        destinationId: _selectedDestination?.id,
        price: _price,
        nbPlace: numberOfPersons,
        nbPersonHond: int.tryParse(_nbPersonHond.text) ?? 0,
        isHandicap: _isHodicap,
      );

      await supabase.from("ticket").insert([ticket.toJson()]);

      setState(() {
        _loading = false;
        _disabled = false;
      });

      showSnackbar(
          context: context, message: "Success booking ticket. Thank you!");

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      log("Error during booking: $e");

      showSnackbar(
        context: context,
        isError: true,
        message: "Error during booking. Please try again.",
      );

      setState(() {
        _loading = false;
        _disabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Ticket'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInline(
              title: "Name : ",
              subtitle: _train?.name ?? "",
              large: true,
            ),
            // const SizedBox(height: 20),
            const Divider(),
            TextInline(
              title: "Destination : ",
              subtitle:
                  "${_selectedDestination?.startStation} - ${_selectedDestination?.endStation}",
            ),
            const SizedBox(height: 10),
            TextInline(
              title: "Time : ",
              subtitle:
                  "${formatTime(_selectedDestination?.startTime)} - ${formatTime(_selectedDestination?.endTime)}",
            ),
            const SizedBox(height: 10),
            TextInline(
                title: "Ticket Price : ",
                subtitle: "${_train?.price!.toStringAsFixed(3)} TND"),
            const SizedBox(height: 10),
            TextInline(
                title: "Total Price : ",
                subtitle: "${_price!.toStringAsFixed(3)} TND"),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 5),

            Text(
              "Number of person",
              style: Style.body16.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Input(
              hintText: "Number of places",
              controller: _nbPlace,
              keyboardType: TextInputType.number,
              onChanged: (value) => handlePrice(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Is hodicap :",
                  style: Style.body16.copyWith(fontWeight: FontWeight.w600),
                ),
                Switch(
                    value: _isHodicap,
                    onChanged: (value) => handleHondicap(value)),
              ],
            ),
            const SizedBox(height: 10),
            _isHodicap
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Number of persons hodicaps",
                        style:
                            Style.body16.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Input(
                        hintText: "Number of persons hodicaps",
                        controller: _nbPersonHond,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => handlePrice(),
                      ),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Price:", style: Style.body12),
                Text(
                  "${_price?.toStringAsFixed(3) ?? 0.0} TND",
                  style: Style.headline20.copyWith(fontSize: 17),
                ),
              ],
            )),
            Expanded(
              child: PrimaryButton(
                name: "Book Ticket",
                onPressed: bookTicket,
                loading: _loading,
                disabled: _disabled,
              ),
            )
          ],
        ),
      ),
    );
  }
}
