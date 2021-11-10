import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class GifyPage extends StatefulWidget {
  @override
  _GifyPageState createState() => _GifyPageState();
}

class _GifyPageState extends State<GifyPage> {
  final TextEditingController controller = TextEditingController();
  final String url =
      'https://api.giphy.com/v1/gifs/search?api_key=e1dc1D5IhYvob3Wq8xVyAbWBB5WcxYWW&limit=12&offset=0&rating=g&lang=en&q=';
  bool showLoading = false;

  var data;

  @override
  void initState() {
    super.initState();
  }

  getData(String searchInput) async {
    showLoading = true;

    final res = await http.get(url + searchInput);

    data = jsonDecode(res.body)["data"];
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[700],
        body: Theme(
          data: ThemeData.dark(),
          child: VStack([
            "Gify App 😎".text.white.xl4.make().objectCenter().p(10),
            [
              Expanded(
                  child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Search here',
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8), // Added this
                      ))),
              ElevatedButton(
                onPressed: () {
                  getData(controller.text);
                },
                child: Text("Go"),
              ),
            ]
                .hStack(
                    axisSize: MainAxisSize.max,
                    crossAlignment: CrossAxisAlignment.center)
                .p24(),
            if (showLoading)
              CircularProgressIndicator().centered()
            else
              VxConditional(
                  condition: data != null,
                  builder: (context) => GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: context.isMobile ? 2 : 3),
                      itemBuilder: (context, index) {
                        final imgUrl = data[index]["images"]["fixed_height"]
                                ["url"]
                            .toString();

                        return ZStack(
                          [
                            BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Image.network(
                                  imgUrl,
                                  fit: BoxFit.cover,
                                  color: Colors.black.withOpacity(0.8),
                                  colorBlendMode: BlendMode.darken,
                                )),
                            Image.network(imgUrl, fit: BoxFit.contain)
                          ],
                          fit: StackFit.expand,
                        ).card.roundedSM.make().p4();
                      },
                      itemCount: data.length),
                  fallback: (context) => "Nothing found"
                      .text
                      .gray800
                      .xl2
                      .make()).h(context.percentHeight * 70)
          ]).p16().scrollVertical(physics: NeverScrollableScrollPhysics()),
        ));
  }
}
