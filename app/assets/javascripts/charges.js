$(document).ready(function() {
   $("#order-phone-number").keypress(function(e) {
   		if(e.which<48 || e.which > 57)
   			e.preventDefault();
   });
   $("#order-phone-number").mask("(000) 000-0000");
   $("#order-phone-number").blur(function(e) {
   		validateInputs();
   });

   $(".stripe-button-el").prop('disabled', true);
   // $("#order-email").blur(function(e) {
   // 		validateInputs();
   // });
	
	
	// $(".stripe-button-el").click(function(e) {
	// 	var pathname = window.location.pathname;
	// 	var num = $("#order-phone-number").val();
	// 	num = num.replace("(", "").replace(")", "").replace("-", "").replace(" ", "");

	// 	$.ajax({
	// 		url: "/orders/" +pathname.split('/')[2] + "/add_number_to_order",
	// 		type: "POST",
	// 		data: 
	// 		{ number: num}
	// 	});
	// });

});

function validateInputs()
{
	// var email_valid = validateEmail($("#order-email").val());
	var phone_valid = validatePhoneNumber($("#order-phone-number").val());
	if(phone_valid) {
		$(".stripe-button-el").prop('disabled', false);
	}
	else {
		$(".stripe-button-el").prop('disabled', true);
	}

};

function validatePhoneNumber(number)
{
	if(number.length == 14)
		return true;
	else
		return false;
}

function validateEmail(email) 
{ 
 var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
 return email.match(re);
};