import 'dart:async';

import 'package:flutter/material.dart';

import 'auth_api.dart';
import 'auth_session.dart';
import 'catalog_api.dart';

void main() => runApp(const NooshoraSecureAdminApp());

class NooshoraSecureAdminApp extends StatelessWidget {
  const NooshoraSecureAdminApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'مدیریت نوشورا',
        locale: const Locale('fa'),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F6B45)),
          scaffoldBackgroundColor: const Color(0xFFF6F8F4),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
        ),
        home: const Directionality(textDirection: TextDirection.rtl, child: OwnerAuthGate()),
      );
}

class OwnerAuthGate extends StatefulWidget {
  const OwnerAuthGate({super.key, this.authApi});
  final AuthApiClient? authApi;

  @override
  State<OwnerAuthGate> createState() => _OwnerAuthGateState();
}

class _OwnerAuthGateState extends State<OwnerAuthGate> {
  late final StreamSubscription<bool> subscription;

  @override
  void initState() {
    super.initState();
    subscription = OwnerSession.instance.changes.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => OwnerSession.instance.isAuthenticated
      ? const SecureCatalogShell()
      : OwnerLoginPage(api: widget.authApi);
}

class OwnerLoginPage extends StatefulWidget {
  const OwnerLoginPage({super.key, this.api});
  final AuthApiClient? api;

  @override
  State<OwnerLoginPage> createState() => _OwnerLoginPageState();
}

class _OwnerLoginPageState extends State<OwnerLoginPage> {
  late final AuthApiClient api = widget.api ?? AuthApiClient();
  final email = TextEditingController(text: 'Hamidrezapakpour95@gmail.com');
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool submitting = false;
  bool obscure = true;
  String? error;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    setState(() { submitting = true; error = null; });
    try {
      await api.login(email: email.text, password: password.text);
    } catch (exception) {
      if (mounted) setState(() => error = exception.toString());
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: const BorderSide(color: Color(0xFFE0E8DE)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const Align(alignment: Alignment.center, child: _BrandMark()),
                      const SizedBox(height: 20),
                      Text('ورود مدیر نوشورا', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      const Text('برای مدیریت محصولات و انتشار فروشگاه وارد حساب مالک شوید.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.username],
                        decoration: const InputDecoration(labelText: 'ایمیل مدیر', prefixIcon: Icon(Icons.alternate_email_rounded)),
                        validator: (value) => value == null || !value.contains('@') ? 'ایمیل معتبر وارد کنید.' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: password,
                        obscureText: obscure,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) => submitting ? null : submit(),
                        decoration: InputDecoration(
                          labelText: 'رمز عبور',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded)),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'رمز عبور را وارد کنید.' : null,
                      ),
                      if (error != null) ...[
                        const SizedBox(height: 14),
                        Semantics(liveRegion: true, child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFFFECE8), borderRadius: BorderRadius.circular(12)),
                          child: Text(error!, style: const TextStyle(color: Color(0xFF9A3E36))),
                        )),
                      ],
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: submitting ? null : submit,
                        icon: submitting ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.login_rounded),
                        label: const Padding(padding: EdgeInsets.symmetric(vertical: 13), child: Text('ورود امن')),
                      ),
                      const SizedBox(height: 14),
                      const Text('رمز و توکن در Git یا آدرس صفحه ذخیره نمی‌شوند. نشست پس از انقضا بسته خواهد شد.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class SecureCatalogShell extends StatefulWidget {
  const SecureCatalogShell({super.key});

  @override
  State<SecureCatalogShell> createState() => _SecureCatalogShellState();
}

class _SecureCatalogShellState extends State<SecureCatalogShell> {
  final api = CatalogApiClient();
  List<Product> products = const [];
  bool loading = true;
  String? error;

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    setState(() { loading = true; error = null; });
    try {
      final result = await api.fetchProducts(includeDrafts: true);
      if (mounted) setState(() => products = result);
    } catch (exception) {
      if (mounted) setState(() => error = exception.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Row(children: [_BrandMark(size: 38), SizedBox(width: 10), Text('مدیریت نوشورا')]),
          actions: [
            IconButton(onPressed: load, tooltip: 'تازه‌سازی', icon: const Icon(Icons.refresh_rounded)),
            IconButton(onPressed: OwnerSession.instance.clear, tooltip: 'خروج امن', icon: const Icon(Icons.logout_rounded)),
            const SizedBox(width: 8),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('کاتالوگ مدیریتی', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
            Text('${OwnerSession.instance.email ?? 'مالک'} · نشست کوتاه‌عمر', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 18),
            Expanded(child: _content()),
          ]),
        ),
      );

  Widget _content() {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.cloud_off_rounded, size: 52), const SizedBox(height: 10), Text(error!), const SizedBox(height: 10),
      FilledButton.icon(onPressed: load, icon: const Icon(Icons.refresh), label: const Text('تلاش دوباره')),
    ]));
    if (products.isEmpty) return const Center(child: Text('هنوز محصولی ثبت نشده است.'));
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 1050 ? 3 : constraints.maxWidth >= 640 ? 2 : 1;
      return GridView.builder(
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, mainAxisExtent: 210, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemBuilder: (_, index) {
          final product = products[index];
          return Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(product.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))), Chip(label: Text(product.isPublished ? 'منتشرشده' : 'پیش‌نویس'))]),
            Text('${product.category} · ${product.origin}', style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            Wrap(spacing: 6, runSpacing: 6, children: [for (final variant in product.variants) Chip(label: Text('${variant.displayLabel} · ${variant.availablePackages} بسته'))]),
          ])));
        },
      );
    });
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.size = 54});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size, alignment: Alignment.center,
        decoration: BoxDecoration(color: const Color(0xFF3F6B45), borderRadius: BorderRadius.circular(size * .32)),
        child: Text('ن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: size * .48)),
      );
}
