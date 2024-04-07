import 'package:flutter/material.dart';
import 'package:train/core/constants/app_color.dart';
import 'package:train/core/styles/style.dart';
import 'package:train/data/model/train_model.dart';

import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<TrainModel> _trainList = [];
  bool _isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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

      setState(() {
        _trainList = data.isNotEmpty
            ? data.map((e) => TrainModel.fromJson(e)).toList()
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_num), label: "Ticket"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        selectedLabelStyle: Style.body14.copyWith(fontWeight: FontWeight.w500),
        unselectedLabelStyle: Style.body12,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.greyAccentDark,
        showUnselectedLabels: true,
      ),
    );
  }
}
