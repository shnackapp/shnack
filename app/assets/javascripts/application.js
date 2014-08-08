// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require modernizr
//= require jquery
//= require jquery_ujs
//= require jquery.mask.min
//= require_tree .

/*
function checkDevice() {
  var windowWidth = $(window).width();
  //alert(windowWidth);
  if (windowWidth <= 520) {
    mobileInfoText();
    $("#topbar").addClass("mobile");
    $("#topbar").children().each( function() {
      $(this).toggleClass("mobile");
    });
  }
}*/

$(function(){
    $('footer').hide();
    if($(document).height() <= $(window).height()){
        $('footer').show();
    }
    $(window).resize(function(){
        console.log("resized");
       if($(document).height() > $(window).height()){
           console.log("hide footer now");
            $('footer').slideUp('slow');
        }
        else{
            $('footer').slideDown('slow');
        }
    });
});



$(window).scroll(function(){        
    if ($(window).scrollTop() + $(window).height() >= $(document).height() - 0)
    {
            $('footer').slideDown('slow');
            $('#white2').stop().animate({
                bottom:'6px'
            },400);
    }
    else
    {
            $('footer').slideUp('slow');
            $('#white2').stop().animate({
                bottom:'-44px'
            },400);
    }
});

$(document).ready(function() {
    if ($(window).height() >= $(document).height() )
    {
        $('footer').data('size','hide');
    }
    else
    {
        $('footer').data('size','show');
    }
});

window.fbAsyncInit = function() {
        FB.init({
          appId      : '{461658543935056}',
          status     : true,
          xfbml      : true
        });
      };

      (function(d, s, id){
         var js, fjs = d.getElementsByTagName(s)[0];
         if (d.getElementById(id)) {return;}
         js = d.createElement(s); js.id = id;
         js.src = "//connect.facebook.net/en_US/all.js";
         fjs.parentNode.insertBefore(js, fjs);
       }(document, 'script', 'facebook-jssdk'));


function hideContactUsShowInfoText() {
  document.getElementById("contact-us").style.display="None";
  document.getElementById("info-text").style.display="Block";
}

function hideInfoTextShowContact() {
  document.getElementById("info-text").style.display="None";
  document.getElementById("contact-us").style.display="Block";
}
/*
function hideAboutLinks() {
  document.getElementById("about-links1").style.display="None";
  document.getElementById("about-links2").style.display="None";
}*/



/*
function mobileInfoText() {
    hideAboutLinks();
    document.getElementById("about-links3").style.width="100%";
    document.getElementById("about-links3").style.marginBottom="0px";
    document.getElementById("about-links3").style.marginTop="0px";

    document.getElementById("info-tagline").innerHTML="For a better fan experience";
    document.getElementById("info-text").innerHTML="Shnack is a mobile application designed for concessions at large and small scale events. Shnack eliminates the time customers are spending standing in lines by providing a quick and elegant way to purchase food from your seat. We can increase customer satisfaction, increase vendor revenue, and ultimately help provide a superior experience to customers."
}
*/
function forFans(){
  hideContactUsShowInfoText();
  document.getElementById("info-tagline").innerHTML="Never miss a moment, never miss a meal"
  document.getElementById("info-text").innerHTML="Shnack is a mobile application designed for concessions at large and small scale events, that lets customers order and pay for a vendor's food via their phone. Shnack eliminates the time customers are spending standing in lines by providing a quick and elegant way to purchase food from your seat. Customers will order food from their phone and will be notified when their food is ready to be picked up. By eliminating the need to wait in line, we can increase customer satisfaction, increase vendor revenue, and ultimately help provide a superior experience to customers."
}

function forVendors(){
  hideContactUsShowInfoText();
  document.getElementById("info-tagline").innerHTML="Access a whole new customer segment"
  document.getElementById("info-text").innerHTML="Nearly 10-15% of potential customers at any given event will pass on getting food if it means waiting in line or missing the action.  With Shnack you can give your customers the best possible experience and increase your concessions revenue.  Using our streamlined integration process, you can be set up in a matter of minutes and begin using Shnack to capture brand new customers and increase your concession sales."
}

function contactUs(){
  hideInfoTextShowContact();
  document.getElementById("info-tagline").innerHTML="Contact the Shnack Team";
}


