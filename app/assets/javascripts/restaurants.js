
// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
/* NOTE could clean this up, add to restuarant js */

$(document).ready(function() {
  $('#size_mod_table').hide();
  var hidden = true;
  $('#size_mod_btn').click(function() {
    if(hidden) { $('#size_mod_table').show(); hidden=false; }
    else { $('#size_mod_table').hide(); hidden=true; }
  });
});

$(document).ready(function() {
  $('#single_select_mod_table').hide();
  var hidden = true;
  $('#single_select_mod_btn').click(function() {
    if(hidden) { $('#single_select_mod_table').show(); hidden=false; }
    else { $('#single_select_mod_table').hide(); hidden=true; }
  });
});

$(document).ready(function() {
  $('#multiple_select_mod_table').hide();
  var hidden = true;
  $('#multiple_select_mod_btn').click(function() {
    if(hidden) { $('#multiple_select_mod_table').show(); hidden=false; }
    else { $('#multiple_select_mod_table').hide(); hidden=true; }
  });
});
