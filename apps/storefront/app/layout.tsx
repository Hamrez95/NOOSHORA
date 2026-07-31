import type { Metadata } from "next";
import "./globals.css";
import "./commerce.css";

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL ?? "https://nooshora.ir"),
  title: {
    default: "نوشورا | دست‌چین لحظه‌های خوش",
    template: "%s | نوشورا",
  },
  description:
    "فروشگاه آنلاین آجیل، خشکبار، میوه خشک و هدیه‌های خوش‌طعم با انتخاب شفاف و ارسال مطمئن.",
  openGraph: {
    type: "website",
    locale: "fa_IR",
    siteName: "نوشورا",
    title: "نوشورا | دست‌چین لحظه‌های خوش",
    description: "آجیل و خشکبار تازه، شفاف و خوش‌هدیه.",
  },
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="fa" dir="rtl">
      <body>{children}</body>
    </html>
  );
}
