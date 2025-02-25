import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:flutter/material.dart';

class BoostArticle extends StatefulWidget {
  final String id;
  final List<dynamic> imageUrls;
  final String title;
  final String price;

  const BoostArticle({
    Key? key,
    required this.imageUrls,
    required this.title,
    required this.price,
    required this.id,
  }) : super(key: key);
  @override
  State<BoostArticle> createState() => _BoostArticleState();
}

class _BoostArticleState extends State<BoostArticle> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Text(
              'Boost',
              style: TextStyle(
                color: Color(0xFF111928),
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                height: 1.25,
                letterSpacing: 0.50,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 0.0, right: 0, left: 0, bottom: 8),
            child: SizedBox(
              height: 257,
              child: PageView.builder(
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 20), // Slight padding to show next image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      child: Image.network(
                        "${AppConfig.baseUrl}/${widget.imageUrls[index]}",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Image indicator (below the carousel)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? Color(0xFFC668AA)
                        : Color(0xFFD9D9D9),
                  ),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jeans veste',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '80.50 TND',
                style: TextStyle(
                  color: Color(0xFF111928),
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              )
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
            decoration: ShapeDecoration(
              color: Color(0xFFDCF3E2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '1 Day boost:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4 dt / day',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 33),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: ShapeDecoration(
                    color: Color(0xFF34A853),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Buy Boost',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
            decoration: ShapeDecoration(
              color: Color(0xFFDCF3E2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '1 Week boost:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '14 dt / week',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 33),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: ShapeDecoration(
                    color: Color(0xFF34A853),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Buy Boost',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
            decoration: ShapeDecoration(
              color: Color(0xFFDCF3E2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '1 Month boost:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '44 dt / month',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 33),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: ShapeDecoration(
                    color: Color(0xFF34A853),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Buy Boost',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
