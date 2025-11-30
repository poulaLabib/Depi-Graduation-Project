import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = 'AIzaSyBdZg6duvSJqy2lQCvHD8ozSChTX3jEl9c';
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService({required String userType}) {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );

    // System prompt based on user type
    final systemPrompt = userType == 'entrepreneur'
        ? '''You are a business advisor for Fikraty, a platform connecting entrepreneurs with investors (like Shark Tank).
        
Your role is to help entrepreneurs:
- Refine their business ideas and pitches
- Understand investor expectations
- Prepare financial projections
- Navigate the fundraising process
- Build strong company profiles
- Craft compelling request descriptions

Keep responses concise, practical, and encouraging. Focus on actionable advice.'''
        : '''You are a business advisor for Fikraty, a platform connecting entrepreneurs with investors.
        
Your role is to help investors:
- Evaluate startup opportunities
- Understand market trends and industries
- Assess business viability
- Navigate due diligence
- Make informed investment decisions
- Understand equity and valuation

Keep responses concise, professional, and insightful. Focus on risk assessment and opportunity analysis.''';

    _chat = _model.startChat(history: [
      Content.text(systemPrompt),
      Content.model([TextPart('I understand. I\'m ready to help!')]),
    ]);
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ?? 'Sorry, I couldn\'t generate a response.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String> getQuickAdvice(String topic, String userType) async {
    final prompts = {
      'pitch': userType == 'entrepreneur'
          ? 'Give me 3 quick tips for creating a compelling pitch for investors.'
          : 'Give me 3 key things to look for when evaluating a startup pitch.',
      'valuation': userType == 'entrepreneur'
          ? 'How do I determine my startup\'s valuation?'
          : 'How do I assess if a startup\'s valuation is reasonable?',
      'equity': userType == 'entrepreneur'
          ? 'How much equity should I offer to investors?'
          : 'What equity percentage should I aim for in an investment?',
      'profile': userType == 'entrepreneur'
          ? 'What should I include in my company profile to attract investors?'
          : 'What red flags should I watch for in entrepreneur profiles?',
    };

    return sendMessage(prompts[topic] ?? 'Give me general business advice.');
  }
}