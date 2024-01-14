import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:bookbyte_buyer/view/mainpage.dart';
import 'package:flutter/material.dart';
import '../model/book.dart';
import '../model/user.dart';
import '../shared/myserverconfig.dart';

class BookDetails extends StatefulWidget {
  final User user;
  final Book book;
  const BookDetails({super.key, required this.user, required this.book});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  late double screenWidth, screenHeight;
  @override
  Widget build(BuildContext context) {
  screenHeight = MediaQuery.of(context).size.height;
  screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Book Details"),),
      body: Center(
        child: Column(children: [
          SizedBox(
            height: screenHeight * 0.5,
            child: Image.network(
              fit: BoxFit.fitHeight,
              "${MyServerConfig.server}/bookbyte_buyer/image/book/${widget.book.bookId}.jpg"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flexible(
              child: Text(widget.book.bookTitle.toString(),
              style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ),
          ),
          Expanded(
            child: Column(children: [
          Text( "Author: ${widget.book.bookAuthor.toString()}"),
          Text("ISBN: ${widget.book.bookIsbn.toString()}"),
          Text("Description: ${widget.book.bookDesc.toString()}"),
          Text("Status: ${widget.book.bookStatus.toString()}"),
          Text("Quantity Left: ${widget.book.bookQty.toString()}"),
          Text("Price: ${widget.book.bookPrice.toString()}")
          ])),

          widget.user.username == "Guest"
          ? SizedBox(
          child: ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (content) => const Mainpage()));},
          child: const Text("Please Login to Buy")),
          )
          : widget.book.bookQty == "0"
             ? ElevatedButton(onPressed: (){
              showDialog(context: context,
                builder: (BuildContext context) {
                 return AlertDialog(
                  title: const Text('No Stock'),
                  content: const Text('Sorry, this item is currently out of stock.'),
                  actions: <Widget>[
                    TextButton(onPressed: () {Navigator.of(context).pop();},child: const Text('OK')),
                  ],
                );
              },);
             }, child: const Text("Add to Cart"),)
             : ElevatedButton(onPressed: (){addcart();}, child: const Text("Add to Cart"))
        ],),
      )
    );
  }

void addcart() {
showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Are you Sure?"),
      content: const Text("Do you want to proceed with this action?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Close dialog and return false
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {addtoCart();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
        ),
      ],
    ),
  );
}

void addtoCart() {
    http.post(
        Uri.parse("${MyServerConfig.server}/bookbyte_buyer/php/insert_cart.php"),
        body: {
          "buyer_id": widget.user.userid.toString(),
          "seller_id": widget.book.sellerId.toString(),
          "book_id": widget.book.bookId.toString(),
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          print(response);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}