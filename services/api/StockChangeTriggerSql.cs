public static class StockChangeTriggerSql
{
    public const string Sql = """
        create or replace function nooshora_capture_stock_change()
        returns trigger language plpgsql as $$
        declare
            delta integer;
            movement_kind text;
            batch_text text;
            batch_uuid uuid;
            actor_value text;
            reason_value text;
            unit_cost_value numeric(18,2);
        begin
            delta := new.available_packages-old.available_packages;
            if delta=0 then return new; end if;
            movement_kind := coalesce(nullif(current_setting('nooshora.stock_kind',true),''),
                case when delta<0 then 'Reservation' else 'Release' end);
            batch_text := nullif(current_setting('nooshora.stock_batch_id',true),'');
            batch_uuid := case when batch_text is null then null else batch_text::uuid end;
            actor_value := coalesce(nullif(current_setting('nooshora.stock_actor',true),''),'system');
            reason_value := coalesce(nullif(current_setting('nooshora.stock_reason',true),''),'aggregate-stock-change');
            select coalesce(purchase_unit_cost+packaging_unit_cost,0) into unit_cost_value
            from stock_batches where id=batch_uuid;
            unit_cost_value := coalesce(unit_cost_value,0);
            insert into stock_movements
            (id,sku,batch_id,kind,quantity_delta,unit_cost,balance_after,actor,reason,occurred_at)
            values (md5(random()::text || clock_timestamp()::text)::uuid,new.sku,batch_uuid,movement_kind,delta,
                    unit_cost_value,new.available_packages,actor_value,reason_value,now());
            return new;
        end;
        $$;

        drop trigger if exists trg_variant_stock_ledger on product_variants;
        create trigger trg_variant_stock_ledger
        after update of available_packages on product_variants
        for each row execute function nooshora_capture_stock_change();
        """;
}
