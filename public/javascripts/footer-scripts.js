  jQuery(document).ready(function($) {
	// Accordion
	$( '.datepicker' ).datepicker();
	$("#accordion").accordion({ header: "h3" });
	$(".button").button();
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