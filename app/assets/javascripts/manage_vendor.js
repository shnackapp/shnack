
$(document).ready(function() {
	var option_count = 3;
	$(".add-text-field").click(function(e) {
		addOption(++option_count);
		
	})

});


function addOption(option_count) {
	var name = "<input class='form-control' id='option_name_" + option_count + "' name='option_name_" + option_count + "' placeholder='Option " + option_count + " Name' type='text'>"
	var price = "<input class='form-control' id='option_price_" + option_count + "' name='option_price_" + option_count + "' placeholder='Option " + option_count + " Price' type='text'>"
	$(".modifier_options").append(name + price);
}