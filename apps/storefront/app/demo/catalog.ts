export type ProductArt =
  | "pistachio"
  | "almond"
  | "walnut"
  | "fruit"
  | "seed"
  | "cookie"
  | "gift";

export type DemoProduct = {
  id: string;
  title: string;
  subtitle: string;
  category: string;
  origin: string;
  art: ProductArt;
  accent: "sage" | "mint" | "sand" | "peach" | "apricot" | "olive" | "lilac" | "rose";
  price: number;
  oldPrice?: number;
  packageLabel: string;
  stock: number;
  badge?: string;
  note: string;
};

export const categories = [
  "همه",
  "مغزیجات",
  "میوه خشک",
  "تنقلات",
  "خوراکی سالم",
  "هدیه",
];

export const demoProducts: DemoProduct[] = [
  {
    id: "pistachio-akbari",
    title: "پسته اکبری ممتاز",
    subtitle: "دانه‌های کشیده، خندان و دست‌چین",
    category: "مغزیجات",
    origin: "رفسنجان",
    art: "pistachio",
    accent: "sage",
    price: 465000,
    oldPrice: 495000,
    packageLabel: "بسته ۵۰۰ گرمی",
    stock: 12,
    badge: "پرفروش",
    note: "شور ملایم · سایز یکدست",
  },
  {
    id: "pistachio-ahmad",
    title: "پسته احمدآقایی",
    subtitle: "خوش‌رنگ، کشیده و مناسب پذیرایی",
    category: "مغزیجات",
    origin: "کرمان",
    art: "pistachio",
    accent: "mint",
    price: 445000,
    packageLabel: "بسته ۵۰۰ گرمی",
    stock: 10,
    badge: "انتخاب مهمانی",
    note: "بوداده روز · نمک کنترل‌شده",
  },
  {
    id: "almond",
    title: "بادام درختی خام",
    subtitle: "بدون نمک، ترد و مناسب میان‌وعده",
    category: "مغزیجات",
    origin: "چهارمحال",
    art: "almond",
    accent: "sand",
    price: 330000,
    packageLabel: "بسته ۵۰۰ گرمی",
    stock: 16,
    note: "خام · بدون افزودنی",
  },
  {
    id: "walnut",
    title: "مغز گردوی ایرانی",
    subtitle: "روشن، تازه و مناسب صبحانه",
    category: "مغزیجات",
    origin: "تویسرکان",
    art: "walnut",
    accent: "peach",
    price: 305000,
    packageLabel: "بسته ۵۰۰ گرمی",
    stock: 8,
    note: "شکستگی کم · طعم تازه",
  },
  {
    id: "dried-fruit",
    title: "میکس میوه خشک",
    subtitle: "سیب، پرتقال، کیوی و توت‌فرنگی",
    category: "میوه خشک",
    origin: "تولید نوشورا",
    art: "fruit",
    accent: "apricot",
    price: 238000,
    oldPrice: 255000,
    packageLabel: "بسته ۳۰۰ گرمی",
    stock: 21,
    badge: "ترکیب تازه",
    note: "بدون سرخ‌کردن · برش یکدست",
  },
  {
    id: "pumpkin-seeds",
    title: "تخمه کدو گوشتی",
    subtitle: "درشت، تازه و کم‌نمک",
    category: "تنقلات",
    origin: "ایران",
    art: "seed",
    accent: "olive",
    price: 180000,
    packageLabel: "بسته ۵۰۰ گرمی",
    stock: 14,
    note: "تازه‌برشت · کم‌نمک",
  },
  {
    id: "protein-cookie",
    title: "کوکی پروتئینی",
    subtitle: "جو دوسر، کره بادام‌زمینی و شکلات تلخ",
    category: "خوراکی سالم",
    origin: "تولید روز",
    art: "cookie",
    accent: "lilac",
    price: 360000,
    packageLabel: "پک ۴ عددی",
    stock: 20,
    badge: "بدون شکر افزوده",
    note: "پخت روز · بافت نرم",
  },
  {
    id: "gift-box",
    title: "جعبه هدیه دورهمی",
    subtitle: "آجیل ممتاز با بسته‌بندی اختصاصی",
    category: "هدیه",
    origin: "نوشورا",
    art: "gift",
    accent: "rose",
    price: 1290000,
    oldPrice: 1380000,
    packageLabel: "جعبه ۱٫۲ کیلوگرمی",
    stock: 7,
    badge: "هدیه ویژه",
    note: "کارت تبریک · چیدمان سفارشی",
  },
];

export function toman(value: number) {
  return new Intl.NumberFormat("fa-IR").format(value);
}
