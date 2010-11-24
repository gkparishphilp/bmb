// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
	
	$("#flash").click(function () {
		$(this).fadeOut(2000);
	});
	
	$(".toggle_contact_form").click( function() {
		$('#contact_form').toggle("slow");
	});
	
	///////////////////////   Stuff For Book Asset Page ///////////////////
	
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
	
	
	$('#order_coupon_code').blur(function (){
		the_url = "/orders/validate_coupon?code=";
		the_url += $(this).attr('value');
		the_url += "&item_type=";
		the_url += $('#order_item_type').attr('value');
		
		$.get( the_url, function(data){
			var the_response = $(data).select('#response').attr('value');
			var discount = $(data).select('#response').attr('discount');
			if( the_response == 'true' ){
				var orig_price = $('#price').attr('price');
				var new_price = (orig_price - discount) / 100;
				$('#price').html( "$" + new_price );
				$('#price').highlight("slow");
				$('#valid_coupon').html('Valid Coupon Code Entered');
			}
			else{
				$('#price').html("$9.99");
				$('#valid_coupon').html('');
			}
		});
	});

});