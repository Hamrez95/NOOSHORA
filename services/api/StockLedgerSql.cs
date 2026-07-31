public static class StockLedgerSql
{
    public const string Tables = """
        create table if not exists stock_batches (
            id uuid primary key,
            sku text not null,
            lot_code varchar(100) not null unique,
            supplier text not null,
            received_packages integer not null,
            remaining_packages integer not null,
            purchase_unit_cost numeric(18,2) not null,
            packaging_unit_cost numeric(18,2) not null,
            received_at timestamptz not null,
            best_before date null,
            notes text null,
            created_by text not null
        );
        """;
}
