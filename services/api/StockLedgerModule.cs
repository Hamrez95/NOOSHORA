public static class StockLedgerModule
{
    public static IServiceCollection AddStockLedger(this IServiceCollection services)
    {
        services.AddSingleton<StockLedgerDatabase>();
        services.AddHostedService<StockLedgerSchemaInitializer>();
        return services;
    }

    public static IEndpointRouteBuilder MapStockLedger(this IEndpointRouteBuilder endpoints)
    {
        var stock = endpoints.MapGroup("/api/v1/admin/stock").WithTags("Admin Stock");

        stock.MapGet("/batches", async (string? sku, StockLedgerDatabase database, CancellationToken cancellationToken) =>
            Results.Ok(await database.ListBatchesAsync(sku, cancellationToken)))
            .AddEndpointFilter<OwnerAuthorizationFilter>();

        stock.MapGet("/movements", async (string? sku, string? kind, int? limit, StockLedgerDatabase database, CancellationToken cancellationToken) =>
            Results.Ok(await database.ListMovementsAsync(sku, kind, Math.Clamp(limit ?? 100, 1, 500), cancellationToken)))
            .AddEndpointFilter<OwnerAuthorizationFilter>();

        stock.MapGet("/summary", async (StockLedgerDatabase database, CancellationToken cancellationToken) =>
            Results.Ok(await database.SummaryAsync(cancellationToken)))
            .AddEndpointFilter<OwnerAuthorizationFilter>();

        stock.MapPost("/receipts", async (StockReceiptRequest request, StockLedgerDatabase database, ProductCatalog catalog, CancellationToken cancellationToken) =>
        {
            var errors = request.Validate();
            if (errors.Count > 0) return Results.ValidationProblem(errors);
            var result = await database.ReceiveAsync(request, cancellationToken);
            if (result.Status == StockOperationStatus.Updated)
            {
                catalog.SetAvailablePackages(result.Sku!, result.AvailablePackages!.Value);
                return Results.Created($"/api/v1/admin/stock/batches/{result.Batch!.Id}", result.Batch);
            }
            return result.Status == StockOperationStatus.NotFound
                ? Results.NotFound(new { message = result.Message })
                : Results.Conflict(new { message = result.Message });
        }).AddEndpointFilter<OwnerAuthorizationFilter>();

        stock.MapPost("/losses", async (StockLossRequest request, StockLedgerDatabase database, ProductCatalog catalog, CancellationToken cancellationToken) =>
        {
            var errors = request.Validate();
            if (errors.Count > 0) return Results.ValidationProblem(errors);
            var result = await database.RecordLossAsync(request, cancellationToken);
            if (result.Status == StockOperationStatus.Updated)
            {
                catalog.SetAvailablePackages(result.Sku!, result.AvailablePackages!.Value);
                return Results.Ok(new { message = "کاهش موجودی ثبت شد.", result.Sku, result.AvailablePackages });
            }
            return result.Status == StockOperationStatus.NotFound
                ? Results.NotFound(new { message = result.Message })
                : Results.Conflict(new { message = result.Message });
        }).AddEndpointFilter<OwnerAuthorizationFilter>();

        return endpoints;
    }
}

public sealed class StockLedgerSchemaInitializer(StockLedgerDatabase database) : IHostedService
{
    public Task StartAsync(CancellationToken cancellationToken) => database.InitializeAsync(cancellationToken);
    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}

public sealed record StockReceiptRequest(string Sku, string LotCode, string Supplier, int Packages,
    decimal PurchaseUnitCost, decimal PackagingUnitCost, DateTimeOffset? ReceivedAt, DateOnly? BestBefore, string? Notes)
{
    public Dictionary<string, string[]> Validate()
    {
        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(Sku)) errors[nameof(Sku)] = ["SKU الزامی است."];
        if (string.IsNullOrWhiteSpace(LotCode)) errors[nameof(LotCode)] = ["کد Lot الزامی است."];
        if (string.IsNullOrWhiteSpace(Supplier)) errors[nameof(Supplier)] = ["نام تأمین‌کننده الزامی است."];
        if (Packages <= 0) errors[nameof(Packages)] = ["تعداد بسته باید بیشتر از صفر باشد."];
        if (PurchaseUnitCost < 0) errors[nameof(PurchaseUnitCost)] = ["قیمت خرید نمی‌تواند منفی باشد."];
        if (PackagingUnitCost < 0) errors[nameof(PackagingUnitCost)] = ["هزینه بسته‌بندی نمی‌تواند منفی باشد."];
        if (BestBefore is not null && BestBefore.Value < DateOnly.FromDateTime(DateTime.UtcNow))
            errors[nameof(BestBefore)] = ["تاریخ مصرف Batch جدید نمی‌تواند گذشته باشد."];
        return errors;
    }
}

public sealed record StockLossRequest(Guid BatchId, int Packages, string Reason)
{
    public Dictionary<string, string[]> Validate()
    {
        var errors = new Dictionary<string, string[]>();
        if (BatchId == Guid.Empty) errors[nameof(BatchId)] = ["شناسه Batch الزامی است."];
        if (Packages <= 0) errors[nameof(Packages)] = ["تعداد کاهش موجودی باید بیشتر از صفر باشد."];
        if (string.IsNullOrWhiteSpace(Reason)) errors[nameof(Reason)] = ["دلیل کاهش موجودی الزامی است."];
        return errors;
    }
}

public sealed record StockBatch(Guid Id, string Sku, string LotCode, string Supplier, int ReceivedPackages,
    int RemainingPackages, decimal PurchaseUnitCost, decimal PackagingUnitCost, DateTimeOffset ReceivedAt,
    DateOnly? BestBefore, string? Notes, string CreatedBy);
public sealed record StockMovement(Guid Id, string Sku, Guid? BatchId, Guid? SourceMovementId, string Kind,
    int QuantityDelta, decimal UnitCost, int BalanceAfter, string Actor, string Reason, DateTimeOffset OccurredAt);
public sealed record StockSummary(int BatchCount, int ExpiringWithin30Days, int AvailablePackages, decimal StockValue, int SkuCount);
public enum StockOperationStatus { Updated, NotFound, Conflict }
public sealed record StockOperationResult(StockOperationStatus Status, string? Sku = null, int? AvailablePackages = null,
    StockBatch? Batch = null, string? Message = null)
{
    public static StockOperationResult Updated(string sku, int available, StockBatch? batch = null) =>
        new(StockOperationStatus.Updated, sku, available, batch);
    public static StockOperationResult NotFound(string message) => new(StockOperationStatus.NotFound, Message: message);
    public static StockOperationResult Conflict(string message) => new(StockOperationStatus.Conflict, Message: message);
}
