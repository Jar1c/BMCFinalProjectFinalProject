import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. This function will mark all unread notifications as "read"
  void _markNotificationsAsRead(List<QueryDocumentSnapshot> docs) {
    // 2. Use a "WriteBatch" to update multiple documents at once
    final batch = _firestore.batch();

    for (var doc in docs) {
      if (doc['isRead'] == false) {
        // 3. If it's unread, add an "update" operation to the batch
        batch.update(doc.reference, {'isRead': true});
      }
    }

    // 4. "Commit" the batch, sending all updates to Firestore
    batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: _user == null
          ? const Center(child: Text('Please log in.'))
          : StreamBuilder<QuerySnapshot>(
        // 5. Get ALL notifications for this user, newest first
        stream: _firestore
            .collection('notifications')
            .where('userId', isEqualTo: _user!.uid)
            // .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('You have no notifications.'));
          }

          final docs = snapshot.data!.docs;

          // 6. --- IMPORTANT ---
          //    As soon as we have the notifications,
          //    we call our function to mark them as read.
          _markNotificationsAsRead(docs);

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final timestamp = (data['createdAt'] as Timestamp?);
              final formattedDate = timestamp != null
                  ? DateFormat('MM/dd/yy hh:mm a').format(timestamp.toDate())
                  : '';

              // 7. Check if this notification was *just* read
              final bool wasUnread = data['isRead'] == false;

              return ListTile(
                // 8. Show a "new" icon if it was unread
                leading: wasUnread
                    ? const Icon(Icons.circle, color: Colors.deepPurple, size: 12)
                    : const Icon(Icons.circle_outlined, color: Colors.grey, size: 12),
                title: Text(
                  data['title'] ?? 'No Title',
                  style: TextStyle(
                    fontWeight: wasUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${data['body'] ?? ''}\n$formattedDate',
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});
//
//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }
//
// class _NotificationsScreenState extends State<NotificationsScreen> {
//   final User? _user = FirebaseAuth.instance.currentUser;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<QueryDocumentSnapshot> _cachedNotifications = []; // Cache for stability
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//       ),
//       body: _user == null
//           ? const Center(child: Text('Please log in to view notifications.'))
//           : StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('notifications')
//                   .where('userId', isEqualTo: _user!.uid)
//                   .orderBy('createdAt', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 // DEBUG: Print stream states
//                 print('🔄 Stream State: ${snapshot.connectionState}');
//                 print('📊 Has Data: ${snapshot.hasData}');
//                 print('❌ Has Error: ${snapshot.hasError}');
//
//                 if (snapshot.hasError) {
//                   print('💥 Stream Error: ${snapshot.error}');
//                   print('💥 StackTrace: ${snapshot.stackTrace}');
//
//                   // Show cached data if available, even with error
//                   if (_cachedNotifications.isNotEmpty) {
//                     return _buildNotificationList(_cachedNotifications);
//                   }
//
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.error, size: 50, color: Colors.red),
//                         const SizedBox(height: 20),
//                         const Text('Error loading notifications'),
//                         Text(
//                           '${snapshot.error}',
//                           style: const TextStyle(fontSize: 12, color: Colors.grey),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () => setState(() {}),
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.notifications_none, size: 50, color: Colors.grey),
//                         SizedBox(height: 20),
//                         Text('You have no notifications.'),
//                       ],
//                     ),
//                   );
//                 }
//
//                 final docs = snapshot.data!.docs;
//                 print('✅ Notifications loaded: ${docs.length}');
//
//                 // Cache the notifications for stability
//                 _cachedNotifications = docs;
//
//                 return _buildNotificationList(docs);
//               },
//             ),
//     );
//   }
//
//   Widget _buildNotificationList(List<QueryDocumentSnapshot> docs) {
//     return ListView.builder(
//       itemCount: docs.length,
//       itemBuilder: (context, index) {
//         try {
//           final doc = docs[index];
//           final data = doc.data() as Map<String, dynamic>;
//
//           // SAFELY handle timestamp - common source of errors
//           final dynamic createdAt = data['createdAt'];
//           String formattedDate = 'Unknown date';
//
//           if (createdAt is Timestamp) {
//             formattedDate = DateFormat('MM/dd/yy hh:mm a').format(createdAt.toDate());
//           } else if (createdAt is DateTime) {
//             formattedDate = DateFormat('MM/dd/yy hh:mm a').format(createdAt);
//           } else {
//             print('⚠️ Invalid createdAt type: ${createdAt?.runtimeType}');
//           }
//
//           // SAFELY handle isRead
//           final dynamic isReadValue = data['isRead'];
//           final bool isUnread = isReadValue != true; // Default to unread if null/false
//
//           // SAFELY handle title and body
//           final String title = data['title']?.toString() ?? 'No Title';
//           final String body = data['body']?.toString() ?? 'No content';
//
//           return NotificationItem(
//             docId: doc.id,
//             title: title,
//             body: body,
//             formattedDate: formattedDate,
//             isUnread: isUnread,
//             onTap: _markAsRead,
//           );
//         } catch (e) {
//           print('❌ Error building notification item $index: $e');
//           return ListTile(
//             leading: const Icon(Icons.error, color: Colors.red),
//             title: const Text('Error loading notification'),
//             subtitle: Text('Error: $e'),
//           );
//         }
//       },
//     );
//   }
//
//   void _markAsRead(String docId) {
//     _firestore.collection('notifications').doc(docId).update({
//       'isRead': true,
//     });
//   }
// }
//
// // Separate widget for better performance and error isolation
// class NotificationItem extends StatelessWidget {
//   final String docId;
//   final String title;
//   final String body;
//   final String formattedDate;
//   final bool isUnread;
//   final Function(String) onTap;
//
//   const NotificationItem({
//     super.key,
//     required this.docId,
//     required this.title,
//     required this.body,
//     required this.formattedDate,
//     required this.isUnread,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: isUnread
//           ? const Icon(Icons.circle, color: Colors.deepPurple, size: 12)
//           : const Icon(Icons.circle_outlined, color: Colors.grey, size: 12),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(body),
//           Text(
//             formattedDate,
//             style: const TextStyle(fontSize: 12, color: Colors.grey),
//           ),
//         ],
//       ),
//       isThreeLine: true,
//       onTap: () {
//         if (isUnread) {
//           onTap(docId);
//         }
//       },
//     );
//   }
// }

