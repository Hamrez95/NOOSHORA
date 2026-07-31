# دموی شریک تجاری نوشورا

این دمو برای نمایش تجربه کامل محصول بدون وابستگی به API، دیتابیس، درگاه یا داده واقعی ساخته شده است.

## خروجی‌های دمو

### فروشگاه

- کاتالوگ پرشده با محصولات، دسته‌بندی، قیمت، موجودی و کمپین هدیه
- فیلتر دسته‌بندی
- سبد خرید و تغییر تعداد
- فرم تحویل
- شبیه‌سازی ثبت سفارش و پرداخت موفق
- برچسب دائمی دمو و هشدار عدم انجام تراکنش واقعی

Build:

```bash
cd apps/storefront
NEXT_PUBLIC_NOOSHORA_DEMO_MODE=true NOOSHORA_STATIC_EXPORT=true npm run build
```

خروجی در `apps/storefront/out` ساخته می‌شود.

### پنل مدیریت

- داشبورد فروش و هشدارها
- سفارش‌های نمونه و تغییر مرحله تا تحویل
- محصولات نمونه، انتشار/پیش‌نویس و افزودن محصول محلی
- Batchهای انبار، قیمت خرید، مانده و تاریخ مصرف
- گزارش فروش، بهای تقریبی، سود ناخالص و نمودار هفتگی

Build:

```bash
cd apps/admin
flutter build web --release --target lib/demo_main.dart
```

خروجی در `apps/admin/build/web` ساخته می‌شود.

## خصوصیات داده دمو

- داده‌ها داخل Build قرار دارند و Secret ندارند.
- تغییرات پنل فقط در حافظه مرورگر همان نشست هستند.
- Refresh صفحه داده‌ها را به Seed اولیه برمی‌گرداند.
- هیچ پرداخت، پیامک، ایمیل یا تغییر دیتابیس واقعی انجام نمی‌شود.

## سوئیچ فروشگاه به Production

در محیط Production این متغیرها تنظیم می‌شوند:

```text
NEXT_PUBLIC_NOOSHORA_DEMO_MODE=false
NEXT_PUBLIC_NOOSHORA_API_BASE_URL=https://api.example.com
NEXT_PUBLIC_NOOSHORA_ADMIN_URL=https://admin.example.com
```

وقتی Demo Mode برابر `false` باشد، صفحه اصلی به `StorefrontApp` متصل به API سوئیچ می‌کند.

## سوئیچ پنل به Production

پنل واقعی از Entry Point زیر ساخته می‌شود:

```bash
flutter build web --release \
  --target lib/secure_main.dart \
  --dart-define=NOOSHORA_API_BASE_URL=https://api.example.com
```

نسخه Android نیز از همین Entry Point ساخته می‌شود:

```bash
flutter build apk --release \
  --target lib/secure_main.dart \
  --dart-define=NOOSHORA_API_BASE_URL=https://api.example.com
```

ورود مدیر، محصولات، سفارش‌ها و گزارش‌های واقعی در این حالت از API دریافت می‌شوند.

## مرزهای Production

دموی شریک جایگزین این موارد نیست:

- PostgreSQL و API عمومی پایدار
- Merchant واقعی و Callback درگاه
- بازپرداخت و تطبیق مالی
- ذخیره‌سازی تصاویر محصول
- شرکت حمل و کد رهگیری
- Backup، Monitoring و Alerting
- نقش‌ها، MFA و Audit Log کامل
- اطلاعات واقعی محصول، قیمت، موجودی، قوانین و محتوای حقوقی
