function setupLabel() {
       if ($('.label_radio input').length) {
        $('.label_radio').each(function(){ 
            $(this).removeClass('r_on');
        });
        $('.label_radio input:checked').each(function(){ 
            $(this).parent('label').addClass('r_on');
        });
    };
};
  jQuery(document).ready(function($) {
	// Accordion
    $('body').addClass('has-js');
	$( '.datepicker' ).datepicker( {
		changeMonth: true,
		changeYear: true,
		dateFormat: 'yy-mm-dd'
	});
	$("#accordion").accordion({ header: "h3",autoHeight: false });
	$("input.button").button();
	// Tabs
	// $('#tabs').tabs();
	
	// Slide Menu
	//$('#slide-menu').click(function() {
	//    var $lefty = $('.menu_slider');
	//	lefty.animate({
	//      left: parseInt($lefty.css('left'),10) == 95 ?
	//        -$lefty.outerWidth() :
	//        95
	//    });
	//  });
	//$("li.main-menu").click(function () {
	 //   $(this).toggleClass("selected");
    //});
  });