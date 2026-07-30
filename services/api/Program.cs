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

    var product = catalog.Create(request);
    return Results.Created($"/api/v1/products/{product.Slug}", product);
});

app.Run();

public sealed class ProductCatalog
{
    private readonly ConcurrentDictionary<Guid, Product> _products = new();

    public ProductCatalog()
    {
        Seed("پسته اکبری ممتاز", "pistachio-akbari-premium", "رفسنجان", "IRR", 8_900_000,
            [new ProductVariant("250g", 250, 2_450_000, 18), new ProductVariant("500g", 500, 4_650_000, 12)]);
        Seed("بادام درختی خام", "raw-almond", "چهارمحال", "IRR", 6_400_000,
            [new ProductVariant("250g", 250, 1_750_000, 25), new ProductVariant("500g", 500, 3_300_000, 16)]);
    }

    public IReadOnlyCollection<Product> All() => _products.Values
        .Where(product => product.IsPublished)
        .OrderBy(product => product.Title)
        .ToArray();

    public Product? FindBySlug(string slug) => _products.Values
        .FirstOrDefault(product => string.Equals(product.Slug, slug, StringComparison.OrdinalIgnoreCase));

    public Product Create(CreateProductRequest request)
    {
        var product = new Product(
            Guid.NewGuid(),
            request.Title.Trim(),
            request.Slug.Trim().ToLowerInvariant(),
            request.Origin.Trim(),
            request.Currency.Trim().ToUpperInvariant(),
            request.BasePrice,
            request.IsPublished,
            request.Variants.Select(variant => new ProductVariant(
                variant.Sku.Trim(), variant.WeightGrams, variant.Price, variant.AvailableStock)).ToArray(),
            DateTimeOffset.UtcNow);

        if (_products.Values.Any(existing => existing.Slug.Equals(product.Slug, StringComparison.OrdinalIgnoreCase)))
        {
            throw new InvalidOperationException("A product with the same slug already exists.");
        }

        _products[product.Id] = product;
        return product;
    }

    private void Seed(string title, string slug, string origin, string currency, decimal basePrice, ProductVariant[] variants)
    {
        var product = new Product(Guid.NewGuid(), title, slug, origin, currency, basePrice, true, variants, DateTimeOffset.UtcNow);
        _products[product.Id] = product;
    }
}

public sealed record Product(
    Guid Id,
    string Title,
    string Slug,
    string Origin,
    string Currency,
    decimal BasePrice,
    bool IsPublished,
    IReadOnlyCollection<ProductVariant> Variants,
    DateTimeOffset CreatedAt);

public sealed record ProductVariant(string Sku, int WeightGrams, decimal Price, int AvailableStock);

public sealed record CreateProductRequest(
    string Title,
    string Slug,
    string Origin,
    string Currency,
    decimal BasePrice,
    bool IsPublished,
    IReadOnlyCollection<CreateProductVariantRequest> Variants)
{
    public Dictionary<string, string[]> Validate()
    {
        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(Title)) errors[nameof(Title)] = ["عنوان محصول الزامی است."];
        if (string.IsNullOrWhiteSpace(Slug)) errors[nameof(Slug)] = ["شناسه آدرس محصول الزامی است."];
        if (string.IsNullOrWhiteSpace(Origin)) errors[nameof(Origin)] = ["مبدأ محصول الزامی است."];
        if (string.IsNullOrWhiteSpace(Currency)) errors[nameof(Currency)] = ["واحد پول الزامی است."];
        if (BasePrice < 0) errors[nameof(BasePrice)] = ["قیمت نمی‌تواند منفی باشد."];
        if (Variants is null || Variants.Count == 0) errors[nameof(Variants)] = ["حداقل یک تنوع وزنی الزامی است."];
        return errors;
    }
}

public sealed record CreateProductVariantRequest(string Sku, int WeightGrams, decimal Price, int AvailableStock);

public partial class Program;
