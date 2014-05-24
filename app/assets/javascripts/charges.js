$(document).ready(function() {
   $("#order-phone-number").keypress(function(e) {
   		if(e.which<48 || e.which > 57)
   			e.preventDefault();
   });
   $("#order-phone-number").mask("(000) 000-0000");
   // $("#order-phone-number").blur(function(e) {
   // 		validateInputs();
   // });

   // disableButton();
   // $("#order-email").blur(function(e) {
   // 		validateInputs();
   // });
	
	
	$("#confirm-button").on('click', function(e){
		var phone_valid = validatePhoneNumber($("#order-phone-number").val());
		if(!phone_valid) {
			e.preventDefault();
			$(".phone-error").slideDown(200);
			$("#order-phone-number").addClass("error");
		}
	});
	$(".stripe-button-el").on('click', function(e){
		var phone_valid = validatePhoneNumber($("#order-phone-number").val());
		if(!phone_valid) {
			e.preventDefault();
			$(".phone-error").slideDown(200);
			$("#order-phone-number").addClass("error");
		}
	});

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
	// var phone_valid = validatePhoneNumber($("#order-phone-number").val());
	console.log("phone-valid is " + phone_valid);
	if(phone_valid) {
		enableButton();
	}
	else {
		// disableButton();
	}

};

function enableButton() {
   $(".stripe-button-el").prop('disabled', false);
   $("#confirm-button").prop('disabled', false);
}

function disableButton() {
   $(".stripe-button-el").prop('disabled', true);
   $("#confirm-button").prop('disabled', true);

}

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