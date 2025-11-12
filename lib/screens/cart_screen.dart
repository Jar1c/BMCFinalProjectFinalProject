// import 'package:ecommerce_app/providers/cart_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ecommerce_app/screens/order_success_screen.dart';
// import 'package:ecommerce_app/screens/payment_screen.dart';
//
// // 2. It's a StatelessWidget again!
// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});
//
//
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Cart'),
//       ),
//       body: Column(
//         children: [
//           // 2. The list of items
//           Expanded(
//             // 3. If cart is empty, show a message
//             child: cart.items.isEmpty
//                 ? const Center(child: Text('Your cart is empty.'))
//                 : ListView.builder(
//               itemCount: cart.items.length,
//               itemBuilder: (context, index) {
//                 final cartItem = cart.items[index];
//                 // 4. A ListTile to show item details
//                 return ListTile(
//                   leading: CircleAvatar(
//                     // Show a mini-image (or first letter)
//                     child: Text(cartItem.name[0]),
//                   ),
//                   title: Text(cartItem.name),
//                   subtitle: Text('Qty: ${cartItem.quantity}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // 5. Total for this item
//                       Text(
//                           '₱${(cartItem.price * cartItem.quantity)
//                               .toStringAsFixed(2)}'),
//
//                       // 6. Remove button
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           // 7. Call the removeItem function
//                           cart.removeItem(cartItem.id);
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // ... (after the Expanded(child: ListView.builder(...))
//
//           // 3. --- THIS IS THE NEW PRICE BREAKDOWN CARD ---
//           Card(
//             margin: const EdgeInsets.all(16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column( // 4. Use a Column for multiple rows
//                 children: [
//
//                   // 5. ROW 1: Subtotal
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Subtotal:',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '₱${cart.subtotal.toStringAsFixed(2)}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   // 6. ROW 2: VAT
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'VAT (12%):',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '₱${cart.vat.toStringAsFixed(2)}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//
//                   const Divider(height: 20, thickness: 1),
//
//                   // 7. ROW 3: Total
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Total:',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         '₱${cart.totalPriceWithVat.toStringAsFixed(2)}',
//                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//
//
//
//           // 4. --- ADD THIS NEW BUTTON ---
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50), // Wide button
//               ),
//
//               // 5. Disable button if loading OR if cart is empty
//               onPressed: (_isLoading || cart.items.isEmpty) ? null : () async {
//                 // 6. Start the loading spinner
//                 setState(() {
//                   _isLoading = true;
//                 });
//
//                 try {
//                   // 7. Get provider (listen: false is for functions)
//                   final cartProvider = Provider.of<CartProvider>(
//                       context, listen: false);
//
//                   // 8. Call our new methods
//                   await cartProvider.placeOrder();
//                   await cartProvider.clearCart();
//
//                   // 9. Navigate to success screen
//                   Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => const OrderSuccessScreen()),
//                         (route) => false,
//                   );
//                 } catch (e) {
//                   // 10. Show error if placeOrder() fails
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Failed to place order: $e')),
//                   );
//                 } finally {
//                   // 11. ALWAYS stop the spinner
//                   if (mounted) {
//                     setState(() {
//                       _isLoading = false;
//                     });
//                   }
//                 }
//               },
//
//               // 12. Show spinner or text based on loading state
//               child: _isLoading
//                   ? const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               )
//                   : const Text('Place Order'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/screens/order_success_screen.dart';
import 'package:ecommerce_app/screens/payment_screen.dart';

// 2. It's a StatelessWidget again!
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});


  @override
  Widget build(BuildContext context) {
    // 3. We listen: true, so the list and total update
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          // 4. The ListView is the same as before
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Your cart is empty.'))
                : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(cartItem.name[0]),
                  ),
                  title: Text(cartItem.name),
                  subtitle: Text('Qty: ${cartItem.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          '₱${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          cart.removeItem(cartItem.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 5. --- THIS IS OUR NEW PRICE BREAKDOWN CARD (from Module 15) ---
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                      Text('₱${cart.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('VAT (12%):', style: TextStyle(fontSize: 16)),
                      Text('₱${cart.vat.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        '₱${cart.totalPriceWithVat.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 6. --- THIS IS THE MODIFIED BUTTON ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              // 7. Disable if cart is empty, otherwise navigate
              onPressed: cart.items.isEmpty ? null : () {
                // 8. Navigate to our new PaymentScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      // 9. Pass the final VAT-inclusive total
                      totalAmount: cart.totalPriceWithVat,
                    ),
                  ),
                );
              },
              // 10. No more spinner!
              child: const Text('Proceed to Payment'),
            ),
          ),
        ],
      ),
    );
  }
}
















