import 'package:flutter/material.dart';
import 'package:workstation_flutter/features/chats/domain/chat.dart';
import 'package:workstation_flutter/features/chats/presentation/chat_details_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {

  final List<Chat> _chats = [
    Chat(
      id: '1',
      contactName: 'Carlos Mendoza',
      lastMessage: 'Hola, ¿está disponible la oficina?',
      contactImageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Chat(
      id: '2',
      contactName: 'María García',
      lastMessage: 'Gracias por la información',
      contactImageUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Chat(
      id: '3',
      contactName: 'Juan Pérez',
      lastMessage: '¿A qué hora puedo ir?',
      contactImageUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Chat(
      id: '4',
      contactName: 'Ana Torres',
      lastMessage: 'Perfecto, nos vemos mañana',
      contactImageUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Chat(
      id: '5',
      contactName: 'Luis Ramírez',
      lastMessage: '¿Tienen WiFi disponible?',
      contactImageUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF8BC34A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(200, 30),
                bottomRight: Radius.elliptical(200, 30),
              ),
            ),
            child: const Center(
              child: Text(
                'Chats',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Chat list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return _buildChatItem(chat);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(Chat chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E99F), // Light green
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Hero( // ← Agrega Hero aquí
          tag: 'chat_${chat.id}',
          child: CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF8BC34A),
            backgroundImage: chat.contactImageUrl != null
                ? NetworkImage(chat.contactImageUrl!)
                : null,
            child: chat.contactImageUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 30)
                : null,
          ),
        ),
        title: Text(
          chat.contactName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: chat.lastMessage != null
            ? Text(
                chat.lastMessage!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        onTap: () { // ← Actualiza el onTap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(chat: chat),
            ),
          );
        },
      ),
    );
  }
}