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
          Container(
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
          : ElevatedButton(onPressed: (){}, child: const Text("Add to Cart"))
        ],),
      )
    );
  }
}