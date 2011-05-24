class FixSkuItems < ActiveRecord::Migration
  def self.up
	create_table :tmp_sku_items, :force => true do |t|
	    t.references :sku
	    t.references :item, :polymorphic => true
		t.string	:status
		t.timestamps
	end

	execute 'insert into tmp_sku_items (sku_id, item_id, item_type, created_at, updated_at) select sku_id, item_id, item_type, created_at, updated_at from sku_items'
	execute "update tmp_sku_items set status = 'active'"
	drop_table :sku_items
	execute 'rename table tmp_sku_items to sku_items'


	
  end

  def self.down
  end
end
