import 'package:flutter_hbb/common.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MutualFundScreen(),
    const FdCalculatorScreen(),
    const LeadFormScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(key: ValueKey<int>(_selectedIndex), child: _screens[_selectedIndex]),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF334155), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0F172A),
          selectedItemColor: const Color(0xFFF59E0B), // Gold
          unselectedItemColor: const Color(0xFF64748B), // Slate Grey
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined),
              activeIcon: Icon(Icons.trending_up),
              label: 'Mutual Funds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'FD Calc',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail_outlined),
              activeIcon: Icon(Icons.contact_mail),
              label: 'Apply',
            ),
          ],
        ),
      ),
    );
  }
}

// ================= Home Screen =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Namaste,',
                      style: TextStyle(fontSize: 18, color: Color(0xFFF59E0B)),
                    ),
                    const Text(
                      'Welcome to Bharat Gold',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const CircleAvatar(
                backgroundColor: Color(0xFF3B82F6),
                child: Icon(Icons.person, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 25),
          // Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Maximum Returns, Minimum Effort',
                  style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fixed Deposits compounding at 7.75% p.a.',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    final dashboard = context.findAncestorStateOfType<_DashboardScreenState>();
                    dashboard?.setState(() {
                      dashboard._selectedIndex = 2; // Jump to FD Calculator
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Calculate Returns'),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Our Premium Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 15),
          // Products Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
            children: [
              _buildProductCard(
                context,
                icon: Icons.trending_up,
                title: 'Mutual Funds',
                desc: 'Invest in top performing mutual funds with AMFI live data.',
                onTap: () {
                  final dashboard = context.findAncestorStateOfType<_DashboardScreenState>();
                  dashboard?.setState(() {
                    dashboard._selectedIndex = 1;
                  });
                },
              ),
              _buildProductCard(
                context,
                icon: Icons.savings,
                title: 'Fixed Deposit',
                desc: 'Secure your future with high-yield quarterly compounding.',
                onTap: () {
                  final dashboard = context.findAncestorStateOfType<_DashboardScreenState>();
                  dashboard?.setState(() {
                    dashboard._selectedIndex = 2;
                  });
                },
              ),
              _buildProductCard(
                context,
                icon: Icons.monetization_on,
                title: 'Quick Loans',
                desc: 'Secure paperless loans at competitive interest rates.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuickApplyDetails(product: 'Loans', detail: 'Instant Loans up to ₹5 Lakhs'),
                    ),
                  );
                },
              ),
              _buildProductCard(
                context,
                icon: Icons.security,
                title: 'Insurance',
                desc: 'Protect your loved ones with customized life & health coverage.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuickApplyDetails(product: 'Insurance', detail: 'Comprehensive Health & Life Cover'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Customer ID: ${gFFI.serverModel.serverId.text.replaceAll(' ', '')}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, {required IconData icon, required String title, required String desc, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF334155), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: const Color(0xFFF59E0B), size: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Ext helper for Typography
extension ContextTextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  TextStyle themeText(String style) {
    if (style == 'headlineMedium') return textTheme.headlineMedium ?? const TextStyle();
    if (style == 'titleLarge') return textTheme.titleLarge ?? const TextStyle();
    return textTheme.bodyMedium ?? const TextStyle();
  }
}

// Simple Detail Screen for quick products
class QuickApplyDetails extends StatelessWidget {
  final String product;
  final String detail;
  const QuickApplyDetails({super.key, required this.product, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.stars, color: const Color(0xFFF59E0B), size: 80),
            const SizedBox(height: 20),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Easy paperless application with minimum documentation and fast processing.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                launchUrl(Uri.parse('https://wa.me/48729523086?text=I+want+to+invest+in+a+mutual+fund'), mode: LaunchMode.externalApplication);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Apply Now via WhatsApp'),
            )
          ],
        ),
      ),
    );
  }
}

// ================= Mutual Funds Screen =================
class MutualFundScreen extends StatefulWidget {
  const MutualFundScreen({super.key});

  @override
  State<MutualFundScreen> createState() => _MutualFundScreenState();
}

class _MutualFundScreenState extends State<MutualFundScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchFunds(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final response = await http.get(Uri.parse('https://api.mfapi.in/mf/search?q=$query')).timeout(const Duration(seconds:10));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          _searchResults = decoded;
          _isLoading = false;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load funds. Please try again.';
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  void _showFundDetail(String schemeCode) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFF59E0B)),
      ),
    );

    try {
      final response = await http.get(Uri.parse('https://api.mfapi.in/mf/$schemeCode')).timeout(const Duration(seconds:10));
      Navigator.pop(context); // Pop loading dialog

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final meta = decoded['meta'];
        final data = decoded['data'] as List<dynamic>;
        final latestNav = data.isNotEmpty ? data.first['nav'] : 'N/A';
        final latestDate = data.isNotEmpty ? data.first['date'] : 'N/A';

        if (!mounted) return;
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF1E293B),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    meta['scheme_name'] ?? 'Mutual Fund Details',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  _buildDetailRow('Scheme Category', meta['scheme_category'] ?? 'N/A'),
                  _buildDetailRow('Scheme House', meta['fund_house'] ?? 'N/A'),
                  _buildDetailRow('Scheme Code', schemeCode),
                  const Divider(color: Color(0xFF334155), height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Latest NAV', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text(
                        '₹$latestNav',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                      ),
                    ],
                  ),
                  Text('As of $latestDate', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)), textAlign: TextAlign.right),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet
                      final dashboard = context.findAncestorStateOfType<_DashboardScreenState>();
                      dashboard?.setState(() {
                        dashboard._selectedIndex = 3; // Navigate to Lead Form
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Apply / Invest in this Fund'),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        throw Exception();
      }
    } catch (_) {
      Navigator.pop(context); // safety pop
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load fund details.')),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mutual Funds Explorer',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search over 10,000+ mutual fund schemes via real-time AMFI data',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter fund name (e.g. SBI, HDFC)',
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
                      onPressed: () => _searchController.clear(),
                    ),
                  ),
                  onSubmitted: (val) => _searchFunds(val),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _searchFunds(_searchController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Icon(Icons.search),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFF59E0B)),
              ),
            )
          else if (_errorMessage.isNotEmpty)
            Expanded(
              child: Center(
                child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent)),
              ),
            )
          else if (_searchResults.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Start searching to view mutual fund schemes.', style: TextStyle(color: Color(0xFF64748B))),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final fund = _searchResults[index];
                  return Card(
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        fund['schemeName'] ?? 'Unknown Fund',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        'Scheme Code: ${fund['schemeCode']}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFF59E0B)),
                      onTap: () => _showFundDetail(fund['schemeCode'].toString()),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}

// ================= FD Calculator Screen =================
class FdCalculatorScreen extends StatefulWidget {
  const FdCalculatorScreen({super.key});

  @override
  State<FdCalculatorScreen> createState() => _FdCalculatorScreenState();
}

class _FdCalculatorScreenState extends State<FdCalculatorScreen> {
  double _principal = 100000;
  double _rate = 7.5;
  double _tenure = 3;

  @override
  Widget build(BuildContext context) {
    // Indian FDs compound quarterly: A = P * (1 + r/4)^(4*t)
    double rDecimal = _rate / 100;
    double maturityAmount = _principal * pow((1 + rDecimal / 4), 4 * _tenure);
    double interestEarned = maturityAmount - _principal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FD Returns Calculator',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Compute returns instantly with standard quarterly compounding',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 25),
          // Output Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF334155), width: 0.5),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Maturity Amount', style: TextStyle(fontSize: 15, color: Color(0xFF94A3B8))),
                    Text(
                      '₹${maturityAmount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF334155), height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Principal Amount', style: TextStyle(fontSize: 14, color: Colors.white70)),
                    Text('₹${_principal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Interest Earned', style: TextStyle(fontSize: 14, color: Colors.white70)),
                    Text(
                      '₹${interestEarned.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Principal Slider
          Text(
            'Investment Principal: ₹${_principal.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Slider(
            value: _principal,
            min: 10000,
            max: 1000000,
            divisions: 99,
            activeColor: const Color(0xFF3B82F6),
            inactiveColor: const Color(0xFF1E293B),
            onChanged: (val) {
              setState(() {
                _principal = val;
              });
            },
          ),
          // Rate Slider
          Text(
            'Interest Rate: ${_rate.toStringAsFixed(2)}% p.a.',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Slider(
            value: _rate,
            min: 5.0,
            max: 12.0,
            divisions: 28,
            activeColor: const Color(0xFF3B82F6),
            inactiveColor: const Color(0xFF1E293B),
            onChanged: (val) {
              setState(() {
                _rate = val;
              });
            },
          ),
          // Tenure Slider
          Text(
            'Tenure: ${_tenure.toStringAsFixed(1)} Years',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Slider(
            value: _tenure,
            min: 1.0,
            max: 10.0,
            divisions: 18,
            activeColor: const Color(0xFF3B82F6),
            inactiveColor: const Color(0xFF1E293B),
            onChanged: (val) {
              setState(() {
                _tenure = val;
              });
            },
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final dashboard = context.findAncestorStateOfType<_DashboardScreenState>();
                dashboard?.setState(() {
                  dashboard._selectedIndex = 3; // Navigate to Lead Form
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Open Fixed Deposit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}

// ================= Lead Capture Form =================
class LeadFormScreen extends StatefulWidget {
  const LeadFormScreen({super.key});

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedProduct = 'Mutual Funds';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = Uri.encodeComponent(_nameController.text.trim());
      final phone = Uri.encodeComponent(_phoneController.text.trim());
      final amount = Uri.encodeComponent(_amountController.text.trim());
      final product = Uri.encodeComponent(_selectedProduct);

      // WhatsApp link formatting
      // Standard Support number: we can use a standard placeholder like +48729523086
      const supportNumber = '48729523086';
      final message = 'Hi%20Bharat%20Gold%20Finance%2C%20I%20am%20interested%20in%20your%20products.%0A%0A'
          'Name%3A%20$name%0APhone%3A%20$phone%0A'
          'Product%3A%20$product%0A'
          'Desired%20Amount%3A%20%E2%82%B9$amount';

      final webUrl = Uri.parse('https://wa.me/$supportNumber?text=$message');

      try {
        if (await canLaunchUrl(webUrl)) {
          await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch URL';
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to redirect. Opening WhatsApp web instead.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apply for Assistance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fill out details to connect with a financial agent instantly via WhatsApp.',
              style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 25),
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter your name';
                if (val.trim().length < 3) return 'Name must be at least 3 characters';
                return null;
              },
            ),
            const SizedBox(height: 18),
            // Phone Field
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter your phone number';
                if (val.trim().length != 10 || int.tryParse(val) == null) {
                  return 'Please enter a valid 10-digit mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            // Amount Field
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Investment / Loan Amount (₹)',
                prefixIcon: const Icon(Icons.currency_rupee, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter desired amount';
                if (double.tryParse(val) == null || double.parse(val) <= 0) {
                  return 'Please enter a valid positive number';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            // Product Dropdown
            DropdownButtonFormField<String>(
              value: _selectedProduct,
              decoration: InputDecoration(
                labelText: 'Preferred Financial Product',
                prefixIcon: const Icon(Icons.business_center, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              items: ['Mutual Funds', 'Fixed Deposit', 'Loans', 'Insurance']
                  .map((product) => DropdownMenuItem(
                        value: product,
                        child: Text(product),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedProduct = val;
                  });
                }
              },
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.chat_bubble),
                    SizedBox(width: 10),
                    Text(
                      'Connect via WhatsApp',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class _CustomerIdBar extends StatefulWidget {
  const _CustomerIdBar({Key? key}) : super(key: key);
  @override
  State<_CustomerIdBar> createState() => _CustomerIdBarState();
}

class _CustomerIdBarState extends State<_CustomerIdBar> {
  Timer? _timer;
  String _id = '';

  @override
  void initState() {
    super.initState();
    _fetchId();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _fetchId());
  }

  void _fetchId() async {
    await gFFI.serverModel.fetchID();
    final text = gFFI.serverModel.serverId.text;
    if (text.isNotEmpty && !text.contains('.') && mounted) {
      setState(() => _id = text.replaceAll(' ', ''));
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _id.isEmpty ? 'Customer ID: loading...' : 'Customer ID: ' + _id,
      style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
    );
  }
}