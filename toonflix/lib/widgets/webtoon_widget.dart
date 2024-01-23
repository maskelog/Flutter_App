import 'package:flutter/material.dart';
import 'package:toonflix/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;
  final VoidCallback? onUnliked;
  final bool showUnlikedIcon;

  const Webtoon({
    Key? key,
    required this.title,
    required this.thumb,
    required this.id,
    this.onUnliked,
    this.showUnlikedIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title: title,
              thumb: thumb,
              id: id,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              Hero(
                tag: id,
                child: Container(
                  width: 250,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        offset: const Offset(10, 10),
                        color: Colors.black.withOpacity(0.5),
                      )
                    ],
                  ),
                  child: Image.network(
                    thumb,
                    headers: const {
                      'Referer': 'https://comic.naver.com',
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          if (showUnlikedIcon && onUnliked != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onUnliked,
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
