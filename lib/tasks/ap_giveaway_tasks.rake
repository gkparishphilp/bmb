task :ap_giveaway  => :environment do
	#orders1 = Order.for_sku( 13 )
	#orders2 = Order.for_sku( 12 )
	#orders = orders1 + orders2
	o1 = Order.find 2501
	o2 = Order.find 2502
	orders= Array.new
	orders << o1
	orders << o2
	for order in orders
		# Create free order for ebook
		freebie = Order.new :user_id => order.user.id, :sku_id => 2, :email => order.email, :ip => order.ip, :total => 0, :status => 'success'
		freebie.save( :validate => false )
		freebie.sku.ownings.create :user => order.user, :status => 'active'
		
		# Send email for free ebook 
		# UserMailer.send_gfl_freebie( order.user, freebie ).deliver
		puts "Sending to #{order.email}"
	end
end


	