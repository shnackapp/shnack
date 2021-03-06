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


$(function(){ 

    $('footer.popup-banner').hide();
    if($(document).height() <= $(window).height()){
        $('footer.popup-banner').show();
    }
    $(window).resize(function(){
        console.log("resized");
       if($(document).height() > $(window).height()){
           console.log("hide footer now");
            $('footer.popup-banner').slideUp('slow');
        }
        else{
            $('footer.popup-banner').slideDown('slow');
        }
    });
});



$(window).scroll(function(){        
    if ($(window).scrollTop() + $(window).height() >= $(document).height() - 0)
    {
            $('footer.popup-banner').slideDown('slow');
            $('#white2').stop().animate({
                bottom:'6px'
            },400);
    }
    else
    {
            $('footer.popup-banner').slideUp('slow');
            $('#white2').stop().animate({
                bottom:'-44px'
            },400);
    }
});

$(document).ready(function() {

  $("input[type=tel]").mask("(000) 000-0000");

  $("a[href='#top_now']").click(function() {
    $("html, body").animate({ scrollTop: 0 }, "slow");
    return false;
  });

  if ($(window).height() >= $(document).height() ) {
      $('footer.popup-banner').data('size','hide');
  } else {
      $('footer.popup-banner').data('size','show');
  }


  $(".expandable").next().hide();
  $(".expandable").click(function() {
     $(this).next().slideToggle(200);
     $(this).toggleClass("expanded");
   });
  
  $("[data-js=expandable]").next().hide();
  $("[data-js=expandable]").click(function() {
     $(this).next().slideToggle(200);
     $(this).toggleClass("expanded");
   });
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

