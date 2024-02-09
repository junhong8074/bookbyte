import 'dart:convert';
import 'dart:developer';
import 'package:bookbyte_buyer/view/bookdetail.dart';
import 'package:bookbyte_buyer/view/profilepage.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;
import '../model/book.dart';
import '../shared/myserverconfig.dart';
import 'package:bookbyte_buyer/view/cartpage.dart';


class HomePage extends StatefulWidget {
  final User userdata;
  const HomePage({super.key, required this.userdata});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> bookList = <Book>[];
  String title = "";
  @override
    void initState() {
    super.initState();
    loadBooks(title);
  }
  late double screenWidth, screenHeight;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  // ignore: prefer_typing_uninitialized_variables
  var color;
  @override
  Widget build(BuildContext context) {
  screenHeight = MediaQuery.of(context).size.height;
  screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {ShowSearchDialog();}
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (content) => CartPage(
              user: widget.userdata,
              )));}
          )
        ]
      ),
              drawer: Drawer(
        child: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text("Welcome!"),
      ),
      ListTile(
        title: const Text('My Profile'),
        onTap: () {
          Navigator.push(
            context,
              MaterialPageRoute(
                builder: (content) => ProfilePage(
                  userdata: widget.userdata,
                 )));
        },
      ),
      ListTile(
        title: const Text('Log Out', style: TextStyle(color: Colors.red,)),
        onTap: () {
          int count = 2;
          Navigator.of(context).popUntil((_) => count-- <= 0);
        },
      ),
    ],
  ),
)),
      body: Center(
        child: Column(
          children: [
          bookList.isEmpty
          ? const Center(child: Text("No Data"))
          : Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(bookList.length, (index) {
                      return Card(
                        child: InkWell(
                           onTap: () async {
                             Book book = Book.fromJson(bookList[index].toJson());
                             await Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (content) => BookDetails(
                                          user: widget.userdata,
                                          book: book,
                                         )));
                             loadBooks(title);
                           },
                          child: Column(
                            children: [
                              Flexible(
                                flex: 7,
                                child: Container(
                                  //width: screenWidth,
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.network(
                                      fit: BoxFit.fill,
                                      "${MyServerConfig.server}/bookbyte_buyer/image/book/${bookList[index].bookId}.jpg"),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      truncateString(
                                          bookList[index].bookTitle.toString()),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text("RM ${bookList[index].bookPrice}"),
                                    Text(
                                        "Available ${bookList[index].bookQty} unit"),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                  SizedBox(
                  height: screenHeight * 0.07,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //build the list for textbutton with scroll
                      if ((curpage - 1) == index) {
                        //set current page number active
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            loadBooks(title);
                            setState(() {});
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ));
                    },
                  ),
                ),
              ],
            ),
            ),
        );
  }

    String truncateString(String str) {
    if (str.length > 20) {
      str = str.substring(0, 20);
      return "$str...";
    } else {
      return str;
    }
  }
  
  void loadBooks(String title) {
      http.get(
      Uri.parse("${MyServerConfig.server}/bookbyte_buyer/php/load_book.php?title=$title&pageno=$curpage"),
    ).then((response) {
     // log(response.body);
      if (response.statusCode == 200) {
       log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
           bookList.clear();
           data['data']['books'].forEach((i) {
           bookList.add(Book.fromJson(i));
           });
           numofpage = int.parse(data['numofpage'].toString());
           numofresult = int.parse(data['numberofresult'].toString());
        } else {
          bookList.clear();
        }
      }
      setState(() {});
    });
  }
  
  // ignore: non_constant_identifier_names
  void ShowSearchDialog() {
       TextEditingController searchctlr = TextEditingController();
    title = searchctlr.text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Search Title or Author",
              style: TextStyle(),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchctlr,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    loadBooks(searchctlr.text);
                  },
                  child: const Text("Search"),
                )
              ],
            ));
      },
    );
  }
}