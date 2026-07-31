public static class StockOpeningTriggerSql
{
    public const string Sql = """
        create or replace function nooshora_capture_variant_insert()
        returns trigger language plpgsql as $$
        declare batch_uuid uuid;
        begin
            if new.available_packages <= 0 then return new; end if;
            batch_uuid := md5(random()::text || clock_timestamp()::text)::uuid;
            insert into stock_batches
            (id,sku,lot_code,supplier,received_packages,remaining_packages,purchase_unit_cost,packaging_unit_cost,received_at,best_before,notes,created_by)
            values (batch_uuid,new.sku,'OPENING-' || upper(new.sku),'Opening balance',new.available_packages,new.available_packages,
                    0,0,now(),null,'Created for initial product stock','system')
            on conflict (lot_code) do nothing;
            insert into stock_movements
            (id,sku,batch_id,kind,quantity_delta,unit_cost,balance_after,actor,reason,occurred_at)
            select md5(random()::text || clock_timestamp()::text)::uuid,new.sku,batch_uuid,'Opening',new.available_packages,
                   0,new.available_packages,'system','product-opening-balance',now()
            where exists (select 1 from stock_batches where id=batch_uuid);
            return new;
        end;
        $$;

        drop trigger if exists trg_variant_opening_stock on product_variants;
        create trigger trg_variant_opening_stock
        after insert on product_variants for each row execute function nooshora_capture_variant_insert();
        """;
}
