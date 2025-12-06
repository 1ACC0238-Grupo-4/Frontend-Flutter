import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/core/enums/status.dart';
import 'package:workstation_flutter/core/storage/auth_repository.dart';
import 'package:workstation_flutter/features/chats/domain/chat.dart';
import 'package:workstation_flutter/features/chats/presentation/chat_details_page.dart';
import 'package:workstation_flutter/features/chats/presentation/chats_page.dart';
import 'package:workstation_flutter/features/offices/presentation/offices_page.dart';
import 'package:workstation_flutter/features/offices/presentation/widgets/office_card.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_bloc.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_event.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userId;

  final List<Chat> _recentChats = [
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
  ];

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(LoadUnavailableOffices());
    _loadUserId();
  }

  void _loadUserId() async {
    final authRepo = context.read<AuthRepository>();
    final id = await authRepo.getUserId();
    setState(() {
      _userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFF8BC34A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(200, 30),
                bottomRight: Radius.elliptical(200, 30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bienvenido Rodrigo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD4E99F),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Reservas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildReservasSection(),

                  const SizedBox(height: 32),

                  const Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildChatsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservasSection() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.status == Status.loading || _userId == null) {
          return _buildEmptyCard('Cargando reservas...');
        }

        if (state.status == Status.failure) {
          return _buildEmptyCard('Error al cargar reservas');
        }

        if (state.offices.isEmpty) {
          return _buildEmptyCard('No hay reservas activas');
        }

        final displayOffices = state.offices.take(3).toList();

        return Column(
          children: [
            ...displayOffices.map((office) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OfficeCard(
                    office: office,
                    userId: _userId!,
                  ),
                )),
            const SizedBox(height: 8),
            if (state.offices.length > 3)
              _buildViewMoreButton(
                text: 'Ver todas las reservas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OfficesPage(),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildChatsSection() {
    if (_recentChats.isEmpty) {
      return _buildEmptyCard('No hay mensajes nuevos');
    }

    return Column(
      children: [
        ..._recentChats.map((chat) => _buildChatCard(chat)),
        const SizedBox(height: 8),
        _buildViewMoreButton(
          text: 'Ver todos los chats',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatsPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChatCard(Chat chat) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(chat: chat),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F48C),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF8BC34A),
            backgroundImage: chat.contactImageUrl != null
                ? NetworkImage(chat.contactImageUrl!)
                : null,
            child: chat.contactImageUrl == null
                ? Text(
                    chat.contactName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                : null,
          ),
          title: Text(
            chat.contactName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          subtitle: chat.lastMessage != null
              ? Text(
                  chat.lastMessage!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.black38,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F48C),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildViewMoreButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return Center(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF8BC34A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF8BC34A),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}