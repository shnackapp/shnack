// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

/**
	HOW TO DO MULTIPLE MODIFIERS FOR AN ORDER:

	Fire an ajax request for the modifier partial with the item_id and the qty. 
	Then have the names of the inputs be itemid_modid_qty

	that way itemid_modid_1  would be the modifiers for the first item.
	itemid_modid_2  would be the modifiers for the second item
	and so on.

**/

$(document).ready(function() {

	initializeValues();

	$(".entire-mod-wrap").hide();

	$(".my-panel-heading").next().hide();
	$(".my-panel-heading").click(function() {
     $(this).next().slideToggle(200);
     $(this).toggleClass("expanded");
   });


	//increment up
	$("span.plus").click(function() {
		var id = $(this).parent().parent().parent().data("id");
		var val = $("#"+id+"_num").html();
		val++;

		$("#"+id+"_num").html(val);
		$(".item_" + id).val(val);
		updatePrice();
		updateQuantity();

		$("#"+id+"_mod").slideDown(400);
	});

	//increment down
	$("span.minus").click(function() {
		var id = $(this).parent().parent().parent().data("id");
		var val = $("#"+id+"_num").html();
		if(val>0) { val--; } 
		if(val==0) { $("#"+id+"_mod").slideUp(400); }

		$("#"+id+"_num").html(val);
		$(".item_" + id).val(val);
		updatePrice();
		updateQuantity();
	});


	$(".modifier").click(function(){
		updatePrice();
	});

	$("#order-submit").click(function(e) {
		var subtotal = $(".subtotal").data("price");
		if(subtotal <= 0) {
			e.preventDefault();
			$(".current-order-error").show();
		}
	});
});


$(document).ready(function() {
  var hidden = true;
  $('#multiple_select_mod_btn').click(function() {
    if(hidden) { $('#multiple_select_mod_table').show(); hidden=false; }
    else { $('#multiple_select_mod_table').hide(); hidden=true; }
  });
});



function initializeValues() {

	$(".num").each(function() {
		var val = $(this).parent().data("price");
		$(this).html(val);

	});
	
	updatePrice();
	updateQuantity();

};




function updatePrice() {


	var subtotal = 0;

	$(".single-item-wrap").each(function() {
		var id = $(this).data("id");
		var qty = $("#" + id+ "_num").html();

	  if(qty > 0) $("#order-submit").prop('disabled', false);

		var price = $("#" + id + "_price").data("price");
		var cost = qty*price;
		if(!isNaN(cost))
			subtotal += cost;
		// console.log("."+ id + '_modifier');
		$( "."+ id + '_modifier').each(function(index, obj){
			// console.log('checking this modifier');
			if ($(this).is(":checked")){
				var cst = qty * ($(this).data("add-price"))
				if(!isNaN(cst))
					subtotal = subtotal + cst;
			}});
	});


	subtotal /=100;
	$(".subtotal").html(toUSD(subtotal));
	$(".subtotal").data("price", subtotal);
	var total = subtotal;

	if(!isNaN($(".fee").data("price")))
	{
		total = $(".fee").data("price")/100 + total;
	}
	if(!isNaN($(".credit").data("price"))) {
		var tmp = total;
		total = total - $(".credit").data("price")/100;
		if(total < 0) total = 0

		tmp = $(".credit").data("price")/100 - tmp;
		if(tmp < 0) tmp = 0;
		$("td.credit").html(toUSD(tmp));

	}

	$(".total").html(toUSD(total));
	$(".total").data("total", total);

};

function updateQuantity() {
	var qnty = 0;

	$(".num").each( function() {
		qnty += parseInt( $(this).html() );
	});

	$(".cart_quantity").html(qnty);
};



function toUSD(number) {
    var number = number.toString(), 
    dollars = number.split('.')[0], 
    cents = (number.split('.')[1] || '') +'00';
    dollars = dollars.split('').reverse().join('')
        .replace(/(\d{3}(?!$))/g, '$1,')
        .split('').reverse().join('');
    return '$' + dollars + '.' + cents.slice(0, 2);
}
