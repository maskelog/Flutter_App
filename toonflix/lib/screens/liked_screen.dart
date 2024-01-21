import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/service/api_service.dart';
import 'package:toonflix/widgets/webtoon_widget.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({Key? key}) : super(key: key);

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  late Future<List<WebtoonModel>> likedWebtoons;

  @override
  void initState() {
    super.initState();
    likedWebtoons = _getLikedWebtoons();
  }

  Future<List<WebtoonModel>> _getLikedWebtoons() async {
    final prefs = await SharedPreferences.getInstance();
    final likedIds = prefs.getStringList('likedToons') ?? [];
    List<WebtoonModel> likedWebtoons = [];

    try {
      List<WebtoonModel> allWebtoons = await ApiService.getTodaysToons();
      likedWebtoons = allWebtoons
          .where((webtoon) => likedIds.contains(webtoon.id))
          .toList();
    } catch (e) {
      print('Error fetching webtoon details: $e');
    }
    return likedWebtoons;
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Webtoons'),
      ),
      body: FutureBuilder<List<WebtoonModel>>(
        future: likedWebtoons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No liked webtoons'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var webtoon = snapshot.data![index];
              return Webtoon(
                title: webtoon.title,
                thumb: webtoon.thumb,
                id: webtoon.id,
              );
            },
          );
        },
      ),
    );
  }
}
