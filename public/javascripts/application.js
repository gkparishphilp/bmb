// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
	
	$("#flash").click(function () {
		$(this).fadeOut(2000);
	});
	
	$(".toggle_contact_form").click( function() {
		$('#contact_form').toggle("slow");
	});
	
	
	///////////////////////  Stuff For Edit Book Page  //////////////////////
	
	$('.show_edit_title').click( function() {
		$('#edit_title').show('slow');
		$(this).hide();
	});
	$('.hide_edit_title').click( function() {
		$('#edit_title').hide('slow');
		$('.show_edit_title').show();
	});
	
	///////////////////////   Stuff For Book Asset Page  ///////////////////
	
	$("#asset_asset_type").change(function (){
		if( $(this).attr('value').match("sale") != null  && !$("#price").is(':visible') ) {
			$('#price').show("slow");
			$('#unlock_req').hide();
		}
		if( $(this).attr('value').match("giveaway") != null  && !$("#unlock_req").is(':visible') ) {
			$('#unlock_req').show("slow");
			$('#price').hide();
		}
		if( $(this).attr('value').match("free") != null ) {
			$('#unlock_req').hide();
			$('#price').hide();
		}
	});
	
	
	///////////////////// Admins //////////////////////////
	$('#admin_table th a, #admin_table .pagination a').live('click', function() {
		$.getScript(this.href);
		return false;
	});
	
	$('#search_form #q').keyup( function() {
		//if( $(this).attr('value').length > 2 ){
			$.get( $('#search_form').attr('action'), $('#search_form').serialize(), null, 'script' );
		//}
	});
	
	$('.confirm').click( function() {
		var confirmed = confirm( "Are you Sure?" );
		if( confirmed ){
			// just carry out the action, no need for any JS here
		}
		else{
			// halt the execution chain with a return false
			return false
		}
	});
	
	///////////////// Themes ///////////////
	
	$('.cpicker').ColorPicker({
		onSubmit: function(hsb, hex, rgb, el) {
			$(el).val( "#" + hex );
			$(el).ColorPickerHide(500);
			$(el).css('backgroundColor', '#' + hex);
		},
		onBeforeShow: function () {
			$(this).ColorPickerSetColor(this.value);
		}
	});
	
	////////////////// Stuff for the checkout page ////////////////////////
	$('#paypal_radio').click(function (){
		if( $(this).attr('checked') && $('#cc_info').is(':visible') ){
			$('#cc_info').hide();
			$('#coupon_code').hide();
		}
		$('#paypal_x_checkout').show();
	});
	$('#credit_radio').click(function (){
		if( $(this).attr('checked') && !$('#cc_info').is(':visible') ){
			$('#cc_info').show();
			$('#coupon_code').show();
		}
		$('#paypal_x_checkout').hide();
	});
	
	$("#ship_to_bill").click( function() {
		$('#shipping_form').toggle("slow");
	});
	
	$("#order_shipping_address_id").change( function() {
		if( $(this).attr('value').match("New Address") != null ){
			$('#shipping_new').show('slow');
		}
		else{
			$('#shipping_new').hide('slow');
		}
	});
	
	var visa_pat = new RegExp("^4"), // Visa
		mast_pat = new RegExp("^5[1-5]"), // Mastercard
		amex_pat = new RegExp("^3[47]"), // Amex
		disc_pat = new RegExp("^(6011|622(1(2[6-9]|[3-9][0-9])|[2-8][0-9][0-9]|9([0-1][0-9]|2[0-5]))|64[4-9]|65)");
	
	$('#order_card_number').keyup(function (){
		if( $(this).attr('value').match(visa_pat) != null ){
			$('#card_images').attr('src', "/images/card_images/ccards_visa.png");
		}
		else if( $(this).attr('value').match(disc_pat) != null ){
			$('#card_images').attr('src', "/images/card_images/ccards_discover.png");
		}
		else if( $(this).attr('value').match(amex_pat) != null ){
			$('#card_images').attr('src', "/images/card_images/ccards_amex.png");
		}
		else if( $(this).attr('value').match(mast_pat) != null ){
			$('#card_images').attr('src', "/images/card_images/ccards_mc.png");
		}
		else{
			$('#card_images').attr('src', "/images/card_images/ccards_all.png");
		}
	});
	
	$('#new_order').submit( function(){
		var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/ 
		 if( ! $('.required_email').attr('value').match(re) ){
			alert( "Email is required" );
			$('.required_email').effect("highlight", {}, 3000);
			return false;
		}
	});
	
	
	$('.coupon').blur(function (){
		
		if ( $(this).attr('value') ){
		
			the_url = "https://backmybook.com/coupons/validate/";
			the_url += $('#order_sku_id').attr('value');
			the_url += "/" + $(this).attr('value');
		
			$.get( the_url, function(data){
				var the_response = $(data).attr('value');
				var discount = $(data).attr('discount');
				var discount_type = $(data).attr('discount_type');
				var quantity = $('#quantity_sel').attr('value');
				var total_price = $('#original_price').attr('price') * quantity;
			
				if( the_response == 'true' ){
					var new_price = total_price;
					if( discount_type == 'percent' ){
						new_price = Math.round( ( total_price - (total_price * discount) ) ) / 100 ;
					}
					else{
						new_price = (total_price - discount) / 100;
					}
				
					$('#order_price').html( "$" + new_price );
					$('#order_price'),attr( 'price', new_price * 100 );
					$('#valid_coupon').html('Valid Coupon Code Entered');
					$('#price_div').effect("highlight", {}, 3000);
					$('#valid_coupon_div').effect("highlight", {}, 3000);
				}
				else{
					$('#order_price').html( "$" + total_price / 100 );
					$('#valid_coupon').html('');
				}
			});
		}
		else{
			$('#order_price').html( "$" + total_price / 100 );
			$('#valid_coupon').html('');
		}
	});
	
	$('#order_sku_quantity').change( function(){
		var quantity = $(this).attr('value');
		var orig_price = $('#order_price').attr('price');
		var new_price = Math.round( orig_price * quantity ) / 100;
		new_price = new_price.toFixed(2);
		orig_price = orig_price / 100; // for display

		$('#order_price').html( '$' + orig_price + ' x ' + quantity + ': ' + '$' + new_price );
		
		$('#paypal_btn').attr('href', $('#paypal_btn').attr('href') + '&quantity=' + $(this).attr('value') );
	});
	
	
	$('#sortable').sortable({
		update: function( event, ui ){
			var newOrder = $(this).sortable('toArray').toString();
			$.get( '/skus/update_sort', {newOrder:newOrder} );
			}
		});
	$('#sortable').disableSelection();

});