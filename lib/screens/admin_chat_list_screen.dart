import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';


class AdminChatListScreen extends StatelessWidget {
  const AdminChatListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Chats'),
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF1E1E1E),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 1. Query all chats, sorted by last message
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('lastMessageAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error} \n\n (Have you created the Firestore Index?)'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No active chats.'));
          }

          final chatDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatDoc = chatDocs[index];
              final chatData = chatDoc.data() as Map<String, dynamic>;

              final String userId = chatDoc.id;
              final String userEmail = chatData['userEmail'] ?? 'User ID: $userId';
              final String lastMessage = chatData['lastMessage'] ?? '...';

              // 2. --- NEW: Get the admin's unread count ---
              final int unreadCount = chatData['unreadByAdminCount'] ?? 0;

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(userEmail, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xFF5A5A5A)),
                ),

                // 3. --- NEW: Show a Badge on the trailing icon ---
                trailing: unreadCount > 0
                    ? Badge(
                  label: Text('$unreadCount'),
                  backgroundColor: Color(0xFF4169E1),
                  child: Icon(Icons.arrow_forward_ios, color: Color(0xFF4169E1)),
                )

                      : Icon(Icons.arrow_forward_ios, color: Color(0xFF4169E1)),

                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatRoomId: userId,
                        userName: userEmail,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
