
$(document).ready(function() {
	var option_count = $(".modifier_options").data("currentmods");
	$(".add-text-field").click(function(e) {
		addOption(option_count++);
		
	})

	$("#modifier_is_size_dependent").click(function() {
		$(".size-dependent-prices").toggle();
		$(".independent-price").toggle();
	});
});


function addOption(option_count) {
	var num_sizes = $(".modifier_options").data("numsizes");
	var is_size_dependent = $("#modifier_is_size_dependent").is(':checked');

	var name = "<input class='form-control' id='option_name_" + option_count + "' name='option_name_" + option_count + "' placeholder='Option " + (option_count+1) + " Name' type='text'>"
	var price = "<span class='independent-price'><input class='form-control' id='option_price_" + option_count + "' name='option_price_" + option_count + "' placeholder='Option " + (option_count+1) + " Price' type='text'></span>"
	var i;

	var tmp = "<div class='size-dependent-prices well' style='display:none;'>"
	for(i=0; i< num_sizes; i++) {
		var size_name = $(".modifier_options").data("sizename" + i);
		tmp +=  "<input id='option_price_" + (option_count+1) + "_" + (i) + "' name='option_price_" + (option_count+1) + "_" +(i+1) + "' placeholder='Price for Option " + (option_count+1) +  " for " + size_name + "' type='number'>";
	}
	 tmp += "</div>";

	$(".modifier_options").append(name + price +tmp);

	if(is_size_dependent) {
		$(".size-dependent-prices").show();
		$(".independent-price").hide();
	}
}