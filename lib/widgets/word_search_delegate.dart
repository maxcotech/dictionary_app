import 'package:dictionary/controllers/word_search_controller.dart';
import 'package:dictionary/helpers/extensions/string_extension.dart';
import 'package:dictionary/widgets/circular_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;

class WordSearchDelegate extends SearchDelegate {
  String param = "";
  WordSearchDelegate({this.param = ""}){
    query = param;
  }
  final WordSearchController controller = g.Get.put(WordSearchController());

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Type a word to search for.'));
    } else {
      return g.GetBuilder(
          init: WordSearchController(),
          builder: (_) => Column(children: <Widget>[
                Expanded(
                    child: FutureBuilder(
                        future: controller.searchWord(query),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            var words = snapshot.data;
                            if(words.length == 0){
                              return Center(child:Text('Could not find what you are looking for.'));
                            }
                            return ListView.separated(
                                physics: BouncingScrollPhysics(),
                                itemCount: words.length,
                                separatorBuilder: (_, index) => Divider(),
                                itemBuilder: (_, index) {
                                  Map<String, dynamic> word = words[index];
                                  String wordName = word['word'];
                                  return ListTile(
                                      title: Text(wordName.capitalizeAll()),
                                      trailing: Icon(CupertinoIcons.forward),
                                      onTap:()async{
                                        controller.openWordView(word['id']);
                                      }
                                      );
                                    
                                });
                          } else {
                            return Center(
                              child: CircularLoader());
                          }
                        }))
              ]));
    }
  }
}
