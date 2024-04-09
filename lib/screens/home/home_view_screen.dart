import 'package:flutter/material.dart';
import 'package:train/core/styles/style.dart';
import 'package:train/data/model/train_model.dart';
import 'package:train/main.dart';
import 'package:train/widgets/snackbar/snackbar.dart';

class HomeViewScreen extends StatefulWidget {
  const HomeViewScreen({super.key});

  @override
  State<HomeViewScreen> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  List<TrainModel> _trainList = [];
  bool _isLoading = false;

  @override
  void initState() {
    getAllTrains();
    super.initState();
  }

  void getAllTrains() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await supabase.from("train").select("*");
      debugPrint("Data: $data");
      setState(() {
        _trainList = data.isNotEmpty
            ? data.map((e) => TrainModel.fromJson(e)).toList()
            : [];
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching train data: $error');

      showSnackbar(
        context: context,
        isError: true,
        message: "Error fetching train data !",
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onTrainTap(String id) {
    Navigator.pushNamed(context, "/train_detail", arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * .05),
          Text(
            "Train List",
            style: Style.headline20.copyWith(fontWeight: FontWeight.w500),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _trainList.length,
                  itemBuilder: (context, index) {
                    final train = _trainList[index];
                    return ListTile(
                      onTap: () => _onTrainTap(train.id!),
                      leading: Image.network(
                        train.image!,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const CircularProgressIndicator(),
                      ),
                      title: Text(train.name!),
                      subtitle: Text("Available seat: ${train.nbPlace}"),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
