import 'package:flutter/material.dart';

import 'catalog_api.dart';

void main() => runApp(const NooshoraAdminApp());

class NooshoraAdminApp extends StatelessWidget {
  const NooshoraAdminApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'مدیریت نوشورا',
        locale: const Locale('fa'),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F6B45)),
          scaffoldBackgroundColor: const Color(0xFFF6F8F4),
          cardTheme: const CardThemeData(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(color: Color(0xFFE3E8E1)),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
          ),
        ),
        home: const Directionality(textDirection: TextDirection.rtl, child: AdminShell()),
      );
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  var index = 0;
  final catalogKey = GlobalKey<CatalogPageState>();
  static const items = [
    ('داشبورد', Icons.space_dashboard_rounded),
    ('سفارش‌ها', Icons.receipt_long_rounded),
    ('محصولات', Icons.inventory_2_rounded),
    ('انبار', Icons.warehouse_rounded),
    ('گزارش‌ها', Icons.query_stats_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 900;
    final pages = [
      const DashboardPage(),
      const PlaceholderPage('سفارش‌ها', Icons.receipt_long_rounded),
      CatalogPage(key: catalogKey),
      const PlaceholderPage('مدیریت انبار', Icons.warehouse_rounded),
      const PlaceholderPage('گزارش‌ها', Icons.query_stats_rounded),
    ];
    return Scaffold(
      appBar: desktop ? null : AppBar(title: const Brand()),
      bottomNavigationBar: desktop
          ? null
          : NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (value) => setState(() => index = value),
              destinations: [
                for (final item in items) NavigationDestination(icon: Icon(item.$2), label: item.$1),
              ],
            ),
      body: Row(children: [
        if (desktop)
          Container(
            width: 245,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF243127), borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              const Padding(padding: EdgeInsets.all(12), child: Brand(dark: true)),
              const SizedBox(height: 20),
              for (var i = 0; i < items.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    selected: index == i,
                    selectedTileColor: const Color(0xFF3F6B45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    leading: Icon(items[i].$2, color: index == i ? Colors.white : const Color(0xFFC6D1C8)),
                    title: Text(items[i].$1, style: TextStyle(color: index == i ? Colors.white : const Color(0xFFC6D1C8))),
                    onTap: () => setState(() => index = i),
                  ),
                ),
              const Spacer(),
              const ListTile(
                leading: CircleAvatar(backgroundColor: Color(0xFFF7C58B), child: Text('ح')),
                title: Text('حمیدرضا', style: TextStyle(color: Colors.white)),
                subtitle: Text('مدیر اصلی', style: TextStyle(color: Color(0xFF9EACA1))),
              ),
            ]),
          ),
        Expanded(child: SafeArea(child: IndexedStack(index: index, children: pages))),
      ]),
      floatingActionButton: index == 2
          ? FloatingActionButton.extended(
              onPressed: () => catalogKey.currentState?.openCreateDialog(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('محصول جدید'),
            )
          : null,
    );
  }
}

class Brand extends StatelessWidget {
  const Brand({super.key, this.dark = false});
  final bool dark;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: const Color(0xFF3F6B45), borderRadius: BorderRadius.circular(15)),
          child: const Text('ن', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('مدیریت نوشورا', style: TextStyle(fontWeight: FontWeight.w800, color: dark ? Colors.white : null)),
          Text('کاتالوگ زنده فروشگاه', style: TextStyle(fontSize: 10, color: dark ? const Color(0xFFB9C8BC) : Colors.grey)),
        ]),
      ]);
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('سلام حمیدرضا 🌿', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('هسته عملیاتی فروشگاه در حال اتصال به داده‌های واقعی است.'),
          const SizedBox(height: 24),
          Wrap(spacing: 12, runSpacing: 12, children: const [
            MetricCard('فروش امروز', 'آزمایشی', Icons.payments_rounded),
            MetricCard('سفارش جدید', '۰', Icons.shopping_bag_rounded),
            MetricCard('کاتالوگ', 'متصل به API', Icons.cloud_done_rounded),
            MetricCard('وضعیت پرداخت', 'غیرفعال', Icons.lock_rounded),
          ]),
        ],
      );
}

class MetricCard extends StatelessWidget {
  const MetricCard(this.title, this.value, this.icon, {super.key});
  final String title;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 250,
        height: 135,
        child: Card(child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: const Color(0xFF3F6B45)),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          ]),
        )),
      );
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, this.api});
  final CatalogApiClient? api;
  @override
  State<CatalogPage> createState() => CatalogPageState();
}

class CatalogPageState extends State<CatalogPage> {
  late final CatalogApiClient api = widget.api ?? CatalogApiClient();
  List<Product> products = const [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() { loading = true; error = null; });
    try {
      final result = await api.fetchProducts();
      if (mounted) setState(() => products = result);
    } catch (exception) {
      if (mounted) setState(() => error = exception.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> openCreateDialog() async {
    final command = await showDialog<CreateProductCommand>(context: context, builder: (_) => const ProductDialog());
    if (command == null) return;
    try {
      await api.createProduct(command);
      await load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('محصول با موفقیت ثبت شد.')));
    } catch (exception) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(exception.toString())));
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('محصولات', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
              Text('منبع داده: $defaultApiBaseUrl', style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ])),
            IconButton(onPressed: load, icon: const Icon(Icons.refresh_rounded), tooltip: 'بارگذاری مجدد'),
          ]),
          const SizedBox(height: 18),
          Expanded(child: _body()),
        ]),
      );

  Widget _body() {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.cloud_off_rounded, size: 54, color: Colors.grey),
      const SizedBox(height: 12),
      Text(error!, textAlign: TextAlign.center),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: load, icon: const Icon(Icons.refresh), label: const Text('تلاش دوباره')),
    ]));
    if (products.isEmpty) return const Center(child: Text('هنوز محصولی ثبت نشده است.'));
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 1100 ? 3 : constraints.maxWidth >= 650 ? 2 : 1;
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, mainAxisExtent: 235, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: products.length,
        itemBuilder: (_, index) => ProductCard(products[index]),
      );
    });
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, {super.key});
  final Product product;
  @override
  Widget build(BuildContext context) => Card(child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(backgroundColor: const Color(0xFFE7F1E2), child: Text(product.isWeight ? '⚖' : '●')),
            const SizedBox(width: 10),
            Expanded(child: Text(product.title, style: const TextStyle(fontWeight: FontWeight.w900))),
          ]),
          const SizedBox(height: 8),
          Text('${product.category} · ${product.origin}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const Spacer(),
          Wrap(spacing: 5, runSpacing: 5, children: [
            for (final variant in product.variants)
              Chip(label: Text('${variant.displayLabel} · ${variant.availablePackages} بسته', style: const TextStyle(fontSize: 10))),
          ]),
          const SizedBox(height: 8),
          Text('موجودی کل: ${product.totalStock} بسته', style: const TextStyle(color: Color(0xFF3F6B45), fontWeight: FontWeight.w700)),
        ]),
      ));
}

class ProductDialog extends StatefulWidget {
  const ProductDialog({super.key});
  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final slug = TextEditingController();
  final origin = TextEditingController();
  final sku = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();
  String unitType = 'Weight';
  String category = 'پسته و مغزیجات';
  num quantity = 250;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('محصول جدید'),
        content: SizedBox(width: 560, child: Form(
          key: formKey,
          child: SingleChildScrollView(child: Column(children: [
            TextFormField(controller: title, decoration: const InputDecoration(labelText: 'نام محصول'), validator: required),
            const SizedBox(height: 10),
            TextFormField(controller: slug, decoration: const InputDecoration(labelText: 'شناسه انگلیسی URL'), validator: required),
            const SizedBox(height: 10),
            DropdownButtonFormField(value: category, decoration: const InputDecoration(labelText: 'دسته‌بندی'), items: const [
              DropdownMenuItem(value: 'پسته و مغزیجات', child: Text('پسته و مغزیجات')),
              DropdownMenuItem(value: 'تخمه و تنقلات', child: Text('تخمه و تنقلات')),
              DropdownMenuItem(value: 'کوکی و کیک سالم', child: Text('کوکی و کیک سالم')),
            ], onChanged: (value) => category = value!),
            const SizedBox(height: 10),
            TextFormField(controller: origin, decoration: const InputDecoration(labelText: 'مبدأ یا برند'), validator: required),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [ButtonSegment(value: 'Weight', label: Text('وزنی')), ButtonSegment(value: 'Count', label: Text('عددی'))],
              selected: {unitType},
              onSelectionChanged: (value) => setState(() { unitType = value.first; quantity = unitType == 'Weight' ? 250 : 1; }),
            ),
            const SizedBox(height: 10),
            TextFormField(controller: sku, decoration: const InputDecoration(labelText: 'SKU'), validator: required),
            const SizedBox(height: 10),
            TextFormField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'قیمت ریال'), validator: numberRequired),
            const SizedBox(height: 10),
            TextFormField(controller: stock, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'تعداد بسته موجود'), validator: numberRequired),
          ])),
        )),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
          FilledButton(onPressed: submit, child: const Text('ثبت محصول')),
        ],
      );

  String? required(String? value) => value == null || value.trim().isEmpty ? 'این فیلد الزامی است.' : null;
  String? numberRequired(String? value) => num.tryParse(value ?? '') == null ? 'عدد معتبر وارد کنید.' : null;

  void submit() {
    if (!formKey.currentState!.validate()) return;
    final label = unitType == 'Weight' ? '${quantity.toInt()} گرم' : '${quantity.toInt()} عدد';
    Navigator.pop(context, CreateProductCommand(
      title: title.text,
      slug: slug.text,
      category: category,
      origin: origin.text,
      unitType: unitType,
      variants: [CreateVariantCommand(
        sku: sku.text,
        quantity: quantity,
        displayLabel: label,
        price: num.parse(price.text),
        availablePackages: int.parse(stock.text),
      )],
    ));
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage(this.title, this.icon, {super.key});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 64, color: const Color(0xFF90A08F)),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const Text('در Vertical Slice بعدی عملیاتی می‌شود.'),
      ]));
}
