public static class StockLedgerSql
{
    public const string Tables = """
        create table if not exists stock_batches (
            id uuid primary key,
            sku text not null references product_variants(sku) on update cascade on delete restrict,
            lot_code varchar(100) not null unique,
            supplier text not null,
            received_packages integer not null check (received_packages >= 0),
            remaining_packages integer not null check (remaining_packages >= 0 and remaining_packages <= received_packages),
            purchase_unit_cost numeric(18,2) not null check (purchase_unit_cost >= 0),
            packaging_unit_cost numeric(18,2) not null check (packaging_unit_cost >= 0),
            received_at timestamptz not null,
            best_before date null,
            notes text null,
            created_by text not null
        );

        create table if not exists stock_movements (
            id uuid primary key,
            sku text not null references product_variants(sku) on update cascade on delete restrict,
            batch_id uuid null references stock_batches(id) on delete restrict,
            source_movement_id uuid null references stock_movements(id) on delete restrict,
            kind varchar(32) not null,
            quantity_delta integer not null,
            unit_cost numeric(18,2) not null check (unit_cost >= 0),
            balance_after integer not null check (balance_after >= 0),
            actor text not null,
            reason text not null,
            occurred_at timestamptz not null
        );

        create index if not exists ix_stock_batches_sku_expiry on stock_batches(sku,best_before,received_at);
        create index if not exists ix_stock_movements_sku_time on stock_movements(sku,occurred_at desc);
        create index if not exists ix_stock_movements_source on stock_movements(source_movement_id);
        """;

    public const string OpeningBalances = """
        insert into stock_batches
        (id,sku,lot_code,supplier,received_packages,remaining_packages,purchase_unit_cost,packaging_unit_cost,received_at,best_before,notes,created_by)
        select md5(random()::text || clock_timestamp()::text)::uuid,v.sku,'OPENING-' || upper(v.sku),'Opening balance',
               v.available_packages,v.available_packages,0,0,now(),null,'Created from catalog opening balance','system'
        from product_variants v
        where v.available_packages>0
          and not exists (select 1 from stock_batches b where upper(b.sku)=upper(v.sku));

        insert into stock_movements
        (id,sku,batch_id,kind,quantity_delta,unit_cost,balance_after,actor,reason,occurred_at)
        select md5(random()::text || clock_timestamp()::text)::uuid,b.sku,b.id,'Opening',b.received_packages,0,
               b.remaining_packages,'system','catalog-opening-balance',b.received_at
        from stock_batches b
        where b.lot_code like 'OPENING-%'
          and not exists (select 1 from stock_movements m where m.batch_id=b.id and m.kind='Opening');
        """;
}
