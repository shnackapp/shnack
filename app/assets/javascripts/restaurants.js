
$(document).ready(function() {
	
	Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));

	$("#verify_bank_details").click(function(e) {
		e.preventDefault();
		Stripe.bankAccount.createToken({
			country: 'US',
			routingNumber: $('#routing_number').val(),
    		accountNumber: $('#bank_number').val(),
		}, function(status, response) {
			//Set recipient id
			if(status == 200) {
				$("#bank_account_stripe_token").val(response.id);
			}
			else{
				//Else there was an error
				$(".error").html(response.error.message);
				$(".error").slideDown();


			}	


		});

	});

});