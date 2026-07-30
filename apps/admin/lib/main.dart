import 'package:flutter/material.dart';

void main() {
  runApp(const NooshoraAdminApp());
}

class NooshoraAdminApp extends StatelessWidget {
  const NooshoraAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF3F6B45);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مدیریت نوشورا',
      locale: const Locale('fa'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
          surface: const Color(0xFFFBFCFA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8F4),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Color(0xFFE3E8E1)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: Color(0xFFE3E8E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: Color(0xFFE3E8E1)),
          ),
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: AdminShell(),
      ),
    );
  }
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int selectedIndex = 0;

  static const destinations = <_Destination>[
    _Destination('داشبورد', Icons.space_dashboard_rounded),
    _Destination('سفارش‌ها', Icons.receipt_long_rounded),
    _Destination('محصولات', Icons.inventory_2_rounded),
    _Destination('انبار', Icons.warehouse_rounded),
    _Destination('گزارش‌ها', Icons.query_stats_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= 900;

    return Scaffold(
      appBar: desktop
          ? null
          : AppBar(
              title: const _Brand(compact: true),
              actions: const [
                _NotificationButton(),
                SizedBox(width: 8),
              ],
            ),
      bottomNavigationBar: desktop
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => setState(() => selectedIndex = index),
              destinations: destinations
                  .map((item) => NavigationDestination(icon: Icon(item.icon), label: item.label))
                  .toList(),
            ),
      body: Row(
        children: [
          if (desktop)
            SafeArea(
              child: Container(
                width: 240,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF243127),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: _Brand(dark: true),
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: destinations.length,
                        itemBuilder: (context, index) {
                          final item = destinations[index];
                          final selected = selectedIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: ListTile(
                              selected: selected,
                              selectedTileColor: const Color(0xFF3F6B45),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              leading: Icon(item.icon, color: selected ? Colors.white : const Color(0xFFC6D1C8)),
                              title: Text(item.label, style: TextStyle(color: selected ? Colors.white : const Color(0xFFC6D1C8))),
                              onTap: () => setState(() => selectedIndex = index),
                            ),
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFFF7C58B),
                          child: Text('م', style: TextStyle(color: Color(0xFF243127), fontWeight: FontWeight.bold)),
                        ),
                        title: Text('مدیر فروشگاه', style: TextStyle(color: Colors.white, fontSize: 13)),
                        subtitle: Text('دسترسی کامل', style: TextStyle(color: Color(0xFF9EACA1), fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: SafeArea(
              child: IndexedStack(
                index: selectedIndex,
                children: const [
                  DashboardPage(),
                  PlaceholderPage(title: 'سفارش‌ها', icon: Icons.receipt_long_rounded),
                  PlaceholderPage(title: 'محصولات', icon: Icons.inventory_2_rounded),
                  PlaceholderPage(title: 'مدیریت انبار', icon: Icons.warehouse_rounded),
                  PlaceholderPage(title: 'گزارش‌ها', icon: Icons.query_stats_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: selectedIndex == 2
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
              label: const Text('محصول جدید'),
            )
          : null,
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 1200;
    final medium = width >= 700;
    final crossAxisCount = wide ? 4 : medium ? 2 : 1;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(wide ? 28 : 16, 22, wide ? 28 : 16, 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('سلام، روزت خوش 🌿', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('خلاصه عملکرد امروز فروشگاه نوشورا', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF667168))),
                    ],
                  ),
                ),
                if (medium) ...[
                  SizedBox(
                    width: 260,
                    child: TextField(
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'جست‌وجوی سفارش یا کالا'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const _NotificationButton(),
                ],
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: wide ? 28 : 16, vertical: 14),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 138,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildListDelegate.fixed(const [
              MetricCard(title: 'فروش امروز', value: '۱۸٬۴۵۰٬۰۰۰', suffix: 'تومان', change: '۱۲٪ بیشتر از دیروز', icon: Icons.payments_rounded, tone: Color(0xFFE7F1E2)),
              MetricCard(title: 'سفارش جدید', value: '۲۶', suffix: 'سفارش', change: '۸ سفارش نیازمند اقدام', icon: Icons.shopping_bag_rounded, tone: Color(0xFFF8DDD0)),
              MetricCard(title: 'میانگین سبد', value: '۷۱۰٬۰۰۰', suffix: 'تومان', change: '۴٪ رشد این هفته', icon: Icons.trending_up_rounded, tone: Color(0xFFE8E1F3)),
              MetricCard(title: 'هشدار موجودی', value: '۷', suffix: 'کالا', change: '۲ کالا تمام شده', icon: Icons.inventory_rounded, tone: Color(0xFFFFE8C8)),
            ]),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: wide ? 28 : 16, vertical: 4),
          sliver: SliverToBoxAdapter(
            child: wide
                ? const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Expanded(flex: 3, child: OrdersCard()), SizedBox(width: 12), Expanded(flex: 2, child: InventoryAlertCard())],
                  )
                : const Column(children: [OrdersCard(), SizedBox(height: 12), InventoryAlertCard()]),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.title, required this.value, required this.suffix, required this.change, required this.icon, required this.tone});

  final String title;
  final String value;
  final String suffix;
  final String change;
  final IconData icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFF667168), fontSize: 12)),
                  const Spacer(),
                  Wrap(crossAxisAlignment: WrapCrossAlignment.end, spacing: 5, children: [
                    Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                    Text(suffix, style: const TextStyle(color: Color(0xFF667168), fontSize: 10)),
                  ]),
                  const SizedBox(height: 3),
                  Text(change, style: const TextStyle(color: Color(0xFF3F6B45), fontSize: 10)),
                ],
              ),
            ),
            Container(width: 48, height: 48, decoration: BoxDecoration(color: tone, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: const Color(0xFF3F6B45))),
          ],
        ),
      ),
    );
  }
}

class OrdersCard extends StatelessWidget {
  const OrdersCard({super.key});

  static const orders = [
    ('#۱۰۴۲', 'مینا رضایی', '۱٬۲۴۰٬۰۰۰ تومان', 'در حال آماده‌سازی', Color(0xFFFFE8C8)),
    ('#۱۰۴۱', 'علی احمدی', '۸۹۰٬۰۰۰ تومان', 'پرداخت‌شده', Color(0xFFE7F1E2)),
    ('#۱۰۴۰', 'شرکت آریا', '۱۲٬۸۰۰٬۰۰۰ تومان', 'نیازمند تماس', Color(0xFFF8DDD0)),
    ('#۱۰۳۹', 'سارا محمدی', '۵۸۰٬۰۰۰ تومان', 'ارسال‌شده', Color(0xFFE8E1F3)),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const _SectionTitle(title: 'سفارش‌های اخیر', action: 'مشاهده همه'),
            const SizedBox(height: 12),
            ...orders.map((order) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundColor: const Color(0xFFF2E7D6), child: Text(order.$1, style: const TextStyle(fontSize: 10, color: Color(0xFF243127)))),
                  title: Text(order.$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  subtitle: Text(order.$3, style: const TextStyle(fontSize: 11)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(color: order.$5, borderRadius: BorderRadius.circular(99)),
                    child: Text(order.$4, style: const TextStyle(fontSize: 9, color: Color(0xFF243127))),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class InventoryAlertCard extends StatelessWidget {
  const InventoryAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [('پسته اکبری ۵۰۰ گرم', 3, 20), ('انجیر ممتاز ۲۵۰ گرم', 5, 24), ('میکس روزانه ۵۰۰ گرم', 8, 30)];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(title: 'موجودی‌های حساس', action: 'ورود به انبار'),
            const SizedBox(height: 20),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Expanded(child: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))), Text('${item.$2} عدد', style: const TextStyle(color: Color(0xFFB25543), fontSize: 11))]),
                      const SizedBox(height: 9),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(value: item.$2 / item.$3, minHeight: 8, color: const Color(0xFFF0A277), backgroundColor: const Color(0xFFF2E7D6)),
                      ),
                    ],
                  ),
                )),
            FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add_rounded), label: const Text('ثبت ورود کالا')),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon, size: 48, color: const Color(0xFF3F6B45)), const SizedBox(height: 12), Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('این ماژول در اسپرینت بعدی به API متصل می‌شود.', style: TextStyle(color: Color(0xFF667168))),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action});
  final String title;
  final String action;

  @override
  Widget build(BuildContext context) => Row(
        children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900))), TextButton(onPressed: () {}, child: Text(action))],
      );
}

class _Brand extends StatelessWidget {
  const _Brand({this.dark = false, this.compact = false});
  final bool dark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: compact ? 36 : 42, height: compact ? 36 : 42, decoration: BoxDecoration(color: dark ? const Color(0xFFF7C58B) : const Color(0xFF3F6B45), borderRadius: BorderRadius.circular(14)), child: Center(child: Text('ن', style: TextStyle(color: dark ? const Color(0xFF243127) : Colors.white, fontWeight: FontWeight.w900, fontSize: compact ? 18 : 21)))),
        const SizedBox(width: 9),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('نوشورا', style: TextStyle(color: dark ? Colors.white : const Color(0xFF243127), fontWeight: FontWeight.w900, fontSize: compact ? 15 : 17)), if (!compact) Text('پنل مدیریت', style: TextStyle(color: dark ? const Color(0xFF9EACA1) : const Color(0xFF667168), fontSize: 10))]),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: const Text('۳'),
      child: IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon);
  final String label;
  final IconData icon;
}
