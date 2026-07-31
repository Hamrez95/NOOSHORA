import 'package:flutter/material.dart';
import 'demo_main.dart' as demo;

void main() => runApp(const NooshoraProfessionalDemoApp());

const _forest = Color(0xFF214A34);
const _forestSoft = Color(0xFF3F704E);
const _canvas = Color(0xFFF4F6F1);
const _line = Color(0xFFE0E6DE);
const _ink = Color(0xFF1D3125);
const _muted = Color(0xFF718077);
const _sand = Color(0xFFF6E6D4);
const _sage = Color(0xFFE0ECD7);
const _lilac = Color(0xFFE9E1F1);
const _rose = Color(0xFFF3DDD8);

class NooshoraProfessionalDemoApp extends StatelessWidget {
  const NooshoraProfessionalDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _forest,
      brightness: Brightness.light,
      surface: Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مدیریت نوشورا · نسخه نمایشی حرفه‌ای',
      locale: const Locale('fa'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: _canvas,
        fontFamily: 'Tahoma',
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: _ink,
              displayColor: _ink,
              fontFamily: 'Tahoma',
            ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(22)),
            side: BorderSide(color: _line),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _forestSoft, width: 1.4),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _forest,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 46),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _forest,
            minimumSize: const Size(0, 44),
            side: const BorderSide(color: Color(0xFFCCD8CE)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          ),
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: ProfessionalDemoGate(),
      ),
    );
  }
}

class ProfessionalDemoGate extends StatefulWidget {
  const ProfessionalDemoGate({super.key});

  @override
  State<ProfessionalDemoGate> createState() => _ProfessionalDemoGateState();
}

class _ProfessionalDemoGateState extends State<ProfessionalDemoGate> {
  bool _authenticated = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      child: _authenticated
          ? ProfessionalAdminShell(
              key: const ValueKey('admin'),
              onLogout: () => setState(() => _authenticated = false),
            )
          : DemoLoginPage(
              key: const ValueKey('login'),
              onAuthenticated: () => setState(() => _authenticated = true),
            ),
    );
  }
}

class DemoLoginPage extends StatefulWidget {
  const DemoLoginPage({super.key, required this.onAuthenticated});

  final VoidCallback onAuthenticated;

  @override
  State<DemoLoginPage> createState() => _DemoLoginPageState();
}

class _DemoLoginPageState extends State<DemoLoginPage> {
  static const _demoEmail = 'admin@nooshora.ir';
  static const _demoPassword = 'Nooshora1405';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    _emailController.text = _demoEmail;
    _passwordController.text = _demoPassword;
    setState(() => _error = null);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    if (_emailController.text.trim() == _demoEmail &&
        _passwordController.text == _demoPassword) {
      widget.onAuthenticated();
      return;
    }

    setState(() {
      _loading = false;
      _error = 'برای ورود به نسخه نمایشی از اطلاعات نمایش‌داده‌شده استفاده کن.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          return Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFFF4F7EF), Color(0xFFF9EEDF)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -180,
                right: -90,
                child: _SoftCircle(size: 430, color: Color(0xFFDCEACC)),
              ),
              Positioned(
                bottom: -170,
                left: -90,
                child: _SoftCircle(size: 390, color: Color(0xFFF0D6C2)),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(22),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1110),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .92),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.white),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1B294333),
                              blurRadius: 55,
                              offset: Offset(0, 26),
                            ),
                          ],
                        ),
                        child: wide
                            ? Row(
                                children: [
                                  const Expanded(child: _LoginStoryPanel()),
                                  Expanded(child: _LoginFormPanel(
                                    formKey: _formKey,
                                    emailController: _emailController,
                                    passwordController: _passwordController,
                                    obscure: _obscure,
                                    loading: _loading,
                                    error: _error,
                                    onToggleObscure: () => setState(() => _obscure = !_obscure),
                                    onFillDemo: _fillDemoCredentials,
                                    onSubmit: _submit,
                                  )),
                                ],
                              )
                            : Column(
                                children: [
                                  const _LoginStoryPanel(compact: true),
                                  _LoginFormPanel(
                                    formKey: _formKey,
                                    emailController: _emailController,
                                    passwordController: _passwordController,
                                    obscure: _obscure,
                                    loading: _loading,
                                    error: _error,
                                    onToggleObscure: () => setState(() => _obscure = !_obscure),
                                    onFillDemo: _fillDemoCredentials,
                                    onSubmit: _submit,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: .66)),
    );
  }
}

class _LoginStoryPanel extends StatelessWidget {
  const _LoginStoryPanel({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: compact ? 310 : 650),
      padding: EdgeInsets.all(compact ? 28 : 52),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF193B29), Color(0xFF315F3F)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -45,
            bottom: -55,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: .09), width: 30),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _DemoBrand(light: true),
              SizedBox(height: compact ? 32 : 88),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withValues(alpha: .12)),
                ),
                child: const Text(
                  'نسخه نمایشی حرفه‌ای · داده محلی',
                  style: TextStyle(color: Color(0xFFD5E5C6), fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 17),
              Text(
                'فروش، سفارش و انبار؛\nهمه در یک تصویر روشن.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 30 : 43,
                  height: 1.45,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'این پنل برای نمایش تجربه مدیریتی نوشورا ساخته شده و بدون اتصال به داده، پیامک یا پرداخت واقعی کار می‌کند.',
                style: TextStyle(color: Color(0xFFB9CABC), height: 1.9, fontSize: 11),
              ),
              if (!compact) ...[
                const Spacer(),
                const Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: [
                    _StoryPill(icon: Icons.receipt_long_rounded, label: 'چرخه سفارش'),
                    _StoryPill(icon: Icons.inventory_2_rounded, label: 'کاتالوگ و انتشار'),
                    _StoryPill(icon: Icons.warehouse_rounded, label: 'بچ و موجودی'),
                    _StoryPill(icon: Icons.query_stats_rounded, label: 'گزارش سود'),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StoryPill extends StatelessWidget {
  const _StoryPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: .1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFD6E6C8)),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 9)),
        ],
      ),
    );
  }
}

class _LoginFormPanel extends StatelessWidget {
  const _LoginFormPanel({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.loading,
    required this.error,
    required this.onToggleObscure,
    required this.onFillDemo,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool loading;
  final String? error;
  final VoidCallback onToggleObscure;
  final VoidCallback onFillDemo;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 650),
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 48),
      color: Colors.white,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ورود به پنل مدیریت', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
            const SizedBox(height: 7),
            const Text(
              'برای بررسی تمام بخش‌های دمو وارد حساب مدیر شو.',
              style: TextStyle(color: _muted, fontSize: 11),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F6ED),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFDCE7D7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.science_rounded, size: 17, color: _forestSoft),
                      SizedBox(width: 7),
                      Text('اطلاعات ورود دمو', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const SelectableText('ایمیل: admin@nooshora.ir', style: TextStyle(fontSize: 10)),
                  const SizedBox(height: 4),
                  const SelectableText('رمز: Nooshora1405', style: TextStyle(fontSize: 10)),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: onFillDemo,
                    icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                    label: const Text('پرکردن خودکار'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('ایمیل مدیر', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
            const SizedBox(height: 7),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                hintText: 'admin@nooshora.ir',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'ایمیل را وارد کن.';
                if (!text.contains('@')) return 'فرمت ایمیل درست نیست.';
                return null;
              },
            ),
            const SizedBox(height: 15),
            const Text('رمز عبور', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
            const SizedBox(height: 7),
            TextFormField(
              controller: passwordController,
              obscureText: obscure,
              textDirection: TextDirection.ltr,
              onFieldSubmitted: (_) => loading ? null : onSubmit(),
              decoration: InputDecoration(
                hintText: 'رمز عبور دمو',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: onToggleObscure,
                  icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                ),
              ),
              validator: (value) {
                if ((value ?? '').isEmpty) return 'رمز عبور را وارد کن.';
                if ((value ?? '').length < 8) return 'رمز باید حداقل ۸ نویسه باشد.';
                return null;
              },
            ),
            if (error != null) ...[
              const SizedBox(height: 13),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(color: const Color(0xFFFFEFEA), borderRadius: BorderRadius.circular(12)),
                child: Text(error!, style: const TextStyle(color: Color(0xFF994E3B), fontSize: 9)),
              ),
            ],
            const SizedBox(height: 21),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: loading ? null : onSubmit,
                icon: loading
                    ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.login_rounded),
                label: Text(loading ? 'در حال ورود...' : 'ورود به پنل نمایشی'),
              ),
            ),
            const SizedBox(height: 13),
            const Row(
              children: [
                Icon(Icons.shield_outlined, size: 15, color: _muted),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'این ورود فقط داخل همین نشست مرورگر است و هیچ رمز یا توکنی ذخیره نمی‌شود.',
                    style: TextStyle(color: _muted, fontSize: 8, height: 1.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoBrand extends StatelessWidget {
  const _DemoBrand({this.light = false, this.compact = false});

  final bool light;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final foreground = light ? Colors.white : _ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 39 : 46,
          height: compact ? 39 : 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: light ? const Color(0xFF4F7C57) : _forest,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(5),
            ),
          ),
          child: Text(
            'ن',
            style: TextStyle(color: Colors.white, fontSize: compact ? 19 : 23, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('مدیریت نوشورا', style: TextStyle(color: foreground, fontSize: compact ? 14 : 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(
              'فروش، سفارش و موجودی',
              style: TextStyle(color: light ? const Color(0xFFAFC2B3) : _muted, fontSize: 8),
            ),
          ],
        ),
      ],
    );
  }
}

enum AdminSection { dashboard, orders, products, inventory, reports }

extension AdminSectionMeta on AdminSection {
  String get title => switch (this) {
        AdminSection.dashboard => 'داشبورد',
        AdminSection.orders => 'سفارش‌ها',
        AdminSection.products => 'محصولات',
        AdminSection.inventory => 'انبار و بچ‌ها',
        AdminSection.reports => 'گزارش‌ها',
      };

  String get subtitle => switch (this) {
        AdminSection.dashboard => 'نمای امروز کسب‌وکار',
        AdminSection.orders => 'پرداخت، آماده‌سازی و ارسال',
        AdminSection.products => 'کاتالوگ، انتشار و موجودی',
        AdminSection.inventory => 'سری ورود، بهای خرید و انقضا',
        AdminSection.reports => 'فروش، سود و عملکرد هفتگی',
      };

  IconData get icon => switch (this) {
        AdminSection.dashboard => Icons.space_dashboard_rounded,
        AdminSection.orders => Icons.receipt_long_rounded,
        AdminSection.products => Icons.inventory_2_rounded,
        AdminSection.inventory => Icons.warehouse_rounded,
        AdminSection.reports => Icons.query_stats_rounded,
      };
}

class ProfessionalAdminShell extends StatefulWidget {
  const ProfessionalAdminShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<ProfessionalAdminShell> createState() => _ProfessionalAdminShellState();
}

class _ProfessionalAdminShellState extends State<ProfessionalAdminShell> {
  AdminSection _section = AdminSection.dashboard;
  late List<demo.DemoOrder> _orders = demo.seedOrders();
  late List<demo.DemoProduct> _products = demo.seedProducts();
  late List<demo.DemoBatch> _batches = demo.seedBatches();
  String _search = '';

  void _select(AdminSection section) {
    setState(() {
      _section = section;
      _search = '';
    });
  }

  void _advanceOrder(String id) {
    setState(() {
      _orders = _orders.map((order) {
        if (order.id != id) return order;
        final nextState = switch (order.state) {
          'پرداخت‌شده' => 'در حال آماده‌سازی',
          'در حال آماده‌سازی' => 'ارسال‌شده',
          'ارسال‌شده' => 'تحویل‌شده',
          _ => order.state,
        };
        return order.copyWith(state: nextState);
      }).toList();
    });
    _toast('مرحله سفارش با موفقیت به‌روزرسانی شد.');
  }

  void _toggleProduct(String sku) {
    setState(() {
      _products = _products
          .map((product) => product.sku == sku
              ? product.copyWith(published: !product.published)
              : product)
          .toList();
    });
    _toast('وضعیت انتشار محصول تغییر کرد.');
  }

  Future<void> _showAddProductDialog() async {
    final titleController = TextEditingController();
    final skuController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    final created = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('محصول نمایشی جدید'),
          content: SizedBox(
            width: 470,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'نام محصول')),
                  const SizedBox(height: 11),
                  TextField(controller: skuController, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'SKU')),
                  const SizedBox(height: 11),
                  TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'قیمت فروش (تومان)')),
                  const SizedBox(height: 11),
                  TextField(controller: stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'موجودی بسته')),
                  const SizedBox(height: 11),
                  const Text(
                    'محصول جدید برای جلوگیری از انتشار ناقص، به‌صورت پیش‌نویس ثبت می‌شود.',
                    style: TextStyle(color: _muted, fontSize: 9, height: 1.7),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('انصراف')),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty ||
                    skuController.text.trim().isEmpty ||
                    int.tryParse(priceController.text) == null ||
                    int.tryParse(stockController.text) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('همه فیلدها را با مقدار معتبر تکمیل کن.')));
                  return;
                }
                Navigator.pop(context, true);
              },
              child: const Text('ثبت پیش‌نویس'),
            ),
          ],
        ),
      ),
    );

    if (created == true) {
      setState(() {
        _products = [
          demo.DemoProduct(
            sku: skuController.text.trim().toUpperCase(),
            title: titleController.text.trim(),
            category: 'پیش‌نویس جدید',
            packageLabel: 'بسته ۵۰۰ گرم',
            priceToman: int.parse(priceController.text),
            stock: int.parse(stockController.text),
            published: false,
            icon: 'ن',
          ),
          ..._products,
        ];
      });
      _toast('محصول به‌صورت پیش‌نویس اضافه شد.');
    }

    titleController.dispose();
    skuController.dispose();
    priceController.dispose();
    stockController.dispose();
  }

  void _receiveBatch() {
    final index = _batches.length + 1;
    setState(() {
      _batches = [
        demo.DemoBatch(
          lot: 'LOT-DEMO-${1405 + index}',
          sku: 'PI-AKB-500',
          supplier: 'تأمین‌کننده نمونه',
          remaining: 18,
          unitCostToman: 315000,
          bestBefore: '۱۴۰۶/۰۲/۱۵',
          status: 'تازه‌وارد',
        ),
        ..._batches,
      ];
    });
    _toast('ورود بچ نمایشی در انبار ثبت شد.');
  }

  void _toast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= 1030;
    final tablet = width >= 700;

    final content = switch (_section) {
      AdminSection.dashboard => DashboardPage(
          orders: _orders,
          products: _products,
          batches: _batches,
          onOpenOrders: () => _select(AdminSection.orders),
        ),
      AdminSection.orders => OrdersPage(
          orders: _orders,
          search: _search,
          onSearch: (value) => setState(() => _search = value),
          onAdvance: _advanceOrder,
        ),
      AdminSection.products => ProductsPage(
          products: _products,
          search: _search,
          onSearch: (value) => setState(() => _search = value),
          onToggle: _toggleProduct,
          onAdd: _showAddProductDialog,
        ),
      AdminSection.inventory => InventoryPage(
          batches: _batches,
          onReceive: _receiveBatch,
        ),
      AdminSection.reports => ReportsPage(orders: _orders, products: _products),
    };

    return Scaffold(
      appBar: desktop
          ? null
          : AppBar(
              toolbarHeight: 72,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: const _DemoBrand(compact: true),
              actions: [
                IconButton(onPressed: () => _showNotifications(context), icon: const Icon(Icons.notifications_none_rounded)),
                PopupMenuButton<String>(
                  icon: const CircleAvatar(backgroundColor: _sand, child: Text('ح', style: TextStyle(color: _forest, fontWeight: FontWeight.w900))),
                  onSelected: (value) {
                    if (value == 'logout') widget.onLogout();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'logout', child: Text('خروج از دمو')),
                  ],
                ),
                const SizedBox(width: 8),
              ],
              bottom: const PreferredSize(preferredSize: Size.fromHeight(32), child: _DemoStatusStrip()),
            ),
      bottomNavigationBar: desktop
          ? null
          : NavigationBar(
              height: 70,
              selectedIndex: AdminSection.values.indexOf(_section),
              onDestinationSelected: (index) => _select(AdminSection.values[index]),
              destinations: [
                for (final section in AdminSection.values)
                  NavigationDestination(icon: Icon(section.icon), label: section.title),
              ],
            ),
      body: Row(
        children: [
          if (desktop)
            AdminSidebar(
              section: _section,
              onSelect: _select,
              onLogout: widget.onLogout,
            ),
          Expanded(
            child: Column(
              children: [
                if (desktop)
                  AdminTopBar(
                    section: _section,
                    onNotifications: () => _showNotifications(context),
                    onLogout: widget.onLogout,
                  ),
                Expanded(
                  child: SafeArea(
                    top: !desktop,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        tablet ? 24 : 14,
                        tablet ? 22 : 14,
                        tablet ? 24 : 14,
                        tablet ? 22 : 14,
                      ),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اعلان‌های عملیاتی', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 14),
                _NotificationTile(icon: Icons.inventory_rounded, tone: _sand, title: 'موجودی تخمه کدو کم است', subtitle: '۶ بسته آماده فروش باقی مانده است.'),
                const SizedBox(height: 9),
                _NotificationTile(icon: Icons.timer_outlined, tone: _rose, title: 'یک بچ نزدیک تاریخ مصرف است', subtitle: 'LOT-1405-063 نیازمند بررسی FEFO است.'),
                const SizedBox(height: 9),
                _NotificationTile(icon: Icons.shopping_bag_outlined, tone: _sage, title: 'سفارش NS-1048 پرداخت شده', subtitle: 'آماده انتقال به مرحله آماده‌سازی است.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoStatusStrip extends StatelessWidget {
  const _DemoStatusStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 32,
      alignment: Alignment.center,
      color: const Color(0xFFFFE8CB),
      child: const Text(
        'داده آزمایشی · بدون تراکنش، پیامک یا تغییر دیتابیس واقعی',
        style: TextStyle(color: Color(0xFF80562F), fontSize: 8, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key, required this.section, required this.onSelect, required this.onLogout});

  final AdminSection section;
  final ValueChanged<AdminSection> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 266,
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF19372A),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x19233B2C), blurRadius: 35, offset: Offset(0, 16))],
      ),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(10), child: _DemoBrand(light: true)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .07), borderRadius: BorderRadius.circular(12)),
            child: const Text(
              '● نسخه دمو · داده محلی',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFF0C99D), fontSize: 8, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 20),
          for (final item in AdminSection.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Material(
                color: section == item ? const Color(0xFF3E694B) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onSelect(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 20, color: section == item ? Colors.white : const Color(0xFFAABCAF)),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(color: section == item ? Colors.white : const Color(0xFFB5C4B9), fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (section == item) const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 17),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .06), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const CircleAvatar(backgroundColor: _sand, child: Text('ح', style: TextStyle(color: _forest, fontWeight: FontWeight.w900))),
                const SizedBox(width: 9),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('حمیدرضا', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                      SizedBox(height: 3),
                      Text('مدیر نسخه نمایشی', style: TextStyle(color: Color(0xFF98AA9E), fontSize: 7)),
                    ],
                  ),
                ),
                IconButton(onPressed: onLogout, tooltip: 'خروج', icon: const Icon(Icons.logout_rounded, color: Color(0xFFC3D0C6), size: 19)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminTopBar extends StatelessWidget {
  const AdminTopBar({super.key, required this.section, required this.onNotifications, required this.onLogout});

  final AdminSection section;
  final VoidCallback onNotifications;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      margin: const EdgeInsets.fromLTRB(10, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(section.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(section.subtitle, style: const TextStyle(color: _muted, fontSize: 8)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFF2F6EE), borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.cloud_done_outlined, size: 16, color: _forestSoft),
                SizedBox(width: 6),
                Text('دمو آماده ارائه', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Badge(
            label: const Text('۳'),
            child: IconButton(onPressed: onNotifications, tooltip: 'اعلان‌ها', icon: const Icon(Icons.notifications_none_rounded)),
          ),
          const SizedBox(width: 6),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') onLogout();
            },
            itemBuilder: (_) => const [PopupMenuItem(value: 'logout', child: Text('خروج از دمو'))],
            child: const Row(
              children: [
                CircleAvatar(backgroundColor: _sand, child: Text('ح', style: TextStyle(color: _forest, fontWeight: FontWeight.w900))),
                SizedBox(width: 8),
                Text('حمیدرضا', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({super.key, required this.eyebrow, required this.title, required this.subtitle, this.action});

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 20,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 620,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow, style: const TextStyle(color: _forestSoft, fontSize: 9, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -.5)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: _muted, fontSize: 9, height: 1.7)),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.orders,
    required this.products,
    required this.batches,
    required this.onOpenOrders,
  });

  final List<demo.DemoOrder> orders;
  final List<demo.DemoProduct> products;
  final List<demo.DemoBatch> batches;
  final VoidCallback onOpenOrders;

  @override
  Widget build(BuildContext context) {
    final validOrders = orders.where((order) => order.state != 'لغوشده');
    final revenue = validOrders.fold<int>(0, (sum, order) => sum + order.payableToman);
    final cost = validOrders.fold<int>(0, (sum, order) => sum + order.estimatedCostToman);
    final activeOrders = orders.where((order) => !{'تحویل‌شده', 'لغوشده'}.contains(order.state)).length;
    final lowStock = products.where((product) => product.stock <= 8).length;
    final margin = revenue == 0 ? 0 : (((revenue - cost) / revenue) * 100).round();

    return ListView(
      children: [
        PageTitle(
          eyebrow: 'شنبه ۱۰ مرداد · سناریوی نمایشی',
          title: 'سلام حمیدرضا؛ امروز چه خبر است؟',
          subtitle: 'شاخص‌های مهم فروش و عملیات را یک‌جا ببین و از هشدارها مستقیم وارد کار لازم شو.',
          action: FilledButton.icon(onPressed: onOpenOrders, icon: const Icon(Icons.receipt_long_rounded), label: const Text('بررسی سفارش‌ها')),
        ),
        const SizedBox(height: 21),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1080 ? 4 : constraints.maxWidth >= 570 ? 2 : 1;
            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: columns == 1 ? 2.45 : 1.65,
              children: [
                DashboardMetric(title: 'فروش ثبت‌شده', value: '${demo.toman(revenue)} تومان', detail: '۶ سفارش معتبر', icon: Icons.payments_outlined, tone: _sage, trend: '+۱۲٪'),
                DashboardMetric(title: 'سفارش فعال', value: '$activeOrders سفارش', detail: '۱ مورد آماده اقدام', icon: Icons.shopping_bag_outlined, tone: _sand, trend: 'امروز'),
                DashboardMetric(title: 'حاشیه سود', value: '$margin٪', detail: 'برآورد با بهای بچ', icon: Icons.donut_large_rounded, tone: _lilac, trend: '+۳٪'),
                DashboardMetric(title: 'هشدار موجودی', value: '$lowStock مورد', detail: '${batches.length} بچ فعال', icon: Icons.inventory_2_outlined, tone: _rose, trend: 'نیازمند توجه'),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final recent = RecentOrdersPanel(orders: orders.take(5).toList(), onOpenAll: onOpenOrders);
            final attention = AttentionPanel(products: products, batches: batches);
            if (constraints.maxWidth < 900) {
              return Column(children: [recent, const SizedBox(height: 12), attention]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: recent),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: attention),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        const OperationsJourneyCard(),
      ],
    );
  }
}

class DashboardMetric extends StatelessWidget {
  const DashboardMetric({
    super.key,
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.tone,
    required this.trend,
  });

  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final Color tone;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: tone, borderRadius: BorderRadius.circular(14)),
                  child: Icon(icon, color: _forest, size: 21),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(color: const Color(0xFFF4F6F1), borderRadius: BorderRadius.circular(999)),
                  child: Text(trend, style: const TextStyle(color: _forestSoft, fontSize: 7, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const Spacer(),
            Text(title, style: const TextStyle(color: _muted, fontSize: 9)),
            const SizedBox(height: 4),
            Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(detail, style: const TextStyle(color: Color(0xFF98A198), fontSize: 7)),
          ],
        ),
      ),
    );
  }
}

class RecentOrdersPanel extends StatelessWidget {
  const RecentOrdersPanel({super.key, required this.orders, required this.onOpenAll});

  final List<demo.DemoOrder> orders;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PanelHeader(title: 'آخرین سفارش‌ها', subtitle: 'جدیدترین جریان‌های پرداخت و ارسال', actionLabel: 'مشاهده همه', onAction: onOpenAll),
            const SizedBox(height: 13),
            for (final order in orders)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                  decoration: BoxDecoration(color: const Color(0xFFFAFBF8), borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: _sage,
                        child: Text(order.customer.substring(0, 1), style: const TextStyle(color: _forest, fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.customer, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 3),
                            Text('${order.id} · ${order.city}', style: const TextStyle(color: _muted, fontSize: 7)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${demo.toman(order.payableToman)} تومان', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 5),
                          OrderStateBadge(order.state),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AttentionPanel extends StatelessWidget {
  const AttentionPanel({super.key, required this.products, required this.batches});

  final List<demo.DemoProduct> products;
  final List<demo.DemoBatch> batches;

  @override
  Widget build(BuildContext context) {
    final low = products.where((product) => product.stock <= 8).take(3).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PanelHeader(title: 'نیازمند توجه', subtitle: 'هشدارهایی که بهتر است امروز بررسی شوند'),
            const SizedBox(height: 13),
            for (final product in low)
              _AttentionRow(
                icon: Icons.inventory_2_outlined,
                tone: product.stock <= 5 ? _rose : _sand,
                title: product.title,
                subtitle: '${product.stock} بسته موجود · ${product.sku}',
              ),
            if (batches.any((batch) => batch.status == 'نزدیک مصرف'))
              const _AttentionRow(
                icon: Icons.event_busy_outlined,
                tone: _lilac,
                title: 'بچ نزدیک تاریخ مصرف',
                subtitle: 'LOT-1405-063 را برای برداشت FEFO بررسی کن.',
              ),
          ],
        ),
      ),
    );
  }
}

class _AttentionRow extends StatelessWidget {
  const _AttentionRow({required this.icon, required this.tone, required this.title, required this.subtitle});

  final IconData icon;
  final Color tone;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: const Color(0xFFFAFBF8), borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(color: tone, borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 18, color: _forest)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: _muted, fontSize: 7, height: 1.5)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, size: 18, color: Color(0xFF9CA69E)),
          ],
        ),
      ),
    );
  }
}

class OperationsJourneyCard extends StatelessWidget {
  const OperationsJourneyCard({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('پرداخت‌شده', '۱ سفارش', Icons.payments_outlined),
      ('آماده‌سازی', '۱ سفارش', Icons.inventory_outlined),
      ('ارسال‌شده', '۱ سفارش', Icons.local_shipping_outlined),
      ('تحویل‌شده', '۳ سفارش', Icons.task_alt_rounded),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PanelHeader(title: 'مسیر عملیات امروز', subtitle: 'از تأیید پرداخت تا تحویل نهایی سفارش'),
            const SizedBox(height: 17),
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 650;
                final widgets = [
                  for (var index = 0; index < steps.length; index++) ...[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: index == 0 ? const Color(0xFFF1F6ED) : const Color(0xFFFAFBF8), borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Icon(steps[index].$3, color: _forestSoft),
                            const SizedBox(height: 8),
                            Text(steps[index].$1, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 3),
                            Text(steps[index].$2, style: const TextStyle(color: _muted, fontSize: 7)),
                          ],
                        ),
                      ),
                    ),
                    if (index < steps.length - 1 && !narrow)
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_back_rounded, color: Color(0xFFB0BBB1), size: 17)),
                  ],
                ];
                if (narrow) {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.55,
                    mainAxisSpacing: 9,
                    crossAxisSpacing: 9,
                    children: [for (var index = 0; index < widgets.length; index += 2) widgets[index]],
                  );
                }
                return Row(children: widgets);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key, required this.orders, required this.search, required this.onSearch, required this.onAdvance});

  final List<demo.DemoOrder> orders;
  final String search;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onAdvance;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _filter = 'همه';

  @override
  Widget build(BuildContext context) {
    final states = ['همه', 'پرداخت‌شده', 'در حال آماده‌سازی', 'ارسال‌شده', 'تحویل‌شده'];
    final query = widget.search.trim();
    final visible = widget.orders.where((order) {
      final matchesState = _filter == 'همه' || order.state == _filter;
      final matchesSearch = query.isEmpty || '${order.id} ${order.customer} ${order.city}'.contains(query);
      return matchesState && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(
          eyebrow: 'عملیات فروش',
          title: 'سفارش‌ها',
          subtitle: 'هر سفارش را از پرداخت تا آماده‌سازی، ارسال و تحویل با وضعیت روشن مدیریت کن.',
        ),
        const SizedBox(height: 17),
        _SearchAndFilters(
          hint: 'جست‌وجوی کد، مشتری یا شهر',
          value: widget.search,
          onChanged: widget.onSearch,
          filters: states,
          selected: _filter,
          onSelected: (value) => setState(() => _filter = value),
        ),
        const SizedBox(height: 13),
        Expanded(
          child: visible.isEmpty
              ? const _EmptyState(icon: Icons.search_off_rounded, title: 'سفارشی پیدا نشد', subtitle: 'فیلتر یا عبارت جست‌وجو را تغییر بده.')
              : ListView.separated(
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 9),
                  itemBuilder: (context, index) {
                    final order = visible[index];
                    final canAdvance = {'پرداخت‌شده', 'در حال آماده‌سازی', 'ارسال‌شده'}.contains(order.state);
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final mobile = constraints.maxWidth < 630;
                            final identity = Row(
                              children: [
                                CircleAvatar(backgroundColor: _sage, child: Text(order.customer.substring(0, 1), style: const TextStyle(color: _forest, fontWeight: FontWeight.w900))),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(order.id, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                                      const SizedBox(height: 3),
                                      Text('${order.customer} · ${order.city}', style: const TextStyle(color: _muted, fontSize: 8)),
                                    ],
                                  ),
                                ),
                              ],
                            );
                            final details = [
                              _OrderFact(label: 'مبلغ', value: '${demo.toman(order.payableToman)} تومان'),
                              _OrderFact(label: 'مرجع پرداخت', value: order.paymentReference),
                              OrderStateBadge(order.state),
                              FilledButton.tonalIcon(
                                onPressed: canAdvance ? () => widget.onAdvance(order.id) : null,
                                icon: Icon(canAdvance ? Icons.arrow_back_rounded : Icons.done_all_rounded, size: 17),
                                label: Text(canAdvance ? 'مرحله بعد' : 'تکمیل‌شده'),
                              ),
                            ];
                            if (mobile) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  identity,
                                  const SizedBox(height: 13),
                                  Wrap(spacing: 10, runSpacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: details),
                                ],
                              );
                            }
                            return Row(
                              children: [
                                SizedBox(width: 230, child: identity),
                                const SizedBox(width: 15),
                                Expanded(child: Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 18, runSpacing: 10, children: details)),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _OrderFact extends StatelessWidget {
  const _OrderFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 7)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.products, required this.search, required this.onSearch, required this.onToggle, required this.onAdd});

  final List<demo.DemoProduct> products;
  final String search;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onToggle;
  final VoidCallback onAdd;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _filter = 'همه';

  @override
  Widget build(BuildContext context) {
    final query = widget.search.trim();
    final visible = widget.products.where((product) {
      final matchesFilter = switch (_filter) {
        'منتشرشده' => product.published,
        'پیش‌نویس' => !product.published,
        'کم‌موجودی' => product.stock <= 8,
        _ => true,
      };
      final matchesSearch = query.isEmpty || '${product.title} ${product.sku} ${product.category}'.contains(query);
      return matchesFilter && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageTitle(
          eyebrow: 'کاتالوگ قابل فروش',
          title: 'محصولات',
          subtitle: 'محصول را با قیمت، بسته فروش، موجودی و وضعیت انتشار مستقل مدیریت کن.',
          action: FilledButton.icon(onPressed: widget.onAdd, icon: const Icon(Icons.add_rounded), label: const Text('محصول جدید')),
        ),
        const SizedBox(height: 17),
        _SearchAndFilters(
          hint: 'جست‌وجوی نام، SKU یا دسته',
          value: widget.search,
          onChanged: widget.onSearch,
          filters: const ['همه', 'منتشرشده', 'پیش‌نویس', 'کم‌موجودی'],
          selected: _filter,
          onSelected: (value) => setState(() => _filter = value),
        ),
        const SizedBox(height: 13),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1050 ? 3 : constraints.maxWidth >= 650 ? 2 : 1;
              return visible.isEmpty
                  ? const _EmptyState(icon: Icons.inventory_2_outlined, title: 'محصولی پیدا نشد', subtitle: 'فیلتر یا عبارت جست‌وجو را تغییر بده.')
                  : GridView.builder(
                      itemCount: visible.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 292,
                        crossAxisSpacing: 11,
                        mainAxisSpacing: 11,
                      ),
                      itemBuilder: (context, index) {
                        final product = visible[index];
                        return ProductManagementCard(product: product, onToggle: () => widget.onToggle(product.sku));
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}

class ProductManagementCard extends StatelessWidget {
  const ProductManagementCard({super.key, required this.product, required this.onToggle});

  final demo.DemoProduct product;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final tone = product.stock <= 5 ? _rose : product.stock <= 8 ? _sand : _sage;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: tone, borderRadius: BorderRadius.circular(15)),
                  child: Text(product.title.substring(0, 1), style: const TextStyle(color: _forest, fontSize: 20, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text('${product.category} · ${product.sku}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _muted, fontSize: 7)),
                    ],
                  ),
                ),
                PublicationBadge(published: product.published),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _ProductFact(label: 'بسته فروش', value: product.packageLabel)),
                const SizedBox(width: 8),
                Expanded(child: _ProductFact(label: 'قیمت', value: '${demo.toman(product.priceToman)} تومان')),
              ],
            ),
            const SizedBox(height: 8),
            _ProductFact(label: 'موجودی آماده فروش', value: '${product.stock} بسته'),
            const SizedBox(height: 9),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: (product.stock / 24).clamp(0, 1),
                backgroundColor: const Color(0xFFEDF0EB),
                color: product.stock <= 5 ? const Color(0xFFC97462) : const Color(0xFF6F9A70),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(product.published ? 'در فروشگاه قابل خرید است' : 'فقط در پنل دیده می‌شود', style: const TextStyle(color: _muted, fontSize: 7)),
                ),
                OutlinedButton(
                  onPressed: onToggle,
                  child: Text(product.published ? 'خروج از فروش' : 'انتشار'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductFact extends StatelessWidget {
  const _ProductFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFF7F9F5), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _muted, fontSize: 7)),
          const SizedBox(height: 4),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key, required this.batches, required this.onReceive});

  final List<demo.DemoBatch> batches;
  final VoidCallback onReceive;

  @override
  Widget build(BuildContext context) {
    final total = batches.fold<int>(0, (sum, batch) => sum + batch.remaining);
    final value = batches.fold<int>(0, (sum, batch) => sum + batch.remaining * batch.unitCostToman);
    final expiring = batches.where((batch) => batch.status == 'نزدیک مصرف').length;

    return ListView(
      children: [
        PageTitle(
          eyebrow: 'عملیات انبار',
          title: 'انبار و بچ‌ها',
          subtitle: 'مانده هر سری ورود، تأمین‌کننده، بهای خرید و تاریخ مصرف را قابل ردیابی نگه دار.',
          action: FilledButton.icon(onPressed: onReceive, icon: const Icon(Icons.add_business_rounded), label: const Text('ثبت ورود نمونه')),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _InventorySummary(title: 'موجودی بچ‌ها', value: '$total بسته', icon: Icons.inventory_outlined, tone: _sage),
            _InventorySummary(title: 'ارزش خرید موجودی', value: '${demo.toman(value)} تومان', icon: Icons.account_balance_wallet_outlined, tone: _sand),
            _InventorySummary(title: 'نزدیک تاریخ مصرف', value: '$expiring بچ', icon: Icons.event_busy_outlined, tone: _rose),
          ],
        ),
        const SizedBox(height: 14),
        for (final batch in batches)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final mobile = constraints.maxWidth < 700;
                    final identity = Row(
                      children: [
                        Container(width: 46, height: 46, decoration: BoxDecoration(color: _sage, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.qr_code_2_rounded, color: _forest)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(batch.lot, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 3),
                              Text('${batch.sku} · ${batch.supplier}', style: const TextStyle(color: _muted, fontSize: 7)),
                            ],
                          ),
                        ),
                      ],
                    );
                    final facts = [
                      _OrderFact(label: 'مانده', value: '${batch.remaining} بسته'),
                      _OrderFact(label: 'بهای واحد', value: '${demo.toman(batch.unitCostToman)} تومان'),
                      _OrderFact(label: 'مصرف تا', value: batch.bestBefore),
                      BatchStateBadge(batch.status),
                    ];
                    if (mobile) {
                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [identity, const SizedBox(height: 13), Wrap(spacing: 15, runSpacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: facts)]);
                    }
                    return Row(children: [SizedBox(width: 300, child: identity), const SizedBox(width: 20), Expanded(child: Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 20, runSpacing: 10, children: facts))]);
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _InventorySummary extends StatelessWidget {
  const _InventorySummary({required this.title, required this.value, required this.icon, required this.tone});

  final String title;
  final String value;
  final IconData icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 112,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(width: 43, height: 43, decoration: BoxDecoration(color: tone, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: _forest)),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: _muted, fontSize: 8)),
                    const SizedBox(height: 5),
                    Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key, required this.orders, required this.products});

  final List<demo.DemoOrder> orders;
  final List<demo.DemoProduct> products;

  @override
  Widget build(BuildContext context) {
    final valid = orders.where((order) => order.state != 'لغوشده');
    final revenue = valid.fold<int>(0, (sum, order) => sum + order.payableToman);
    final cost = valid.fold<int>(0, (sum, order) => sum + order.estimatedCostToman);
    final profit = revenue - cost;
    final margin = revenue == 0 ? 0 : (profit / revenue * 100).round();
    final averageOrder = valid.isEmpty ? 0 : (revenue / valid.length).round();

    return ListView(
      children: [
        PageTitle(
          eyebrow: 'تصمیم‌گیری مدیریتی',
          title: 'گزارش فروش و سود',
          subtitle: 'اعداد این صفحه از سفارش‌ها و بهای تقریبی بچ‌های سناریوی نمایشی محاسبه می‌شوند.',
          action: OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('خروجی CSV در نسخه دمو شبیه‌سازی شده است.'))), icon: const Icon(Icons.download_rounded), label: const Text('خروجی CSV')),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1000 ? 4 : constraints.maxWidth >= 550 ? 2 : 1;
            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 11,
              crossAxisSpacing: 11,
              childAspectRatio: columns == 1 ? 2.5 : 1.65,
              children: [
                DashboardMetric(title: 'فروش ناخالص', value: '${demo.toman(revenue)} تومان', detail: '${valid.length} سفارش معتبر', icon: Icons.trending_up_rounded, tone: _sage, trend: '+۱۲٪'),
                DashboardMetric(title: 'بهای تقریبی کالا', value: '${demo.toman(cost)} تومان', detail: 'بر اساس بچ‌های نمونه', icon: Icons.price_check_outlined, tone: _sand, trend: 'برآورد'),
                DashboardMetric(title: 'سود ناخالص', value: '${demo.toman(profit)} تومان', detail: 'پیش از هزینه عملیاتی', icon: Icons.savings_outlined, tone: _lilac, trend: '$margin٪'),
                DashboardMetric(title: 'میانگین سفارش', value: '${demo.toman(averageOrder)} تومان', detail: 'AOV سناریوی دمو', icon: Icons.shopping_cart_checkout_rounded, tone: _rose, trend: '+۵٪'),
              ],
            );
          },
        ),
        const SizedBox(height: 13),
        LayoutBuilder(
          builder: (context, constraints) {
            final chart = const WeeklySalesChart();
            final mix = CategoryMixCard(products: products);
            if (constraints.maxWidth < 850) {
              return Column(children: [chart, const SizedBox(height: 12), mix]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: chart), const SizedBox(width: 12), Expanded(flex: 2, child: mix)]);
          },
        ),
      ],
    );
  }
}

class WeeklySalesChart extends StatelessWidget {
  const WeeklySalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    const data = [('ش', .42, '۶.۲'), ('ی', .58, '۸.۴'), ('د', .37, '۵.۱'), ('س', .73, '۱۰.۶'), ('چ', .64, '۹.۳'), ('پ', .91, '۱۳.۲'), ('ج', .79, '۱۱.۵')];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PanelHeader(title: 'فروش هفت روز اخیر', subtitle: 'میلیون تومان · داده نمایشی'),
            const SizedBox(height: 22),
            SizedBox(
              height: 260,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final item in data)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Text(item.$3, style: const TextStyle(color: _muted, fontSize: 7)),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: item.$2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF76A06F), Color(0xFF315F3F)]),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(item.$1, style: const TextStyle(color: _muted, fontSize: 8)),
                          ],
                        ),
                      ),
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

class CategoryMixCard extends StatelessWidget {
  const CategoryMixCard({super.key, required this.products});

  final List<demo.DemoProduct> products;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('مغزیجات', .52, _forestSoft),
      ('میوه خشک', .21, Color(0xFFD58C5B)),
      ('هدیه', .17, Color(0xFF9A719D)),
      ('سایر', .10, Color(0xFF9CAA8E)),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PanelHeader(title: 'ترکیب فروش', subtitle: '${products.where((item) => item.published).length} محصول منتشرشده'),
            const SizedBox(height: 22),
            Center(
              child: SizedBox(
                width: 138,
                height: 138,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircularProgressIndicator(value: 1, strokeWidth: 21, color: Color(0xFFE7ECE4)),
                    const CircularProgressIndicator(value: .72, strokeWidth: 21, color: _forestSoft, strokeCap: StrokeCap.round),
                    Column(mainAxisSize: MainAxisSize.min, children: [const Text('۷۲٪', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)), Text('خشکبار', style: TextStyle(color: _muted.withValues(alpha: .9), fontSize: 8))]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            for (final row in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(width: 9, height: 9, decoration: BoxDecoration(color: row.$3, borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 8),
                    Expanded(child: Text(row.$1, style: const TextStyle(fontSize: 9))),
                    Text('${(row.$2 * 100).round()}٪', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchAndFilters extends StatelessWidget {
  const _SearchAndFilters({required this.hint, required this.value, required this.onChanged, required this.filters, required this.selected, required this.onSelected});

  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final search = SizedBox(
              width: 330,
              child: TextField(
                onChanged: onChanged,
                controller: TextEditingController(text: value)..selection = TextSelection.collapsed(offset: value.length),
                decoration: InputDecoration(
                  hintText: hint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  isDense: true,
                ),
              ),
            );
            final chips = Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final filter in filters)
                  ChoiceChip(
                    selected: selected == filter,
                    onSelected: (_) => onSelected(filter),
                    label: Text(filter, style: const TextStyle(fontSize: 8)),
                  ),
              ],
            );
            if (constraints.maxWidth < 700) {
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [search, const SizedBox(height: 10), chips]);
            }
            return Row(children: [search, const SizedBox(width: 13), Expanded(child: chips)]);
          },
        ),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.title, required this.subtitle, this.actionLabel, this.onAction});

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: _muted, fontSize: 7)),
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!, style: const TextStyle(fontSize: 8))),
      ],
    );
  }
}

class OrderStateBadge extends StatelessWidget {
  const OrderStateBadge(this.state, {super.key});

  final String state;

  @override
  Widget build(BuildContext context) {
    final config = switch (state) {
      'پرداخت‌شده' => (const Color(0xFFE1EEE2), const Color(0xFF376944)),
      'در حال آماده‌سازی' => (const Color(0xFFFFE8CB), const Color(0xFF835A2C)),
      'ارسال‌شده' => (const Color(0xFFE9E1F1), const Color(0xFF6E4F77)),
      'تحویل‌شده' => (const Color(0xFFDCEDE7), const Color(0xFF2F6C59)),
      _ => (const Color(0xFFF3E0DB), const Color(0xFF8C5447)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: config.$1, borderRadius: BorderRadius.circular(999)),
      child: Text(state, style: TextStyle(color: config.$2, fontSize: 7, fontWeight: FontWeight.w900)),
    );
  }
}

class PublicationBadge extends StatelessWidget {
  const PublicationBadge({super.key, required this.published});

  final bool published;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(color: published ? _sage : _sand, borderRadius: BorderRadius.circular(999)),
      child: Text(published ? 'منتشر' : 'پیش‌نویس', style: TextStyle(color: published ? _forestSoft : const Color(0xFF855C32), fontSize: 7, fontWeight: FontWeight.w900)),
    );
  }
}

class BatchStateBadge extends StatelessWidget {
  const BatchStateBadge(this.state, {super.key});

  final String state;

  @override
  Widget build(BuildContext context) {
    final tone = switch (state) {
      'نزدیک مصرف' => _rose,
      'کم‌موجودی' => _sand,
      'تازه‌وارد' => _lilac,
      _ => _sage,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: tone, borderRadius: BorderRadius.circular(999)),
      child: Text(state, style: const TextStyle(color: _forest, fontSize: 7, fontWeight: FontWeight.w900)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 66, height: 66, decoration: BoxDecoration(color: _sage, borderRadius: BorderRadius.circular(21)), child: Icon(icon, color: _forest, size: 29)),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: _muted, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.icon, required this.tone, required this.title, required this.subtitle});

  final IconData icon;
  final Color tone;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF8FAF6), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: tone, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: _forest, size: 20)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: _muted, fontSize: 8, height: 1.6))])),
        ],
      ),
    );
  }
}
