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
  List<WebtoonModel>? likedWebtoons;

  @override
  void initState() {
    super.initState();
    _loadLikedWebtoons();
  }

  Future<void> _loadLikedWebtoons() async {
    final prefs = await SharedPreferences.getInstance();
    final likedIds = prefs.getStringList('likedToons') ?? [];
    try {
      List<WebtoonModel> allWebtoons = await ApiService.getTodaysToons();
      setState(() {
        likedWebtoons = allWebtoons
            .where((webtoon) => likedIds.contains(webtoon.id))
            .toList();
      });
    } catch (e) {
      print('Error fetching webtoon details: $e');
    }
  }

  void _unlikeWebtoon(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> likedIds = prefs.getStringList('likedToons') ?? [];
    likedIds.remove(id);
    await prefs.setStringList('likedToons', likedIds);

    setState(() {
      likedWebtoons?.removeWhere((webtoon) => webtoon.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('좋아요'),
      ),
      body: likedWebtoons == null
          ? const Center(child: CircularProgressIndicator())
          : likedWebtoons!.isEmpty
              ? const Center(child: Text('No liked webtoons'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: likedWebtoons!.length,
                  itemBuilder: (context, index) {
                    var webtoon = likedWebtoons![index];
                    return Webtoon(
                      title: webtoon.title,
                      thumb: webtoon.thumb,
                      id: webtoon.id,
                      onUnliked: () => _unlikeWebtoon(webtoon.id),
                      showUnlikedIcon: true,
                    );
                  },
                ),
    );
  }
}
