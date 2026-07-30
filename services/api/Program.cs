using System.Collections.Concurrent;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddProblemDetails();
builder.Services.AddCors(options =>
{
    options.AddPolicy("Storefront", policy =>
    {
        var allowedOrigins = builder.Configuration
            .GetSection("Cors:AllowedOrigins")
            .Get<string[]>() ?? ["http://localhost:3000", "http://localhost:8080"];

        policy.WithOrigins(allowedOrigins)
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

builder.Services.AddSingleton<ProductCatalog>();

var app = builder.Build();

app.UseExceptionHandler();
app.UseHttpsRedirection();
app.UseCors("Storefront");

app.MapGet("/health", () => Results.Ok(new
{
    status = "healthy",
    service = "nooshora-api",
    utc = DateTimeOffset.UtcNow
}));

app.MapGet("/api/v1/catalog/unit-types", () => Results.Ok(new[]
{
    new { value = ProductUnitType.Weight.ToString(), baseUnit = "gram", titleFa = "وزنی / گرم" },
    new { value = ProductUnitType.Count.ToString(), baseUnit = "piece", titleFa = "عددی / عدد" }
}));

var products = app.MapGroup("/api/v1/products").WithTags("Products");

products.MapGet("/", (ProductCatalog catalog) => Results.Ok(catalog.All()));

products.MapGet("/{slug}", (string slug, ProductCatalog catalog) =>
    catalog.FindBySlug(slug) is { } product
        ? Results.Ok(product)
        : Results.NotFound(new { message = "محصول پیدا نشد." }));

products.MapPost("/", (CreateProductRequest request, ProductCatalog catalog) =>
{
    var validationErrors = request.Validate();
    if (validationErrors.Count > 0)
    {
        return Results.ValidationProblem(validationErrors);
    }

    if (catalog.SlugExists(request.Slug))
    {
        return Results.Conflict(new { message = "محصولی با این شناسه آدرس وجود دارد." });
    }

    var product = catalog.Create(request);
    return Results.Created($"/api/v1/products/{product.Slug}", product);
});

app.Run();

public enum ProductUnitType
{
    Weight,
    Count
}

public sealed class ProductCatalog
{
    private readonly ConcurrentDictionary<Guid, Product> _products = new();

    public ProductCatalog()
    {
        Seed(
            "پسته اکبری ممتاز",
            "pistachio-akbari-premium",
            "پسته و مغزیجات",
            "رفسنجان",
            ProductUnitType.Weight,
            [
                new ProductVariant("PI-AKB-250", 250, "gram", "۲۵۰ گرم", 2_450_000, 18),
                new ProductVariant("PI-AKB-500", 500, "gram", "۵۰۰ گرم", 4_650_000, 12),
                new ProductVariant("PI-AKB-1000", 1000, "gram", "۱۰۰۰ گرم", 8_900_000, 6)
            ]);

        Seed(
            "پسته احمدآقایی ممتاز",
            "pistachio-ahmad-aghaei-premium",
            "پسته و مغزیجات",
            "کرمان",
            ProductUnitType.Weight,
            [
                new ProductVariant("PI-AHM-250", 250, "gram", "۲۵۰ گرم", 2_350_000, 16),
                new ProductVariant("PI-AHM-500", 500, "gram", "۵۰۰ گرم", 4_450_000, 10),
                new ProductVariant("PI-AHM-1000", 1000, "gram", "۱۰۰۰ گرم", 8_500_000, 5)
            ]);

        Seed(
            "تخمه کدو گوشتی",
            "pumpkin-seeds",
            "تخمه و تنقلات",
            "ایران",
            ProductUnitType.Weight,
            [
                new ProductVariant("SE-PUM-250", 250, "gram", "۲۵۰ گرم", 950_000, 22),
                new ProductVariant("SE-PUM-500", 500, "gram", "۵۰۰ گرم", 1_800_000, 14),
                new ProductVariant("SE-PUM-1000", 1000, "gram", "۱۰۰۰ گرم", 3_400_000, 7)
            ]);

        Seed(
            "بادام درختی خام",
            "raw-almond",
            "پسته و مغزیجات",
            "چهارمحال",
            ProductUnitType.Weight,
            [
                new ProductVariant("NU-ALM-250", 250, "gram", "۲۵۰ گرم", 1_750_000, 25),
                new ProductVariant("NU-ALM-500", 500, "gram", "۵۰۰ گرم", 3_300_000, 16),
                new ProductVariant("NU-ALM-1000", 1000, "gram", "۱۰۰۰ گرم", 6_400_000, 8)
            ]);

        Seed(
            "مغز گردوی ایرانی",
            "iranian-walnut-kernel",
            "پسته و مغزیجات",
            "تویسرکان",
            ProductUnitType.Weight,
            [
                new ProductVariant("NU-WAL-250", 250, "gram", "۲۵۰ گرم", 1_620_000, 18),
                new ProductVariant("NU-WAL-500", 500, "gram", "۵۰۰ گرم", 3_050_000, 10),
                new ProductVariant("NU-WAL-1000", 1000, "gram", "۱۰۰۰ گرم", 5_900_000, 5)
            ]);

        Seed(
            "کوکی پروتئینی نوشورا",
            "nooshora-protein-cookie",
            "کوکی و کیک سالم",
            "تولید روز",
            ProductUnitType.Count,
            [
                new ProductVariant("CK-PRO-1", 1, "piece", "۱ عدد", 950_000, 48),
                new ProductVariant("CK-PRO-4", 4, "piece", "پک ۴ عددی", 3_600_000, 20),
                new ProductVariant("CK-PRO-8", 8, "piece", "پک ۸ عددی", 6_900_000, 10)
            ]);
    }

    public IReadOnlyCollection<Product> All() => _products.Values
        .Where(product => product.IsPublished)
        .OrderBy(product => product.Category)
        .ThenBy(product => product.Title)
        .ToArray();

    public Product? FindBySlug(string slug) => _products.Values
        .FirstOrDefault(product => string.Equals(product.Slug, slug, StringComparison.OrdinalIgnoreCase));

    public bool SlugExists(string slug) => _products.Values
        .Any(product => string.Equals(product.Slug, slug.Trim(), StringComparison.OrdinalIgnoreCase));

    public Product Create(CreateProductRequest request)
    {
        var unitType = Enum.Parse<ProductUnitType>(request.UnitType, ignoreCase: true);
        var baseUnit = unitType == ProductUnitType.Weight ? "gram" : "piece";

        var product = new Product(
            Guid.NewGuid(),
            request.Title.Trim(),
            request.Slug.Trim().ToLowerInvariant(),
            request.Category.Trim(),
            request.Origin.Trim(),
            request.Currency.Trim().ToUpperInvariant(),
            unitType,
            request.IsPublished,
            request.Variants.Select(variant => new ProductVariant(
                variant.Sku.Trim().ToUpperInvariant(),
                variant.Quantity,
                baseUnit,
                variant.DisplayLabel.Trim(),
                variant.Price,
                variant.AvailablePackages)).ToArray(),
            DateTimeOffset.UtcNow);

        _products[product.Id] = product;
        return product;
    }

    private void Seed(
        string title,
        string slug,
        string category,
        string origin,
        ProductUnitType unitType,
        ProductVariant[] variants)
    {
        var product = new Product(
            Guid.NewGuid(),
            title,
            slug,
            category,
            origin,
            "IRR",
            unitType,
            true,
            variants,
            DateTimeOffset.UtcNow);

        _products[product.Id] = product;
    }
}

public sealed record Product(
    Guid Id,
    string Title,
    string Slug,
    string Category,
    string Origin,
    string Currency,
    ProductUnitType UnitType,
    bool IsPublished,
    IReadOnlyCollection<ProductVariant> Variants,
    DateTimeOffset CreatedAt);

public sealed record ProductVariant(
    string Sku,
    decimal Quantity,
    string BaseUnit,
    string DisplayLabel,
    decimal Price,
    int AvailablePackages);

public sealed record CreateProductRequest(
    string Title,
    string Slug,
    string Category,
    string Origin,
    string Currency,
    string UnitType,
    bool IsPublished,
    IReadOnlyCollection<CreateProductVariantRequest> Variants)
{
    public Dictionary<string, string[]> Validate()
    {
        var errors = new Dictionary<string, string[]>();

        if (string.IsNullOrWhiteSpace(Title)) errors[nameof(Title)] = ["عنوان محصول الزامی است."];
        if (string.IsNullOrWhiteSpace(Slug)) errors[nameof(Slug)] = ["شناسه آدرس محصول الزامی است."];
        if (string.IsNullOrWhiteSpace(Category)) errors[nameof(Category)] = ["دسته‌بندی محصول الزامی است."];
        if (string.IsNullOrWhiteSpace(Origin)) errors[nameof(Origin)] = ["مبدأ یا برند محصول الزامی است."];
        if (string.IsNullOrWhiteSpace(Currency)) errors[nameof(Currency)] = ["واحد پول الزامی است."];

        if (!Enum.TryParse<ProductUnitType>(UnitType, ignoreCase: true, out _))
        {
            errors[nameof(UnitType)] = ["نوع واحد باید Weight یا Count باشد."];
        }

        if (Variants is null || Variants.Count == 0)
        {
            errors[nameof(Variants)] = ["حداقل یک بسته قابل فروش الزامی است."];
            return errors;
        }

        var duplicateSkus = Variants
            .Where(variant => !string.IsNullOrWhiteSpace(variant.Sku))
            .GroupBy(variant => variant.Sku.Trim(), StringComparer.OrdinalIgnoreCase)
            .Where(group => group.Count() > 1)
            .Select(group => group.Key)
            .ToArray();

        if (duplicateSkus.Length > 0)
        {
            errors["Variants.Sku"] = [$"کدهای کالا تکراری هستند: {string.Join("، ", duplicateSkus)}"];
        }

        for (var index = 0; index < Variants.Count; index++)
        {
            var variant = Variants.ElementAt(index);
            if (string.IsNullOrWhiteSpace(variant.Sku)) errors[$"Variants[{index}].Sku"] = ["کد کالا الزامی است."];
            if (string.IsNullOrWhiteSpace(variant.DisplayLabel)) errors[$"Variants[{index}].DisplayLabel"] = ["عنوان بسته الزامی است."];
            if (variant.Quantity <= 0) errors[$"Variants[{index}].Quantity"] = ["مقدار بسته باید بیشتر از صفر باشد."];
            if (variant.Price < 0) errors[$"Variants[{index}].Price"] = ["قیمت نمی‌تواند منفی باشد."];
            if (variant.AvailablePackages < 0) errors[$"Variants[{index}].AvailablePackages"] = ["موجودی نمی‌تواند منفی باشد."];
        }

        return errors;
    }
}

public sealed record CreateProductVariantRequest(
    string Sku,
    decimal Quantity,
    string DisplayLabel,
    decimal Price,
    int AvailablePackages);

public partial class Program;
