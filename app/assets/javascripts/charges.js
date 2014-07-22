$(document).ready(function() {
	var stripeResponseHandler = function(status, response) {
	  var $form = $('#charges-form');

	  if (response.error) {
	    // Show the errors on the form
	    // $form.find('.payment-errors').text(response.error.message);
	    // $form.find('button').prop('disabled', false);
	   	$(".stripe-error").text(response.error.message);
	   	$(".stripe-error").slideDown(300);
	    $("#credit-card-form").find('button').prop('disabled', false);

	  } else {
	    // token contains id, last4, and card type
	    var token = response.id;
	    // Insert the token into the form so it gets submitted to the server
	    // console.log(token);
	    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
	    // and submit
	    $form.get(0).submit();
	  }
	};

	$('#credit_card_number').keypress(function(e) {

		if(e.which<48 || e.which > 57) {
			e.preventDefault();
		} 
		else if($(this).val().length == 18){
			$('#expiration_month').focus();
		}

	});

	$("#expiration_month").keypress(function(e) {
		if(e.which<48 || e.which > 57 || $(this).val().length > 2) {
			e.preventDefault();
		} 
		else if($(this).val().length == 1){
			$('#expiration_year').focus();
		}
	});

	$("#expiration_year").keypress(function(e) {
		if(e.which<48 || e.which > 57  || $(this).val().length > 2) {
			e.preventDefault();
		} 
		else if($(this).val().length == 1){
			$('#security_code').focus();
		}
	});

	$("#security_code").keypress(function(e) {
		if(e.which < 48 || e.which > 57 || $(this).val().length > 3) {
			e.preventDefault();
		}
	});

	if($('.select-card-form')[0]) {
		$('.new-card-form').hide();
	}


	$("[name='user_card']").change(function (evt) {
		if($(this).hasClass('new-card-button')) { 
			$('.new-card-form').slideDown(300);
		}
		else {
			$('.new-card-form').slideUp(300);
		}
	})


	//Make sure form submits on cash only.
   $("#confirm-button").click(function() { 
   	$form = $('#charges-form');
   	$form.get(0).submit();
   });



   /**  
	This method needs to check if the select card form exists.
	If so, then it needs to check which option was selected; if a new card is being created, then it 
	sends it to stripe.
	Otherwise it submits the form with the card index under stripe_card

	If select card form doesn't exist, that means the user isn't signed in or doesn't have
	any credit cards stored. Submit to stripe then submit the form.

   **/
	$("#credit-card-form").submit(function(event) {
		event.preventDefault();
		var $form = $(this);

		if($('.select-card-form')[0]) {
			//Select card form exists.
			if($("input[name='user_card']:checked").hasClass('new-card-button')) {	
		    	$form.find('button').prop('disabled', true);

				Stripe.card.createToken({
					number: $("#credit_card_number").val(),
					cvc: $("#security_code").val(),
					exp_month: $("#expiration_month").val(),
					exp_year: $("#expiration_year").val()
				}, stripeResponseHandler);			
			}
			else {
				var $form = $('#charges-form'); 

				var index = $("input[name='user_card']:checked").val();
				$form.append($('<input type="hidden" name="stripeCardIndex" />').val(index));
	    		$form.get(0).submit();
			}

		}

		else {
	    	$form.find('button').prop('disabled', true);

			Stripe.card.createToken({
				number: $("#credit_card_number").val(),
				cvc: $("#security_code").val(),
				exp_month: $("#expiration_month").val(),
				exp_year: $("#expiration_year").val()
			}, stripeResponseHandler);
		}

		return false;

	} );



   $("#order-phone-number").keypress(function(e) {
   		if(e.which<48 || e.which > 57) {
   			e.preventDefault();
   		}
   		else {
   			var phone_valid = validatePhoneNumber($("#order-phone-number").val());
			if(phone_valid) {
				if(validateName($("#order-name").val())) {
					enableButton();
				}
			}
   		}


   });
   $("#order-phone-number").mask("(000) 000-0000");
   $("#credit_card_number").mask("0000 0000 0000 0000");
   
   if(!validateName($("#order-name").val()) || !validatePhoneNumber($("#order-phone-number").val()) )
   { 
   		disableButton();
   }
   // $("#order-phone-number").blur(function(e) {
   // 		validateInputs();
   // });

   // disableButton();
   // $("#order-email").blur(function(e) {
   // 		validateInputs();
   // });
	
	
	$("#order-name").blur(function(e){
		var name_valid = validateName($("#order-name").val());
		var phone_valid = validatePhoneNumber($("#order-phone-number").val());


		if(!name_valid) {
			e.preventDefault();
			$(".name-error").slideDown(200);
			$("#order-name").addClass("error");
			disableButton();
		}
		if(name_valid) {
			e.preventDefault();
			$(".name-error").slideUp(200);
			$("#order-name").removeClass("error");
		}
		if(name_valid && phone_valid) {
			$(".name-error").slideUp(200);
			$("#order-name").removeClass("error");
			$(".phone-error").slideUp(200);
			$("#order-phone-number").removeClass("error");
			enableButton();
		}
	});
	$("#order-phone-number").blur(function(e){
		var phone_valid = validatePhoneNumber($("#order-phone-number").val());
		var name_valid = validateName($("#order-name").val());

		if(!phone_valid) {
			e.preventDefault();
			$(".phone-error").slideDown(200);
			$("#order-phone-number").addClass("error");
			disableButton();
		}
		if(phone_valid) {
			e.preventDefault();
			$(".phone-error-error").slideUp(200);
			$("#order-phone-number").removeClass("error");
		}

		if(name_valid && phone_valid)
		{
			$(".name-error").slideUp(200);
			$("#order-name").removeClass("error");
			$(".phone-error").slideUp(200);
			$("#order-phone-number").removeClass("error");
			enableButton();
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

function submitToStripe() {

}

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

}

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
	if(number != null && number.length == 14)
		return true;
	else
		return false;
}

function validateName(name)
{
	if(name != null && name.length > 1 && name.match(/[a-zA-Z]/))
		return true;
	else
		return false;
}

function validateEmail(email) 
{ 
 var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
 return email.match(re);
};