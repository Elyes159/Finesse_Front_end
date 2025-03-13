import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finesse_frontend/ApiServices/backend_url.dart';

class StoryViewScreen extends StatefulWidget {
  final List<Map<String, dynamic>> stories;

  const StoryViewScreen({super.key, required this.stories});

  @override
  _StoryViewScreenState createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  int currentIndex = 0;
  double progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    progress = 0.0;
    _timer?.cancel(); // Annule le timer précédent au cas où
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        progress += 0.01;
      });

      if (progress >= 1) {
        timer.cancel();
        nextStory();
      }
    });
  }

  void nextStory() {
    if (currentIndex < widget.stories.length - 1) {
      if (!mounted) return;
      setState(() {
        currentIndex++;
        startTimer();
      });
    } else {
      closeScreen();
    }
  }

  void closeScreen() {
    if (mounted) {
      Navigator.pop(context);
    }
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          double screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            if (currentIndex > 0) {
              if (!mounted) return;
              setState(() {
                currentIndex--;
                startTimer();
              });
            }
          } else {
            nextStory();
          }
        },
        child: Stack(
          children: [
            // Image de la story
            Positioned.fill(
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.8), // Limite la hauteur de l'image
                child: Image.network(
                  "${AppConfig.baseUrl}/${story['story_image']}",
                  fit: BoxFit
                      .contain, // Utilise BoxFit.contain pour réduire la taille
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child:
                        Icon(Icons.broken_image, color: Colors.white, size: 50),
                  ),
                ),
              ),
            ),

            // Barre de progression
            Positioned(
              top: 120,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(widget.stories.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: LinearProgressIndicator(
                        value: index == currentIndex
                            ? progress
                            : (index < currentIndex ? 1 : 0),
                        backgroundColor: Colors.white30,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Header avec avatar et username
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: (story['avatar'] != null)
                        ? (story["avatar_type"] == "normal"
                            ? NetworkImage(
                                "${AppConfig.baseUrl}/${story['avatar']}")
                            : NetworkImage(story['avatar']))
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      story['user'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: closeScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
