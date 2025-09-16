// import 'package:flutter/material.dart';
// import '../../resources/colors/app_colors.dart';
// import 'customers_list_screen.dart'; // For Customer class

// class ChooseOfferTemplateScreen extends StatelessWidget {
//   final Map<String, dynamic> wishlistItem;
//   final Customer customer;
//   const ChooseOfferTemplateScreen({Key? key, required this.wishlistItem, required this.customer}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Example static templates
//     final List<Map<String, dynamic>> templates = [
//       {
//         'name': 'Modern Offer',
//         'desc': 'A clean, modern template for special offers.',
//         'color': AppColors.splashDots,
//       },
//       {
//         'name': 'Festive Theme',
//         'desc': 'Bright and festive for holidays and events.',
//         'color': AppColors.splashSecondary,
//       },
//       {
//         'name': 'Minimal',
//         'desc': 'Simple and elegant for any occasion.',
//         'color': AppColors.splashAccent,
//       },
//     ];

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
//           'Choose Offer Template',
//           style: TextStyle(
//             color: AppColors.splashText,
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: templates.length,
//         itemBuilder: (context, i) {
//           final template = templates[i];
//           return Card(
//             color: template['color'].withOpacity(0.08),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//             margin: const EdgeInsets.only(bottom: 18),
//             child: ListTile(
//               leading: Icon(Icons.style, color: template['color'], size: 32),
//               title: Text(template['name'], style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.splashText)),
//               subtitle: Text(template['desc']),
//               trailing: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: template['color'],
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SendOfferScreen(
//                         template: template,
//                         wishlistItem: wishlistItem,
//                         customer: customer,
//                         onOfferSent: (offer) {
//                           // You can use a global/static list or a provider to add this offer to notifications
//                           // For demo, just show a snackbar
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Offer sent and added to notifications!')),
//                           );
//                         },
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text('Use'),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class SendOfferScreen extends StatefulWidget {
//   final Map<String, dynamic> template;
//   final Map<String, dynamic> wishlistItem;
//   final Customer customer;
//   final Function(Map<String, dynamic>) onOfferSent;

//   // Move lastOfferSent here as a static field
//   static final Map<String, DateTime> lastOfferSent = {};

//   const SendOfferScreen({
//     Key? key,
//     required this.template,
//     required this.wishlistItem,
//     required this.customer,
//     required this.onOfferSent,
//   }) : super(key: key);

//   @override
//   _SendOfferScreenState createState() => _SendOfferScreenState();
// }

// class _SendOfferScreenState extends State<SendOfferScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   String _selectedChannel = 'SMS';

//   bool get canSend {
//     final last = SendOfferScreen.lastOfferSent[widget.customer.name];
//     if (last == null) return true;
//     return DateTime.now().difference(last) > Duration(days: 2);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Send Offer'),
//         backgroundColor: widget.template['color'],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Sending to: ${widget.customer.name}',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text('Message:', style: TextStyle(fontSize: 14)),
//             TextField(
//               controller: _messageController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Enter your message here',
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('Select Channel:', style: TextStyle(fontSize: 14)),
//             DropdownButton<String>(
//               value: _selectedChannel,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedChannel = newValue!;
//                 });
//               },
//               items: <String>['SMS', 'Email', 'WhatsApp']
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 24),
//             Center(
//               child: ElevatedButton.icon(
//                 icon: Icon(Icons.send),
//                 label: Text('Send Offer'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: widget.template['color'],
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: canSend
//                     ? () {
//                         // Save the last sent time
//                         SendOfferScreen.lastOfferSent[widget.customer.name] = DateTime.now();
//                         widget.onOfferSent({
//                           'title': widget.wishlistItem['title'],
//                           'message': _messageController.text,
//                           'channel': _selectedChannel,
//                           'customer': widget.customer,
//                           'date': DateTime.now(),
//                         });
//                         Navigator.pop(context);
//                       }
//                     : null,
//               ),
//             ),
//             if (!canSend)
//               Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Text(
//                   'You can send another offer to this customer after 2 days.',
//                   style: TextStyle(color: Colors.red, fontSize: 13),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// lib/views/customers/choose_offer_template_screen.dart - CREATE THIS FILE IF NEEDED
import 'package:flutter/material.dart';
import '../../resources/colors/app_colors.dart';
import '../../models/customer.dart';

class ChooseOfferTemplateScreen extends StatelessWidget {
  final Map<String, dynamic> wishlistItem;
  final Customer customer;

  const ChooseOfferTemplateScreen({
    Key? key,
    required this.wishlistItem,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.splashText),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Choose Offer Template',
          style: TextStyle(
            color: AppColors.splashText,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_offer,
                size: 80,
                color: AppColors.splashDots,
              ),
              const SizedBox(height: 20),
              Text(
                'Creating Offer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.splashText,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Converting wishlist item to offer:',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.splashSubtext,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"${wishlistItem['title']}"',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.splashText,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price: ${wishlistItem['price']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.splashDots,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'For customer: ${customer.name}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.splashText,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement offer creation logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Offer created successfully for ${customer.name}!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.splashDots,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Create Offer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
