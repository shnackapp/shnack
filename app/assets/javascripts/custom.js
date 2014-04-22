function forFans(){
	document.getElementById("info-tagline").innerHTML="Never miss a moment, never miss a meal"
	document.getElementById("info-text").innerHTML="Shnack is a mobile application designed for concessions at large and small scale events, that lets customers order and pay for a vendor's food via their phone. Shnack eliminates the time customers are spending standing in lines by providing a quick and elegant way to purchase food from your seat. Customers will order food from their phone and will be notified when their food is ready to be picked up. By eliminating the need to wait in line, we can increase customer satisfaction, increase vendor revenue, and ultimately help provide a superior experience to customers."
	document.getElementById("contact-us").style.display="None";
	document.getElementById("info-text").style.display="Block";
	//document.getElementById("phone").style.display="Block";

}

function forVendors(){
	document.getElementById("info-tagline").innerHTML="Access a whole new customer segment"
	document.getElementById("info-text").innerHTML="As a vendor nearly 10-15% of potential customers at any given event will pass on getting food if it means waiting in line or missing the action.  With Shnack you can give your customers the best possible experience and increase your concessions revenue.  Using our streamlined integration process, you can be set up in a matter of minutes and begin using Shnack to capture brand new customers and increase your concession sales."
	document.getElementById("contact-us").style.display="None";
	document.getElementById("info-text").style.display="Block";
}

function contactUs(){
	document.getElementById("info-tagline").innerHTML="Shnack is beautiful";
	document.getElementById("info-text").style.display="None";
	document.getElementById("contact-us").style.display="Block";
}