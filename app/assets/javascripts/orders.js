// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready(function() {
	$("span.plus").click(function() {
		//increment up

		var id = $(this).parent().parent().data("id");
		var val = $("#"+id+"_num").html();
		val++;
		 $("#"+id+"_num").html(val);
		 $(".item_" + id).val(val);
		 updatePrice();
	});

	$("span.minus").click(function() {
		//increment down
		var id = $(this).parent().parent().data("id");
		var val = $("#"+id+"_num").html();
		if(val>0) { val--; } 
		$("#"+id+"_num").html(val);
		$(".item_" + id).val(val);
		updatePrice();
	});

});

function updatePrice() {
	var total = 0;

	$(".menu_item").each(function() {
		var id = $(this).data("id");
		var qty = $("#" + id+ "_num").html();
		var price = $("#" + id + "_price").data("price") * 100;
		var cost = qty*price;
		total += cost;
	});
	total /=100;
	$(".total").html(toUSD(total));
	$(".total").data("price", total);
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