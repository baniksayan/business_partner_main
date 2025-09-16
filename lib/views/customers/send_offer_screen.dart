// import 'package:business_partner_main/views/notifications/notifications_screen.dart';
// import 'package:flutter/material.dart';
// import '../../resources/colors/app_colors.dart';
// import 'customers_list_screen.dart'; // For Customer class

// class SendOfferScreen extends StatefulWidget {
//   final Map<String, dynamic> template;
//   final Map<String, dynamic> wishlistItem;
//   final Customer customer;

//   static final Map<String, DateTime> lastOfferSent = {};

//   const SendOfferScreen({
//     Key? key,
//     required this.template,
//     required this.wishlistItem,
//     required this.customer,
//   }) : super(key: key);

//   @override
//   State<SendOfferScreen> createState() => _SendOfferScreenState();
// }

// class _SendOfferScreenState extends State<SendOfferScreen> {
//   late TextEditingController _messageController;
//   String _selectedChannel = 'Notification';

//   bool get canSend {
//     final last = SendOfferScreen.lastOfferSent[widget.customer.name];
//     if (last == null) return true;
//     return DateTime.now().difference(last) > Duration(days: 2);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _messageController = TextEditingController(
//       text: "Hi ${widget.customer.name},\n\n"
//           "We have a special offer for you: ${widget.wishlistItem['title']} at only ${widget.wishlistItem['price']}!\n"
//           "Don't miss out!",
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final template = widget.template;
//     return Scaffold(
//       backgroundColor: AppColors.splashBackground,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: AppColors.splashText),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: Text(
//           'Send Offer',
//           style: TextStyle(
//             color: AppColors.splashText,
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Template preview
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: template['color'].withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       template['name'],
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 17,
//                         color: template['color'],
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       template['desc'],
//                       style: TextStyle(
//                         color: AppColors.splashSubtext,
//                         fontSize: 13.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 18),
//               // Editable message
//               Text(
//                 'Edit Offer Message:',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.splashText,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _messageController,
//                 maxLines: 6,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   hintText: 'Type your offer message...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: AppColors.splashDots),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 18),
//               Text(
//                 'Send as:',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.splashText,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   _sendTypeButton('Notification', Icons.notifications),
//                   const SizedBox(width: 10),
//                   _sendTypeButton('Email', Icons.email),
//                   const SizedBox(width: 10),
//                   _sendTypeButton('SMS', Icons.sms),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               Center(
//                 child: ElevatedButton.icon(
//                   icon: Icon(Icons.send),
//                   label: Text('Send Offer'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: template['color'],
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   onPressed: canSend
//                       ? () {
//                           // Save the last sent time
//                           SendOfferScreen.lastOfferSent[widget.customer.name] = DateTime.now();
//                           // Add to notifications
//                           OfferNotificationStore.notifications.add(
//                             OfferNotification(
//                               title: widget.wishlistItem['title'],
//                               message: _messageController.text,
//                               channel: _selectedChannel,
//                               customer: widget.customer,
//                               date: DateTime.now(),
//                             ),
//                           );
//                           // Show confirmation
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Offer sent and added to notifications!')),
//                           );
//                           // Go back to Customer Detail screen
//                           Navigator.pop(context);
//                         }
//                       : null,
//                 ),
//               ),
//               if (!canSend)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12),
//                   child: Text(
//                     'You can send another offer to this customer after 2 days.',
//                     style: TextStyle(color: Colors.red, fontSize: 13),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _sendTypeButton(String type, IconData icon) {
//     final isSelected = _selectedChannel == type;
//     return OutlinedButton.icon(
//       icon: Icon(icon, color: isSelected ? Colors.white : AppColors.splashDots),
//       label: Text(type),
//       style: OutlinedButton.styleFrom(
//         backgroundColor: isSelected ? AppColors.splashDots : Colors.white,
//         foregroundColor: isSelected ? Colors.white : AppColors.splashDots,
//         side: BorderSide(color: AppColors.splashDots),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       onPressed: () {
//         setState(() {
//           _selectedChannel = type;
//         });
//       },
//     );
//   }
// }