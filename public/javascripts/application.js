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
			$('#cc_info').slideUp("slow");
		}
		$('#paypal_x_checkout').show("slow");
	});
	$('#credit_radio').click(function (){
		if( $(this).attr('checked') && !$('#cc_info').is(':visible') ){
			$('#cc_info').slideDown("slow");
		}
		$('#paypal_x_checkout').hide();
	});
	$("#use_new_billing_address").click(function () {
		$("#new_billing_address").toggle("slow");
	});	
	$("#use_new_shipping_address").click(function () {
		$("#new_shipping_address").toggle("slow");
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
		the_url = "/coupons/validate/";
		the_url += $('#order_sku_id').attr('value');
		the_url += "/" + $(this).attr('value');

		$.get( the_url, function(data){
			var the_response = $(data).attr('value');
			var discount = $(data).attr('discount');
			var discount_type = $(data).attr('discount_type');
			var orig_price = $('#the_price').attr('sku_price');
			
			if( the_response == 'true' ){
				var new_price = orig_price;
				if( discount_type == 'percent' ){
					new_price = Math.round( ( orig_price - (orig_price * discount) ) ) / 100 ;
				}
				else{
					new_price = (orig_price - discount) / 100;
				}
				
				$('#the_price').html( "$" + new_price );
				$('#valid_coupon').html('Valid Coupon Code Entered');
				$('#price_div').effect("highlight", {}, 3000);
				$('#valid_coupon_div').effect("highlight", {}, 3000);
			}
			else{
				$('#the_price').html( "$" + $('#order_price').attr('value') / 100 );
				$('#valid_coupon').html('');
			}
		});
	});

});