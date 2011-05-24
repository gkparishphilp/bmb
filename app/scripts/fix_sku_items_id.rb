create_table :tmp_sku_items, :force => true do |t|
    t.references :sku
    t.references :item, :polymorphic => true
end

execute 'insert into tmp_sku_items (sku_id, item_id, item_type) select sku_id, item_id, item_type from sku_items'
drop table :sku_items
execute 'rename table tmp_sku_items to sku_items'


