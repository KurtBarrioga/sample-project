import 'package:sampleproject/services/History.dart';

class HistoryController{
  
List<History> history = List();
  
  List<History> getHistory(){
    return history;
  }

  void addHistory(place, destination, source, img){
    history.add(History(place: place, destination: destination, source: source, img: img));
  }
  
  void deleteHistory(index){
    history.removeAt(index);
  }
}