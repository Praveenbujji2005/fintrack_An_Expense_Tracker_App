import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const FinTrack());
}

class FinTrack extends StatefulWidget {
  const FinTrack({super.key});

  @override
  State<FinTrack> createState() => _FinTrackState();
}

class _FinTrackState extends State<FinTrack> {
  bool isDark = true;
  bool showLogin = true;

  void toggleTheme() {
    HapticFeedback.selectionClick();
    setState(() => isDark = !isDark);
  }

  void toggleAuth() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: showLogin
          ? LoginScreen(toggleTheme: toggleTheme, isDark: isDark, onToggleAuth: toggleAuth)
          : SignupScreen(toggleTheme: toggleTheme, isDark: isDark, onToggleAuth: toggleAuth),
    );
  }
}

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final IconData icon;
  final String month;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.month,
  });
}

// ---------------- MODERN AUTHENTICATION SCREENS ----------------

class LoginScreen extends StatefulWidget {
  final Function toggleTheme;
  final Function onToggleAuth;
  final bool isDark;

  const LoginScreen({super.key, required this.toggleTheme, required this.isDark, required this.onToggleAuth});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget glassBox(Widget child) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: BoxDecoration(
              color: widget.isDark ? Colors.white.withOpacity(.05) : Colors.black.withOpacity(.03),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(.1)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  InputDecoration customInput(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 20, color: Colors.blueAccent),
      hintText: hint,
      filled: true,
      fillColor: widget.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: CircleAvatar(radius: 150, backgroundColor: Colors.blueAccent.withOpacity(0.2)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: glassBox(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "FinTrack Pro",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
                    ),
                    const SizedBox(height: 8),
                    const Text("Welcome back, you've been missed!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 40),
                    TextField(controller: emailController, decoration: customInput("Email Address", Icons.email_outlined)),
                    const SizedBox(height: 16),
                    TextField(controller: passwordController, obscureText: true, decoration: customInput("Password", Icons.lock_outline_rounded)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: () {}, child: const Text("Forgot Password?", style: TextStyle(fontSize: 12))),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                            HapticFeedback.heavyImpact();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter email and password")));
                            return;
                          }
                          HapticFeedback.mediumImpact();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen(
                                  toggleTheme: widget.toggleTheme,
                                  isDark: widget.isDark,
                                  onLogout: widget.onToggleAuth
                              ))
                          );
                        },
                        child: const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => widget.onToggleAuth(),
                      child: RichText(
                        text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: widget.isDark ? Colors.white70 : Colors.black87),
                            children: const [TextSpan(text: "Register Now", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  final Function toggleTheme;
  final Function onToggleAuth;
  final bool isDark;

  const SignupScreen({super.key, required this.toggleTheme, required this.isDark, required this.onToggleAuth});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget glassBox(Widget child) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: BoxDecoration(
              color: widget.isDark ? Colors.white.withOpacity(.05) : Colors.black.withOpacity(.03),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(.1)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: -100,
            left: -50,
            child: CircleAvatar(radius: 150, backgroundColor: Colors.purpleAccent.withOpacity(0.15)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: glassBox(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Get Started", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
                    const SizedBox(height: 8),
                    const Text("Create an account to track your growth", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 30),
                    _buildField("Full Name", Icons.person_outline, nameController),
                    const SizedBox(height: 16),
                    _buildField("Email Address", Icons.email_outlined, emailController),
                    const SizedBox(height: 16),
                    _buildField("Password", Icons.lock_outline_rounded, passwordController, obscure: true),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
                            HapticFeedback.heavyImpact();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
                            return;
                          }
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen(
                                  toggleTheme: widget.toggleTheme,
                                  isDark: widget.isDark,
                                  onLogout: widget.onToggleAuth
                              ))
                          );
                        },
                        child: const Text("Create Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => widget.onToggleAuth(),
                      child: RichText(
                        text: TextSpan(
                            text: "Already a member? ",
                            style: TextStyle(color: widget.isDark ? Colors.white70 : Colors.black87),
                            children: const [TextSpan(text: "Login", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, TextEditingController controller, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: Colors.blueAccent),
        hintText: hint,
        filled: true,
        fillColor: widget.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}

// ---------------- MAIN HOME DASHBOARD ----------------

class HomeScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDark;
  final Function onLogout;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  List<TransactionModel> transactions = [];
  String selectedMonth = "April";

  final months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  final List<String> suggestions = ["Rent", "Salary", "Food", "Groceries", "Fuel", "Gym"];

  List<TransactionModel> get filtered => transactions.where((e) => e.month == selectedMonth).toList();
  double get income => filtered.where((t) => t.isIncome).fold(0, (s, e) => s + e.amount);
  double get expense => filtered.where((t) => !t.isIncome).fold(0, (s, e) => s + e.amount);
  double get balance => income - expense;

  void deleteTransaction(TransactionModel item) {
    HapticFeedback.vibrate();
    setState(() => transactions.removeWhere((t) => t.id == item.id));
  }

  void addTransaction(String title, double amount, bool isIncome, IconData icon) {
    HapticFeedback.lightImpact();
    setState(() {
      transactions.insert(
        0,
        TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          amount: amount,
          isIncome: isIncome,
          icon: icon,
          month: selectedMonth,
        ),
      );
    });
  }

  void openAddDialog(bool isIncome) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isIncome ? "Add Income" : "Add Expense"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(hintText: "Title")),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: suggestions.map((s) => Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: ActionChip(
                        label: Text(s, style: const TextStyle(fontSize: 12)),
                        onPressed: () => setDialogState(() => titleController.text = s),
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(controller: amountController, decoration: const InputDecoration(hintText: "Amount"), keyboardType: TextInputType.number),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  addTransaction(titleController.text, double.tryParse(amountController.text) ?? 0, isIncome, isIncome ? Icons.account_balance_wallet : Icons.shopping_cart);
                  Navigator.pop(ctx);
                },
                child: const Text("Save"),
              )
            ],
          );
        },
      ),
    );
  }

  Widget dashboard() {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedMonth,
          items: months.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
          onChanged: (v) => setState(() => selectedMonth = v!),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text("Current Balance", style: TextStyle(color: Colors.grey)),
                Text("₹$balance", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Income: ₹$income", style: const TextStyle(color: Colors.green)),
                    Text("Expense: ₹$expense", style: const TextStyle(color: Colors.orange)),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text("No records for this month"))
              : ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (c, i) {
              final t = filtered[i];
              return Dismissible(
                key: Key(t.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) => deleteTransaction(t),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: t.isIncome ? Colors.green.withOpacity(.1) : Colors.red.withOpacity(.1),
                    child: Icon(t.icon, color: t.isIncome ? Colors.green : Colors.red),
                  ),
                  title: Text(t.title),
                  subtitle: Text(t.month),
                  trailing: Text("₹${t.amount}", style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(onPressed: () => openAddDialog(true), icon: const Icon(Icons.add), label: const Text("Income"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green.withOpacity(.2), foregroundColor: Colors.green)),
              ElevatedButton.icon(onPressed: () => openAddDialog(false), icon: const Icon(Icons.remove), label: const Text("Expense"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(.2), foregroundColor: Colors.red)),
            ],
          ),
        )
      ],
    );
  }

  Widget analyticsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Financial Analytics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: filtered.isEmpty
                ? const Center(child: Text("Add transactions to see analytics"))
                : PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 45,
                sections: [
                  PieChartSectionData(
                    value: income == 0 ? 1 : income,
                    color: Colors.green,
                    title: "Income",
                    radius: 55,
                    titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  PieChartSectionData(
                    value: expense == 0 ? 1 : expense,
                    color: Colors.red,
                    title: "Expense",
                    radius: 55,
                    titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDark ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _rowItem("Total Transactions", "${filtered.length}"),
                const Divider(),
                _rowItem("Highest Expense", filtered.isEmpty ? "₹0" : "₹${filtered.where((t) => !t.isIncome).fold(0.0, (max, e) => e.amount > max ? e.amount : max)}"),
                const Divider(),
                _rowItem("Savings Rate", income == 0 ? "0%" : "${((balance / income) * 100).toStringAsFixed(1)}%"),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text("Income vs Expense", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                barGroups: [
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: income, color: Colors.green, width: 22)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: expense, color: Colors.red, width: 22)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget profileView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: widget.isDark ? Colors.white.withOpacity(.05) : Colors.black.withOpacity(.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(.08)),
                ),
                child: const Column(
                  children: [
                    const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.transparent, // Background transparent so the image fills the circle
                        // THIS IS THE LINE THAT ADDS YOUR SAVED PIC
                        backgroundImage: AssetImage("assets/images/developer_pic.png")),
                    SizedBox(height: 15),
                    Text("Praveen Kumar M", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("praveenmanjunatha.online@gmail.com", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text("Settings & Support", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 10),
          _settingsTile(Icons.security, "Security", "Password & biometrics"),
          _settingsTile(Icons.notifications, "Notifications", "Reminders & alerts"),
          _settingsTile(Icons.contact_support_outlined, "Contact Us", "Get help or report a bug"),
          _settingsTile(Icons.color_lens, "Theme", "Dark & Light mode"),
          const SizedBox(height: 25),
          const Text("Developer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDark ? Colors.white.withOpacity(.03) : Colors.black.withOpacity(.03),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent, // Background transparent so the image fills the circle
                    // THIS IS THE LINE THAT ADDS YOUR SAVED PIC
                    backgroundImage: AssetImage("assets/images/developer_pic.png")),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Praveen Kumar M", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const Text("Full-stack Flutter Developer", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          _devSocialIcon(Icons.code, "GitHub"),
                          const SizedBox(width: 10),
                          _devSocialIcon(Icons.link, "Portfolio"),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.heavyImpact();
                widget.onLogout();
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(.1),
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _devSocialIcon(IconData icon, String label) {
    return InkWell(
      onTap: () => HapticFeedback.lightImpact(),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.blueAccent),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.blueAccent, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.blue.withOpacity(.1), child: Icon(icon, color: Colors.blue)),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => HapticFeedback.selectionClick(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;
    if (page == 0) currentBody = dashboard();
    else if (page == 1) currentBody = analyticsView();
    else currentBody = profileView();

    return Scaffold(
      appBar: AppBar(
        title: const Text("FinTrack Pro"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.toggleTheme(),
          )
        ],
      ),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: currentBody)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: (i) => setState(() => page = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}