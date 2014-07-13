// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready(function() {
	initializeValues();

	$("span.plus").click(function() {
		//increment up

		var id = $(this).parent().parent().parent().data("id");
		var val = $("#"+id+"_num").html();
		val++;
		 $("#"+id+"_num").html(val);
		 $(".item_" + id).val(val);
		 updatePrice();

		 //$("#"+id+"_mod").show();
		 $("#"+id+"_mod").slideDown(400);

	});

$(document).ready(function() {
  var hidden = true;
  $('#multiple_select_mod_btn').click(function() {
    if(hidden) { $('#multiple_select_mod_table').show(); hidden=false; }
    else { $('#multiple_select_mod_table').hide(); hidden=true; }
  });
});

	$("span.minus").click(function() {
		//increment down
		var id = $(this).parent().parent().parent().data("id");
		var val = $("#"+id+"_num").html();
		if(val>0) { val--; } 
		if(val==0) {$("#"+id+"_mod").slideUp(400);}
		$("#"+id+"_num").html(val);
		$(".item_" + id).val(val);
		updatePrice();

		

	});

	$(".panel-heading").click(function() {
		$(this).next().slideToggle(200);
	});

	$("#order-submit").click(function(e) {

		var total = $(".total").data("price");
		if(total <= 0) {
			e.preventDefault();
			$(".order-error").slideDown(100);
		}

	})

});

function initializeValues() {
	//Initialize all the values of the form.
	$(".num").each(function() {
		// $(".num:eq(1)").parent().children().last().val()
		var val = $(this).parent().children().last().val();
		$(this).html(val);

	})
	updatePrice();

	$(".all_the_mods").hide();


};

function updatePrice() {
	var subtotal = 0;

	$(".menu_item").each(function() {
		var id = $(this).data("id");
		var qty = $("#" + id+ "_num").html();
		var price = $("#" + id + "_price").data("price");
		var cost = qty*price;
		subtotal += cost;
	});
	subtotal /=100;
	$("td.subtotal").html(toUSD(subtotal));
	$("td.subtotal").data("price", subtotal);

	var total = $(".fee").data("price")/100 + subtotal;

	$("td.total").html(toUSD(total));
	$("td.total").data("total", total);

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

function showItemModSection() {
	document.getElementById("bonus").style.display="Block";
}

function hideItemModSection() {
	document.getElementById("bonus").style.display="None";
}