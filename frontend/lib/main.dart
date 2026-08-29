import 'package:flutter/material.dart';

void main() => runApp(const GongfitApp());

class GongfitApp extends StatelessWidget {
  const GongfitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '공핏',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF2563EB)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공핏')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('공공기관 취업,\n나에게 맞는지 먼저 확인하세요.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('채용공고와 내 정보를 비교해 적합도와 준비 전략을 확인할 수 있습니다.'),
          const SizedBox(height: 28),
          _Card(title: '채용공고 분석', subtitle: '공고를 붙여넣고 지원 가능 여부를 확인하세요.', icon: Icons.description_outlined, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyzePage()))),
          _Card(title: '내 적합도 확인', subtitle: '직무·경력·자격증을 기준으로 매칭합니다.', icon: Icons.analytics_outlined, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()))),
          _Card(title: '공핏 AI 상담', subtitle: '공고와 분석 결과를 바탕으로 질문하세요.', icon: Icons.chat_bubble_outline, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage()))),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title, subtitle; final IconData icon; final VoidCallback onTap;
  const _Card({required this.title, required this.subtitle, required this.icon, required this.onTap});
  @override Widget build(BuildContext context) => Card(child: ListTile(contentPadding: const EdgeInsets.all(16), leading: Icon(icon, size: 32), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(subtitle)), trailing: const Icon(Icons.chevron_right), onTap: onTap));
}

class AnalyzePage extends StatelessWidget {
  const AnalyzePage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('채용공고 분석')), body: const Padding(padding: EdgeInsets.all(20), child: TextField(maxLines: 16, decoration: InputDecoration(hintText: '채용공고 내용을 붙여넣으세요.', border: OutlineInputBorder()))));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('내 프로필')), body: ListView(padding: const EdgeInsets.all(20), children: const [TextField(decoration: InputDecoration(labelText: '희망 직무')), SizedBox(height: 12), TextField(decoration: InputDecoration(labelText: '전공')), SizedBox(height: 12), TextField(decoration: InputDecoration(labelText: '자격증')), SizedBox(height: 12), TextField(decoration: InputDecoration(labelText: '경력·경험'), maxLines: 5)]));
}

class ChatPage extends StatefulWidget { const ChatPage({super.key}); @override State<ChatPage> createState() => _ChatPageState(); }
class _ChatPageState extends State<ChatPage> { final controller = TextEditingController(); final messages = <String>[];
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('공핏 AI 상담')), body: Column(children: [Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: messages.length, itemBuilder: (_, i) => Align(alignment: i.isEven ? Alignment.centerRight : Alignment.centerLeft, child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(messages[i]))))),), SafeArea(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: '무엇이든 물어보세요', border: OutlineInputBorder()))), const SizedBox(width: 8), IconButton(onPressed: () { if (controller.text.trim().isEmpty) return; setState(() { messages.add(controller.text.trim()); messages.add('공핏 AI가 분석을 준비하고 있습니다.'); controller.clear(); }); }, icon: const Icon(Icons.send))]))])); }
