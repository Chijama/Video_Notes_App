//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/widgets/new_folders.dart';
import '../models/folder.dart';
import '../widgets/folder_item.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Folder> _userFolders = [];

  void _addNewFolder(String fldtitle, Color fldColor) {
    final newFld = Folder(title: fldtitle, color: fldColor);
    setState(() {
      _userFolders.add(newFld);
    });
  }

  void _startAddNewFolder(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return NewFolder(_addNewFolder);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Note-Taking Application'),
      ),
      // body: Container(
      //   height: 900,
      //   child: _userFolders.isEmpty
      //       ? Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: <Widget>[
      //             Text(
      //               'No Folders added yet!',
      //               style: Theme.of(context).textTheme.headline6,
      //             ),
      //             SizedBox(
      //               height: 20,
      //             ),
      //             Container(
      //                 height: 500,
      //                 child: Image.asset(
      //                   'assets/images/waiting.png',
      //                   fit: BoxFit.cover,
      //                 )),
      //           ],
      //         )
      //       : ListView.builder(
      //           itemBuilder: (ctx, index) {
      //             return Card(
      //               color: _userFolders[index].color,
      //               elevation: 5,
      //               margin: EdgeInsets.symmetric(
      //                 vertical: 8,
      //                 horizontal: 5,
      //               ),
      //               child: ListTile(
      //                 title: Text(
      //                   _userFolders[index].title,
      //                   style: Theme.of(context).textTheme.headline6,
      //                 ),
      //                 // subtitle: Text(
      //                 //   DateFormat.yMMMd().format(transactions[index].date),
      //                 // ),
      //               ),
      //             );
      //           },
      //           itemCount: _userFolders.length,
      //         ),
      // ),
      body: Container(
          height: 900,
          child: _userFolders.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'No Folders added yet!',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Center(
                    //   child: Container(
                    //     height: 500,
                    //     child: Image.asset(
                    //       'assets/images/waiting.png',
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              : GridView(
                  padding: const EdgeInsets.all(25),
                  children: _userFolders
                      .map(
                        (catData) => FolderItem(
                          catData.id,
                          catData.title,
                          catData.color,
                        ),
                      )
                      .toList(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        tooltip: 'New Folder',
        backgroundColor: Colors.blue,
        onPressed: () => _startAddNewFolder(context),
      ),
    );
  }
}
