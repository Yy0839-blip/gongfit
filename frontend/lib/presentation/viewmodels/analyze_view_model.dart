import 'package:flutter/foundation.dart';
import '../../data/models/profile.dart';
import '../../data/repositories/gongfit_repository.dart';

class AnalyzeViewModel extends ChangeNotifier { final GongfitRepository repository; AnalyzeViewModel(this.repository); bool loading=false; String? error; Map<String,dynamic>? result;
 Future<void> analyze(String text, Profile profile) async { loading=true; error=null; notifyListeners(); try { result=await repository.analyze(text,profile); } catch(e) { error=e.toString().replaceFirst('Exception: ',''); } finally { loading=false; notifyListeners(); } }
}
