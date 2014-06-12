$(document).ready(function() {
	var stripeResponseHandler = function(status, response) {
	  var $form = $('#bank-form');

	  if (response.error) {
	    // Show the errors on the form
	    // $form.find('.payment-errors').text(response.error.message);
	    // $form.find('button').prop('disabled', false);
	   	$(".error").text(response.error.message);
	   	$(".error").slideDown(300);
	    console.log("hello you had an error");
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


	$("#bank-account-form").submit(function(event) {
		event.preventDefault();
		var $form = $(this);
    	$form.find('button').prop('disabled', true);

		Stripe.bankAccount.createToken({
			country: 'US',
			routingNumber: $("#routing_number").val(),
			accountNumber: $("#account_number").val()
		}, stripeResponseHandler);
		return false;

	} );




});