import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetail({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hair = user['hair'];
    final address = user['address'];
    final company = user['company'];
    final bank = user['bank'];
    final crypto = user['crypto'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${user['firstName']} ${user['lastName']}'),
        backgroundColor: Colors.blue,
        elevation: 3,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar and Name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user['image']),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${user['firstName']} ${user['lastName']}',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user['email'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sections
            _buildSectionCard(context, 'Personal Info', [
              _infoRow(Icons.person, 'Username', user['username']),
              _infoRow(Icons.cake, 'Birth Date', user['birthDate']),
              _infoRow(Icons.bloodtype, 'Blood Group', user['bloodGroup']),
              _infoRow(Icons.male, 'Gender', user['gender']),
              _infoRow(Icons.height, 'Height', '${user['height']} cm'),
              _infoRow(Icons.monitor_weight, 'Weight', '${user['weight']} kg'),
            ]),

            _buildSectionCard(context, 'Appearance', [
              _infoRow(Icons.remove_red_eye, 'Eye Color', user['eyeColor']),
              _infoRow(Icons.palette, 'Hair Color', hair['color']),
              _infoRow(Icons.style, 'Hair Type', hair['type']),
            ]),

            _buildSectionCard(context, 'Contact Info', [
              _infoRow(Icons.phone, 'Phone', user['phone']),
              _infoRow(Icons.location_on, 'Address', address['address']),
              _infoRow(Icons.map, 'City/State', '${address['city']}, ${address['state']}'),
              _infoRow(Icons.public, 'Country', address['country']),
              _infoRow(Icons.mail_outline, 'Postal Code', address['postalCode']),
            ]),

            _buildSectionCard(context, 'Company', [
              _infoRow(Icons.business, 'Name', company['name']),
              _infoRow(Icons.group, 'Department', company['department']),
              _infoRow(Icons.work, 'Title', company['title']),
            ]),

            _buildSectionCard(context, 'Banking Info', [
              _infoRow(Icons.credit_card, 'Card Number', bank['cardNumber']),
              _infoRow(Icons.payment, 'Card Type', bank['cardType']),
              _infoRow(Icons.calendar_today, 'Expires', bank['cardExpire']),
              _infoRow(Icons.attach_money, 'Currency', bank['currency']),
              _infoRow(Icons.abc, 'IBAN', bank['iban']),
            ]),

            _buildSectionCard(context, 'Crypto Wallet', [
              _infoRow(Icons.currency_bitcoin, 'Coin', crypto['coin']),
              _infoRow(Icons.wallet, 'Wallet', crypto['wallet']),
              _infoRow(Icons.network_wifi, 'Network', crypto['network']),
            ]),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Colors.grey[900]!, Colors.grey[850]!]
                : [Colors.white, Colors.blue[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 13)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}