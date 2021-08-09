import 'package:dictionary/models/word_parameter.dart';
import 'package:dictionary/services/dictionary_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

class Controller extends GetxController{
  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  InterstitialAd iads;
   bool _iadsReady = false;
   bool get iadsReady => this._iadsReady;
   void setIadsReady(bool val){
     this._iadsReady = val;
     this.update();
   }
   void showIntAds(){
     if(this.iadsReady == true){
       this.iads.show();
       this.setIadsReady(false);
     }
   }
  void setLoading(bool val){
    this._isLoading = val;
    this.update();
  }

  void openRandomWord() async {
    this.setLoading(true);
    var result = await Get.find<DictionaryService>().getRandomWordId();
    this.setLoading(false);
    Get.toNamed('/word_view',
      preventDuplicates: false,
      arguments: WordParameter(parameter:result,parameterType: ParameterType.primaryKey));

  }

  @override
  void onClose() {
    this.iads?.dispose();
    super.onClose();
  }

  

  


}