import 'package:flutter/foundation.dart';
import '../../data/models/profile.dart';
import '../../data/repositories/gongfit_repository.dart';

class ChatViewModel extends ChangeNotifier { final GongfitRepository repository; ChatViewModel(this.repository); final messages=<({bool user,String text})>[]; bool loading=false;
 Future<void> send(String text,{Profile? profile,Map<String,dynamic>? job,Map<String,dynamic>? analysis}) async { if(text.trim().isEmpty||loading)return; messages.add((user:true,text:text.trim())); loading=true; notifyListeners(); try { final answer=await repository.chat(text,profile:profile,job:job,analysis:analysis); messages.add((user:false,text:answer)); } catch(e) { messages.add((user:false,text:'잠시 후 다시 시도해주세요.')); } finally { loading=false; notifyListeners(); } }
}
