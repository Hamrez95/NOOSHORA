const categories = [
  { title: "آجیل و مغزها", icon: "🥜", note: "تازه و دست‌چین" },
  { title: "میوه خشک", icon: "🍑", note: "بدون افزودنی" },
  { title: "هدیه نوشورا", icon: "🎁", note: "برای لحظه‌های خاص" },
  { title: "انتخاب سالم", icon: "🌿", note: "خام و کم‌نمک" },
];

const products = [
  { title: "پسته اکبری ممتاز", origin: "رفسنجان", price: "۸۹۰٬۰۰۰", badge: "پرفروش", icon: "🟢" },
  { title: "بادام درختی خام", origin: "چهارمحال", price: "۶۴۰٬۰۰۰", badge: "تازه", icon: "🌰" },
  { title: "میکس روزانه نوشورا", origin: "ترکیب اختصاصی", price: "۴۹۵٬۰۰۰", badge: "پیشنهاد ما", icon: "🥣" },
  { title: "انجیر خشک ممتاز", origin: "استهبان", price: "۵۸۰٬۰۰۰", badge: "بدون شکر", icon: "🟤" },
];

const articles = [
  "چطور تازگی پسته را تشخیص بدهیم؟",
  "راهنمای انتخاب آجیل برای پذیرایی",
  "میان‌وعده سالم برای روزهای کاری",
];

export default function HomePage() {
  return (
    <main>
      <div className="announcement">ارسال رایگان سفارش‌های بالای ۱٬۵۰۰٬۰۰۰ تومان</div>

      <header className="siteHeader shell">
        <a className="brand" href="#" aria-label="صفحه اصلی نوشورا">
          <span className="brandMark" aria-hidden="true">ن</span>
          <span>
            <strong>نوشورا</strong>
            <small>دست‌چین لحظه‌های خوش</small>
          </span>
        </a>
        <nav aria-label="منوی اصلی">
          <a href="#products">فروشگاه</a>
          <a href="#gift">هدیه</a>
          <a href="#story">داستان ما</a>
          <a href="#journal">مجله</a>
        </nav>
        <div className="headerActions">
          <button className="iconButton" aria-label="جست‌وجو">⌕</button>
          <button className="iconButton" aria-label="حساب کاربری">◎</button>
          <button className="cartButton">سبد خرید <span>۰</span></button>
        </div>
      </header>

      <section className="hero shell">
        <div className="heroCopy">
          <span className="eyebrow">تازه، شفاف، خوش‌هدیه</span>
          <h1>هر دانه، یک انتخاب خوب</h1>
          <p>
            آجیل و خشکبار دست‌چین با اطلاعات روشن درباره مبدأ، تازگی و کیفیت؛
            برای مصرف روزانه، پذیرایی و هدیه.
          </p>
          <div className="heroActions">
            <a className="primaryButton" href="#products">خرید محصولات</a>
            <a className="secondaryButton" href="#gift">ساخت پک هدیه</a>
          </div>
          <ul className="trustList" aria-label="مزیت‌های نوشورا">
            <li>ضمانت تازگی</li>
            <li>بسته‌بندی بهداشتی</li>
            <li>ارسال قابل رهگیری</li>
          </ul>
        </div>
        <div className="heroVisual" aria-label="تصویر مفهومی آجیل نوشورا">
          <span className="leaf leafOne">⌁</span>
          <span className="leaf leafTwo">⌁</span>
          <div className="sun" />
          <div className="bowl">
            <span>🥜</span><span>🌰</span><span>🫘</span><span>🥜</span>
          </div>
          <span className="floatingNut nutOne">●</span>
          <span className="floatingNut nutTwo">◆</span>
          <span className="floatingNut nutThree">●</span>
        </div>
      </section>

      <section className="section shell" aria-labelledby="category-title">
        <div className="sectionHeading">
          <div>
            <span className="eyebrow">از کجا شروع کنیم؟</span>
            <h2 id="category-title">دسته‌بندی‌های محبوب</h2>
          </div>
          <a href="#products">مشاهده همه ←</a>
        </div>
        <div className="categoryGrid">
          {categories.map((category) => (
            <a className="categoryCard" href="#products" key={category.title}>
              <span className="categoryIcon">{category.icon}</span>
              <strong>{category.title}</strong>
              <small>{category.note}</small>
              <span className="roundArrow">←</span>
            </a>
          ))}
        </div>
      </section>

      <section className="section shell" id="products" aria-labelledby="products-title">
        <div className="sectionHeading">
          <div>
            <span className="eyebrow">انتخاب‌های این هفته</span>
            <h2 id="products-title">محصولات دوست‌داشتنی</h2>
          </div>
          <div className="filterChips" aria-label="فیلتر محصولات">
            <button className="active">همه</button>
            <button>خام</button>
            <button>کم‌نمک</button>
          </div>
        </div>
        <div className="productGrid">
          {products.map((product) => (
            <article className="productCard" key={product.title}>
              <div className="productImage">
                <span className="badge">{product.badge}</span>
                <span className="productEmoji" aria-hidden="true">{product.icon}</span>
                <button className="favorite" aria-label={`افزودن ${product.title} به علاقه‌مندی‌ها`}>♡</button>
              </div>
              <div className="productBody">
                <small>{product.origin}</small>
                <h3>{product.title}</h3>
                <div className="weightRow">
                  <button>۲۵۰ گرم</button><button>۵۰۰ گرم</button><button>۱ کیلو</button>
                </div>
                <div className="priceRow">
                  <p><strong>{product.price}</strong> تومان</p>
                  <button className="addButton" aria-label={`افزودن ${product.title} به سبد`}>＋</button>
                </div>
              </div>
            </article>
          ))}
        </div>
      </section>

      <section className="story shell" id="story">
        <div className="storyCopy">
          <span className="eyebrow">چرا نوشورا؟</span>
          <h2>کیفیت باید قابل دیدن باشد، نه فقط یک ادعا</h2>
          <p>
            برای هر محصول، مبدأ، درجه کیفیت، تاریخ بسته‌بندی، شرایط نگهداری و مواد
            حساسیت‌زا را شفاف نمایش می‌دهیم. محصولی که استاندارد ما را نداشته باشد، وارد بسته شما نمی‌شود.
          </p>
          <a className="secondaryButton" href="#">استاندارد کیفیت ما</a>
        </div>
        <div className="qualityCard">
          <div><strong>۴۸ ساعت</strong><span>از آماده‌سازی تا ارسال</span></div>
          <div><strong>۱۰۰٪</strong><span>رهگیری گردش موجودی</span></div>
          <div><strong>۷ روز</strong><span>ضمانت رضایت</span></div>
        </div>
      </section>

      <section className="campaignGrid shell" id="gift">
        <article className="campaign giftCampaign">
          <span>نوشورا هدیه</span>
          <h2>هدیه‌ای که خوش‌طعم می‌ماند</h2>
          <p>پک را بر اساس مناسبت، بودجه و سلیقه مخاطب شخصی‌سازی کنید.</p>
          <a href="#">ساخت پک هدیه ←</a>
        </article>
        <article className="campaign healthCampaign">
          <span>نوشورا سلامت</span>
          <h2>انتخاب سبک‌تر برای هر روز</h2>
          <p>میکس‌های خام، کم‌نمک و بدون شکر افزوده با اندازه مصرف مشخص.</p>
          <a href="#">دیدن انتخاب‌های سالم ←</a>
        </article>
      </section>

      <section className="section shell" id="journal" aria-labelledby="journal-title">
        <div className="sectionHeading">
          <div>
            <span className="eyebrow">مجله نوشورا</span>
            <h2 id="journal-title">بخوانیم و بهتر انتخاب کنیم</h2>
          </div>
        </div>
        <div className="articleGrid">
          {articles.map((title, index) => (
            <article className="articleCard" key={title}>
              <div className={`articleVisual articleVisual${index + 1}`} aria-hidden="true">{["🥜", "🎉", "🌿"][index]}</div>
              <small>راهنمای خرید · ۵ دقیقه</small>
              <h3>{title}</h3>
              <a href="#">ادامه مطلب ←</a>
            </article>
          ))}
        </div>
      </section>

      <section className="serviceStrip shell" aria-label="خدمات فروشگاه">
        <div><span>✓</span><p><strong>ضمانت تازگی</strong><small>بازگشت در صورت نارضایتی</small></p></div>
        <div><span>⌖</span><p><strong>ارسال رهگیری‌شده</strong><small>اطلاع از وضعیت سفارش</small></p></div>
        <div><span>♧</span><p><strong>بسته‌بندی مسئولانه</strong><small>ایمن و مناسب هدیه</small></p></div>
        <div><span>☎</span><p><strong>پشتیبانی واقعی</strong><small>پاسخ‌گویی پیش و پس از خرید</small></p></div>
      </section>

      <footer>
        <div className="footerInner shell">
          <div className="footerBrand">
            <a className="brand" href="#"><span className="brandMark">ن</span><span><strong>نوشورا</strong><small>دست‌چین لحظه‌های خوش</small></span></a>
            <p>فروش آنلاین آجیل، خشکبار، خوراکی سالم و هدیه با استاندارد شفاف کیفیت.</p>
          </div>
          <div><strong>خرید</strong><a href="#products">محصولات</a><a href="#gift">پک هدیه</a><a href="#">فروش سازمانی</a></div>
          <div><strong>راهنما</strong><a href="#">روش ارسال</a><a href="#">پیگیری سفارش</a><a href="#">پرسش‌های متداول</a></div>
          <div><strong>خبرهای خوش‌طعم</strong><p>برای دریافت پیشنهادهای تازه عضو شوید.</p><form><input aria-label="شماره موبایل" placeholder="شماره موبایل" inputMode="tel"/><button>عضویت</button></form></div>
        </div>
        <div className="copyright shell">© ۲۰۲۶ نوشورا — نسخه اولیه طراحی محصول</div>
      </footer>
    </main>
  );
}
