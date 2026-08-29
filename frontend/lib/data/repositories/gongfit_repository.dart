import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile.dart';

class GongfitRepository {
  final String baseUrl;
  final Duration timeout;
  GongfitRepository({this.baseUrl='http://localhost:8000', this.timeout=const Duration(seconds:20)});

  Future<http.Response> _post(String path, Map<String,dynamic> body) async {
    try {
      return await http.post(Uri.parse('$baseUrl$path'), headers:{'Content-Type':'application/json'}, body:jsonEncode(body)).timeout(timeout);
    } on TimeoutException { throw Exception('서버 응답이 지연되고 있습니다. 잠시 후 다시 시도해주세요.'); }
    on http.ClientException { throw Exception('네트워크 연결을 확인해주세요.'); }
  }

  Future<Map<String,dynamic>> analyze(String text, Profile profile) async {
    final parsed=await _post('/api/v1/jobs/parse', {'text':text});
    if(parsed.statusCode>=300) throw Exception('채용공고를 분석하지 못했습니다.');
    final job=jsonDecode(parsed.body);
    final match=await _post('/api/v1/match', {'profile':profile.toJson(),'job':job});
    if(match.statusCode>=300) throw Exception('직무 적합도 분석에 실패했습니다.');
    return {'job':job,'analysis':jsonDecode(match.body)};
  }

  Future<String> chat(String message,{Profile? profile,Map<String,dynamic>? job,Map<String,dynamic>? analysis}) async {
    final r=await _post('/api/v1/chat', {'message':message,'profile':profile?.toJson(),'job':job,'analysis':analysis});
    if(r.statusCode>=300) throw Exception('AI 상담 서버가 응답하지 않습니다.');
    final data=jsonDecode(r.body);
    final answer=data['answer'];
    if(answer is! String || answer.trim().isEmpty) throw Exception('AI 답변을 받지 못했습니다.');
    return answer;
  }
}
