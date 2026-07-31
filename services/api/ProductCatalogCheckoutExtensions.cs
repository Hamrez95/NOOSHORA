public static class ProductCatalogCheckoutExtensions
{
    public static void Reserve(this ProductCatalog catalog, string sku, int quantity)
    {
        var product = catalog.AllIncludingDrafts()
            .FirstOrDefault(item => item.Variants.Any(variant => variant.Sku.Equals(sku, StringComparison.OrdinalIgnoreCase)))
            ?? throw new InvalidOperationException("Product for reservation was not found.");

        var variants = product.Variants.Select(variant =>
            variant.Sku.Equals(sku, StringComparison.OrdinalIgnoreCase)
                ? variant with { AvailablePackages = variant.AvailablePackages - quantity }
                : variant).ToArray();

        catalog.Add(product with { Variants = variants });
    }
}
