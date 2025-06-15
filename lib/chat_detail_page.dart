import 'package:flutter/material.dart';
import 'order_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatDetailPage extends StatefulWidget {
  final String? sellerName;

  const ChatDetailPage({super.key, this.sellerName});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _messages = [
    {"sender": "user", "text": "Halo, saya mau pesan bakso komplit."},
    {"sender": "seller", "text": "Baik kak, akan saya siapkan dulu ya."},
    {"sender": "info", "text": "Makanan telah dipesan!"},
    {"sender": "order", "text": "bakso"},
    {"sender": "user", "text": "Terima kasih!"},
  ];

  final String _ollamaApiUrl = "http://localhost:11434/api/chat";
  final String _ollamaModel = "llama3"; // Pastikan model llama3 sudah di-pull

  bool _isLoadingResponse = false;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({"sender": "user", "text": text});
        _controller.clear();
        _isLoadingResponse = true;
      });

      _getLlmResponse(text);
    }
  }

  Future<void> _getLlmResponse(String userMessage) async {
    List<Map<String, String>> conversationForOllama = [];

    // --- System Message untuk mengarahkan perilaku LLM ---
    conversationForOllama.add({
      "role": "system",
      "content":
          "Kamu adalah seorang pedagang kaki lima yang ramah dan membantu. Balas semua pertanyaan dengan bahasa Indonesia yang alami dan manusiawi. Hindari menjelaskan definisi atau konsep secara formal. Langsung ke intinya dan berikan informasi yang relevan dengan pertanyaan. Bersikaplah seperti sedang berbicara langsung dengan pelanggan.",
    });
    // --- Akhir System Message ---

    for (var msg in _messages) {
      if (msg['sender'] == 'user') {
        conversationForOllama.add({"role": "user", "content": msg['text']!});
      } else if (msg['sender'] == 'seller') {
        // Balasan sebelumnya dari 'seller' dianggap sebagai 'assistant' di konteks LLM
        conversationForOllama.add({
          "role": "assistant",
          "content": msg['text']!,
        });
      }
      // Pesan 'info' dan 'order' tidak dikirim ke LLM sebagai bagian dari konteks percakapan
    }

    // Tambahkan pesan pengguna saat ini
    conversationForOllama.add({"role": "user", "content": userMessage});

    try {
      final url = Uri.parse(_ollamaApiUrl);
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        "model": _ollamaModel,
        "messages": conversationForOllama,
        "stream": false, // Untuk mendapatkan seluruh respons sekaligus
        "options": {"temperature": 0.8},
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String llmResponse = "Maaf, terjadi kesalahan saat memproses.";

        if (data['message'] != null && data['message']['content'] != null) {
          llmResponse = data['message']['content'];
        }

        setState(() {
          _messages.add({"sender": "seller", "text": llmResponse});
        });
      } else {
        print("Error API Ollama: ${response.statusCode} - ${response.body}");
        setState(() {
          _messages.add({
            "sender": "seller",
            "text": "Maaf, Ollama tidak merespons dengan benar.",
          });
        });
      }
    } catch (e) {
      print("Koneksi ke Ollama gagal: $e");
      setState(() {
        _messages.add({
          "sender": "seller",
          "text":
              "Ups! Tidak dapat terhubung ke Ollama. Pastikan Ollama berjalan.",
        });
      });
    } finally {
      setState(() {
        _isLoadingResponse = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sellerName = widget.sellerName ?? 'Pedagang';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sellerName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'Buka - Pedagang Kaki Lima',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoadingResponse ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoadingResponse) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF7A32F4),
                        ),
                      ),
                    ),
                  );
                }

                final msg = _messages[index];
                if (msg['sender'] == 'user') {
                  return _bubbleRight(msg['text']!, screenWidth);
                } else if (msg['sender'] == 'seller') {
                  return _bubbleLeft(msg['text']!, screenWidth);
                } else if (msg['sender'] == 'info') {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        msg['text']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );
                } else if (msg['sender'] == 'order') {
                  return _orderCard(screenWidth);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                final orderResult =
                    await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderPage(),
                          ),
                        )
                        as Map<String, String>?;

                if (orderResult != null) {
                  setState(() {
                    _messages.add(orderResult);
                    _messages.add({
                      "sender": "info",
                      "text": "Makanan telah dipesan!",
                    });
                  });
                }
              },
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Pesan Makanan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A32F4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (value) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF7A32F4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubbleRight(String text, double screenWidth) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF7A32F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  Widget _bubbleLeft(String text, double screenWidth) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1E8FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: const TextStyle(fontFamily: 'Poppins')),
      ),
    );
  }

  Widget _orderCard(double screenWidth) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              'https://nibble-images.b-cdn.net/nibble/original_images/bakso-cover1-kulinersby.jpg',
              fit: BoxFit.cover,
              height: screenWidth < 400 ? 120 : 150,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Bakso Komplit Mang Ujang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Harga: Rp 14.000',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                Text(
                  'Total Pesanan: 1',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                Text(
                  'Total Harga: Rp 14.000',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 4),
                Text(
                  '• Pesanan diambil sendiri',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
