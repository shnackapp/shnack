
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

	/**
		The following 4 functions refocus the user's selected input as 
		they go through the credit card form
	**/

	$('#credit_card_number').keypress(function(e) {

		if(e.which<48 || e.which > 57) {
			e.preventDefault();
		} 

	});


	$("#expiration_month").keypress(function(e) {
		if(e.which<48 || e.which > 57 || $(this).val().length == 2) {
			e.preventDefault();
		} 
	});



	$("#expiration_year").keypress(function(e) {
		if(e.which<48 || e.which > 57  || $(this).val().length == 2) {
			e.preventDefault();
		} 
	});

	$("#security_code").keypress(function(e) {
		if(e.which < 48 || e.which > 57 || $(this).val().length > 3) {
			e.preventDefault();
		}
	});
	//END CREDIT CARD FORM FOCUS FUNCTIONS

	if($("[name='user_card']")[0]) {
		$('.new-card-form').hide();
	}


	$("[name='user_card']").change(function (evt) {
		if($(this).is('#new-card-button')) { 
			$('.new-card-form').slideDown(300);
		}
		else {
			$('.new-card-form').slideUp(300);
		}
	})


	/** 
		The following set of functions are for when the user isn't signed in and can either
		log in or create an account

	**/
	$("#login-form").hide();

	$("#log-in").click(function(evt) {
		$("#create-account-div").hide();
		$("#login-form").show();
		$("#log-in").addClass("red");
		$("#create-account").removeClass("red");

		$(".name-error").slideUp(200);
			$("#order-name").removeClass("error");
			$(".phone-error").slideUp(200);
			$("#order-phone-number").removeClass("error");
			$(".email-error").slideUp(200);
			$("#order-email").removeClass("error");
	});

	$("#create-account").click(function(evt) {
		$("#create-account-div").show();
		$("#login-form").hide();
		$("#log-in").removeClass("red");
		$("#create-account").addClass("red");

		$(".name-error").slideUp(200);
		$("#order-name").removeClass("error");
		$(".phone-error").slideUp(200);
		$("#order-phone-number").removeClass("error");
		$(".email-error").slideUp(200);
		$("#order-email").removeClass("error");	
	});

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

   /**
	This method just got really complicated. So there are 2 possible times this thing is called.

	1. It's for the create_account_form
	2. It's for the select-card-form

	In case 1, just check if the card is valid
	if yes, submit create-account-form

	Case 2:
		Check if it's the checked option. If so,



   **/

	$("#credit-card-form").submit(function(event) {
		event.preventDefault();
		var $form = $(this);

		var main_form = $(this).data("form");

		if(main_form == "create-account-form") {

			Stripe.card.createToken({
					number: $("#credit_card_number").val(),
					cvc: $("#security_code").val(),
					exp_month: $("#expiration_month").val(),
					exp_year: $("#expiration_year").val()
				}, 

				//Response handler
				function(status, response) {
				  var $form = $('#create-account-form');

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
			});
		}
		else if(main_form == "select-card-form") {

			if(!$("input[name='user_card']")[0] || $("input[name='user_card']:checked").is('#new-card-button')) {	
		    	$form.find('button').prop('disabled', true);

				Stripe.card.createToken({
					number: $("#credit_card_number").val(),
					cvc: $("#security_code").val(),
					exp_month: $("#expiration_month").val(),
					exp_year: $("#expiration_year").val()
				}, 
				function(status, response) {
					var $form = $('#select-card-form');

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
				});			
			}
			else {
				var $form = $('#select-card-form'); 

				var index = $("input[name='user_card']:checked").val();
				$form.append($('<input type="hidden" name="stripeCardIndex" />').val(index));
	    		$form.get(0).submit();
			}


		}

	});


	$("#order-name").keyup(function(e) {
		var name_valid = validateName($(this).val());
		if(name_valid && validatePhoneNumber($("#order-phone-number").val()) && validateEmail($("#order-email").val()) && validatePassword($("#order-password").val())) {
			enableButton();
		}
	});


   $("#order-phone-number").keypress(function(e) {
   		if(e.which<48 || e.which > 57) {
   			e.preventDefault();
   		}
   		else {
   			var phone_valid = validatePhoneNumber($("#order-phone-number").val());
			if(phone_valid) {
				if(validateName($("#order-name").val())) {
					var valid_email;
					if($("#order-email")[0]) {
						email_valid = validateEmail($("#order-email").val());
					}
					else {
						email_valid = true;
					}
					if(email_valid) {
						enableButton();
					}
				}
			}
   		}

   	$("#order-email").keyup(function(e) {
   		var email_valid = validateEmail($("#order-email").val());
   		if(email_valid && validatePhoneNumber($("#order-phone-number").val()) && validateName($("#order-name").val()) && validatePassword($("#order-password").val())) {
   			enableButton();
   		}


   	});
 

   	$("#order-password").keyup(function(e) {
   		var password_valid = validatePassword($("#order-password").val());
   		if(password_valid && validatePhoneNumber($("#order-phone-number").val()) && validateName($("#order-name").val()) && validateEmail($("#order-email").val())) {
   			enableButton();
   		}

   	});

   });
   $("#order-phone-number").mask("(000) 000-0000");
   $("#credit_card_number").mask("0000 0000 0000 0000");
   
   if(!validateName($("#order-name").val()) || !validatePhoneNumber($("#order-phone-number").val()) )
   { 
   		disableButton();
   }


   /**
  		The following functions go along as the user enters their phone and name information
  		If it's filled out, then it enables the submit button
  	**/
	
	$("#order-name").blur(function(e){
		var name_valid = validateName($("#order-name").val());
		var phone_valid = validatePhoneNumber($("#order-phone-number").val());
		var email_valid;
		if($("#order-email")[0]) {
			email_valid = validateEmail($("#order-email").val());
		}
		else {
			email_valid = true;
		}

		var password_valid;
		if($("#order-password")[0]) {
			password_valid = validatePassword($("#order-password").val());
		}
		else {
			password_valid = true;
		}


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
		if(name_valid && phone_valid && email_valid && password_valid) {
			$(".name-error").slideUp(200);
			$("#order-name").removeClass("error");
			$(".phone-error").slideUp(200);
			$("#order-phone-number").removeClass("error");
			$(".email-error").slideUp(200);
			$("#order-email").removeClass(error);
			$(".password-error").slideUp(200);
			$("#order-password").removeClass("error");
			enableButton();
		}
	});
	$("#order-phone-number").blur(function(e){
		var phone_valid = validatePhoneNumber($("#order-phone-number").val());
		var name_valid = validateName($("#order-name").val());


		var email_valid;
		if($("#order-email")[0]) {
			email_valid = validateEmail($("#order-email").val());
		}
		else {
			email_valid = true;
		}

		var password_valid;
		if($("#order-password")[0]) {
			password_valid = validatePassword($("#order-password").val());
		}
		else {
			password_valid = true;
		}


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

		if(name_valid && phone_valid && email_valid && password_valid)
		{
			$(".name-error").slideUp(200);
			$("#order-name").removeClass("error");
			$(".phone-error").slideUp(200);
			$("#order-phone-number").removeClass("error");
			$(".email-error").slideUp(200);
			$("#order-email").removeClass(error);
			$(".password-error").slideUp(200);
			$("#order-password").removeClass("error");
			enableButton();
		}
	});


	$("#order-email").blur(function(e) { 
		var phone_valid = validatePhoneNumber($("#order-phone-number").val());
		var name_valid = validateName($("#order-name").val());
		var email_valid = validateEmail($("#order-email").val());

		var password_valid;
		if($("#order-password")[0]) {
			password_valid = validatePassword($("#order-password").val());
		}
		else {
			password_valid = true;
		}

		if(!email_valid) {
			e.preventDefault();
			$(".email-error").slideDown(200);
			$("#order-email").addClass("error");
			disableButton();
		}

		if(email_valid) {
			$(".email-error").slideUp(200);
			$("#order-email").removeClass("error");
		}
		if(name_valid && phone_valid && email_valid && password_valid)
		{
			$(".name-error").slideUp(200);
			$("#order-name").removeClass("error");
			$(".phone-error").slideUp(200);
			$("#order-phone-number").removeClass("error");
			$(".email-error").slideUp(200);
			$("#order-email").removeClass(error);
			enableButton();
		}

	}); 

	$("#order-password").blur(function(e) {
		var phone_valid = validatePhoneNumber($("#order-phone-number").val());
		var name_valid = validateName($("#order-name").val());
		var email_valid = validateEmail($("#order-email").val());

		var password_valid = validatePassword($("#order-password").val());
		

		if(!password_valid) {
			e.preventDefault();
			$(".password-error").slideDown(200);
			$("#order-password").addClass("error");
			disableButton();
		}

		if(password_valid) {
			$(".password-error").slideUp(200);
			$("#order-password").removeClass("error");
		}

		if(name_valid && phone_valid && email_valid && password_valid)
		{
			$(".name-error").slideUp(200);
			$("#order-name").removeClass("error");
			$(".phone-error").slideUp(200);
			$("#order-phone-number").removeClass("error");
			$(".email-error").slideUp(200);
			$("#order-email").removeClass(error);
			$(".password-error").slideUp(200);
			$("#order-password").removeClass("error");
			enableButton();
		}

	});


});



function enableButton() {
   $("#pay-button").prop('disabled', false);
   $("#confirm-button").prop('disabled', false);
}

function disableButton() {
   $("#pay-button").prop('disabled', true);
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

function validatePassword(password)
{
	if(password != null && password.length >= 6) {
		return true;
	}
	else 
		return false;
};