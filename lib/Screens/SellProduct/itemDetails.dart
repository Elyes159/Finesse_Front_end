import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemDetails extends StatefulWidget {
  final Map<String, dynamic> product;

  const ItemDetails({super.key, required this.product});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int _currentImageIndex = 0;
  String? parametre;
  Future<void> _loadParameter() async {
    parametre = await const FlutterSecureStorage().read(key: 'parametre');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadParameter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Item Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.50,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icons/ArrowLeft.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel with rounded corners and partial next image
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, right: 1, left: 16, bottom: 8),
              child: SizedBox(
                height: 257,
                child: PageView.builder(
                  itemCount: widget.product['images'].length,
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
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                        child: Image.network(
                          "${AppConfig.baseUrl}/${widget.product['images'][index]}",
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
                  widget.product['images'].length,
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
            // Product Details
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18),
                  Text(
                    widget.product['productName'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Brand: ${widget.product["brand"]}",
                        style: TextStyle(
                          color: Color(0xFF111928),
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                      Text(
                        widget.product["taille"] != "U"
                            ? "Size: ${widget.product["taille"]}"
                            : widget.product["pointure"] != "99"
                                ? "Size: ${widget.product["taille"]}"
                                : "",
                        style: TextStyle(
                          color: Color(0xFF111928),
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                      Text(
                        "${widget.product["productPrice"]}",
                        style: TextStyle(
                          color: Color(0xFF111928),
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: (widget
                                          .product["owner_profile_pic"] !=
                                      "" &&
                                  widget.product["owner_profile_pic"] != null)
                              ? NetworkImage(parametre == "normal"
                                  ? "${AppConfig.baseUrl}${widget.product["owner_profile_pic"]}"
                                  : widget.product["owner_profile_pic"]!)
                              : AssetImage('assets/images/user.png')
                                  as ImageProvider,
                          backgroundColor: Colors.transparent,
                          child:
                              widget.product[""] == null ? Container() : null,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Aligns the text to the left
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.product["owner_username"]}",
                            style: TextStyle(
                              color: Color(0xFF111928),
                              fontSize: 16,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                              letterSpacing: 0.15,
                            ),
                          ),
                          Text(
                            '⭐️ ${widget.product["owner_ratings"]}',
                            style: TextStyle(
                              color: Color(0xFF111928),
                              fontSize: 14,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.10,
                            ),
                            textAlign: TextAlign
                                .start, // Ensures the text is left-aligned
                          )
                        ],
                      ),
                      Spacer(),
                      SvgPicture.asset("assets/Icons/arrow_profile.svg")
                    ],
                  )
                ],
              ),
            ),
            //
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left:16.0,right:16),
              child: Text(
                '${widget.product["description"]}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  height: 1.38,
                  letterSpacing: -0.13,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
