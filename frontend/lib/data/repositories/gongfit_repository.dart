import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile.dart';

class GongfitRepository { final String baseUrl; GongfitRepository({this.baseUrl='http://localhost:8000'});
 Future<Map<String,dynamic>> analyze(String text, Profile profile) async { final parsed=await http.post(Uri.parse('$baseUrl/api/v1/jobs/parse'),headers:{'Content-Type':'application/json'},body:jsonEncode({'text':text})); if(parsed.statusCode>=300) throw Exception('공고 분석에 실패했습니다.'); final job=jsonDecode(parsed.body); final match=await http.post(Uri.parse('$baseUrl/api/v1/match'),headers:{'Content-Type':'application/json'},body:jsonEncode({'profile':profile.toJson(),'job':job})); if(match.statusCode>=300) throw Exception('매칭 분석에 실패했습니다.'); return {'job':job,'analysis':jsonDecode(match.body)}; }
 Future<String> chat(String message,{Profile? profile,Map<String,dynamic>? job,Map<String,dynamic>? analysis}) async { final r=await http.post(Uri.parse('$baseUrl/api/v1/chat'),headers:{'Content-Type':'application/json'},body:jsonEncode({'message':message,'profile':profile?.toJson(),'job':job,'analysis':analysis})); if(r.statusCode>=300) throw Exception('AI 상담에 실패했습니다.'); return jsonDecode(r.body)['answer'] as String; }
}
