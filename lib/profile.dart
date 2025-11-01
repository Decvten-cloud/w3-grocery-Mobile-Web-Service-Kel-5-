import 'package:flutter/material.dart';

// --- IMPORT DIPERBAIKI ---
// (Path ini sekarang mengarah ke lib/splash_screen.dart)
import '../splash_screen.dart';

// PROFILE
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onOpenOrders});
  final VoidCallback onOpenOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: const SizedBox(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.apps_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const _UserHeader(),
          const SizedBox(height: 12),
          _MenuTile(
            icon: Icons.receipt_long_rounded,
            text: 'My Orders',
            onTap: onOpenOrders,
          ),
          _MenuTile(
            icon: Icons.account_balance_wallet_rounded,
            text: 'Payments & Wallet',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentsPage()),
              );
            },
          ),
          _MenuTile(
            icon: Icons.reviews_rounded,
            text: 'Ratings & Review',
            onTap: () {
              _showRatingsSheet(context);
            },
          ),
          _MenuTile(
            icon: Icons.notifications_active_rounded,
            text: 'Notification',
            trailing: const _Badge(number: 1),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },
          ),
          _MenuTile(
            icon: Icons.location_on_rounded,
            text: 'Delivery Address',
            onTap: () {
              _showSelectLocationSheet(context);
            },
          ),
          _MenuTile(
            icon: Icons.article_rounded,
            text: 'Blog & Blog Detail',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BlogPage()),
              );
            },
          ),
          const SizedBox(height: 6),
          _MenuTile(
            icon: Icons.logout_rounded,
            text: 'LogOut',
            isDestructive: true,
            onTap: () {
              // --- FUNGSI LOGOUT ---
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SplashScreen()),
                (Route<dynamic> route) => false,
              );
              // --- AKHIR FUNGSI LOGOUT ---
            },
          ),
        ],
      ),
    );
  }
}

// MODIFIKASI: _UserHeader
class _UserHeader extends StatelessWidget {
  const _UserHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [Colors.green.shade800, Colors.green.shade400]),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=5')),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'James Hawkins\njameshawkins@mail.com\n8854760544',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
              ),
            ],
          ),
          const Divider(color: Colors.white54, height: 20),
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: Colors.white70),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '324002\nUK - 324002',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  _showSelectLocationSheet(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Change'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget _MenuTile
class _MenuTile extends StatelessWidget {
  const _MenuTile(
      {required this.icon,
      required this.text,
      this.trailing,
      this.isDestructive = false,
      this.onTap});
  final IconData icon;
  final String text;
  final Widget? trailing;
  final bool isDestructive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? Colors.red : Theme.of(context).colorScheme.primary;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(text,
            style: TextStyle(
                color: isDestructive ? Colors.red : null,
                fontWeight: FontWeight.w600)),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

// Widget _Badge
class _Badge extends StatelessWidget {
  const _Badge({required this.number});
  final int number;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: cs.primary, borderRadius: BorderRadius.circular(999)),
      child: Text('$number',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}

// ----------------------------------------------
// --- HALAMAN & MODAL (Sisa kode dari Anda) ---
// ----------------------------------------------

// (Semua kelas Halaman dan fungsi _showModal...
//  dari file Anda sebelumnya akan ada di sini)

// Halaman Edit Profile
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=5'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Change profile photo'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(decoration: const InputDecoration(labelText: 'Name')),
          TextFormField(decoration: const InputDecoration(labelText: 'Username')),
          TextFormField(decoration: const InputDecoration(labelText: 'Website')),
          TextFormField(decoration: const InputDecoration(labelText: 'Bio')),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            child: const Text('Switch to professional account'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Create avatar'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Personal information settings'),
          ),
        ],
      ),
    );
  }
}

// Halaman Notifikasi
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Today', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildNotificationTile(
            img: 'https://i.pravatar.cc/150?img=12',
            text:
                '@davidjr rmention you in a comment: @joviedan Lol\n"Lorem ipsum dolor sit amet..."',
            time: '5h ago',
          ),
          _buildNotificationTile(
            img: 'https://i.pravatar.cc/150?img=32',
            text: '@henry and 5 others liked your message',
            time: '6h ago',
          ),
          const SizedBox(height: 24),
          Text('This Year', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildNotificationTile(
            img: 'https://i.pravatar.cc/150?img=12',
            text:
                '@davidjr rmention you in a comment: @joviedan Lol\n"Lorem ipsum dolor sit amet..."',
            time: '5h ago',
          ),
          _buildNotificationTile(
            img: 'https://i.pravatar.cc/150?img=33',
            text: '@lucas rmention you in a story',
            time: '5h ago',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
      {required String img, required String text, required String time}) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(img)),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: text),
            TextSpan(
              text: ' $time',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}

// Halaman Payments
class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search By Bank Name',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Select Payment mode',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Cards'),
              subtitle: const Text('Add Credit, Debit & ATM Cards'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showAddCardSheet(context);
              },
            ),
          ),
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.payment),
              title: const Text('UPI'),
              subtitle: const Text('Pay via UPI'),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Link via UPI'),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your UPI ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green.shade700,
                          ),
                          child: const Text('Continue'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.lock, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Your UPI ID Will be encrypted and is 100% safe with us.',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Wallet'),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Link Your Wallet'),
                      const SizedBox(height: 8),
                      TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '91',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              'https://flagcdn.com/w20/in.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green.shade700,
                          ),
                          child: const Text('Continue'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Netbanking'),
              children: [
                ListTile(title: const Text('Bank of India'), onTap: () {}),
                ListTile(title: const Text('Canara Bank'), onTap: () {}),
                ListTile(title: const Text('HDFC Bank'), onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman Blog List
class BlogPage extends StatelessWidget {
  const BlogPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBlogCard(context, true),
          _buildBlogCard(context, false),
          _buildBlogCard(context, false),
          _buildBlogCard(context, false),
        ],
      ),
    );
  }

  Widget _buildBlogCard(BuildContext context, bool isFeatured) {
    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFeatured)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1780&q=80',
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
            ),
          ),
        if (!isFeatured)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=500&q=80',
              fit: BoxFit.cover,
              height: 80,
              width: 80,
            ),
          ),
        const SizedBox(height: 8, width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The best food Of this month.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (!isFeatured)
              const Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            const Text(
              '2 hours ago • 1 min read • By Emile',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const BlogDetailPage()));
        },
        child: isFeatured
            ? cardContent
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                cardContent.children[0], // Gambar
                const SizedBox(width: 12),
                Expanded(
                  child: cardContent.children[2], // Column Teks
                ),
              ]),
      ),
    );
  }
}

// Halaman Blog Detail
class BlogDetailPage extends StatelessWidget {
  const BlogDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog Detail')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1780&q=80',
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'The best food Of this month.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage:
                                NetworkImage('https://i.pravatar.cc/150?img=32'),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'By Emily • 2 hours ago • 1 min read',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's So Trendy About Food That Everyone Went Crazy Over It?",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Vegetables, including lettuce, corn, tomatoes, onions, celery, cucumbers, mushrooms, and more are also sold at many grocery stores, and are purchased similarly to the way that fruits are. Grocery stores typically stock more vegetables than fruit at any given time, as vegetables remain fresh longer than fruits do, generally speaking.\n\nDonec sit amet eros non massa vehicula porta. Nulla facilisi. Suspendisse ac aliquet nisl, lacinia mattis magna. Praesent quis consectetur neque, sed viverra neque. Mauris ultrices massa purus, fermentum ornare magna gravida vitae. Nulla sit amet est a enim porta gravida.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modal "Select a location"
void _showSelectLocationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select a location',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for area, street name..',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  backgroundColor:
                      Theme.of(ctx).colorScheme.primary.withOpacity(0.1),
                  foregroundColor: Theme.of(ctx).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },
  );
}

// Modal "Ratings & Review"
void _showRatingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Text(
              'What do you think?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text(
                'Please give me your rating by clicking on the\nstars below.',
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                  (index) => const Icon(Icons.star_border,
                      size: 40, color: Colors.grey)),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Tell us about your experience.',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('SUBMIT'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },
  );
}

// Modal "Add Card"
void _showAddCardSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ADD CARD',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Card holder Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '**** **** **** ****',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Security Code',
                      hintText: '...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Added'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },
  );
}