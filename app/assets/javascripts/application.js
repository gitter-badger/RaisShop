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
//= require jquery
//= require jquery.ui.autocomplete
//= require jquery_ujs
//= require bootstrap
// require rails.validations
// require rails.validations.simple_form
//= require jquery-star-rating
//= require_tree .
// require turbolinks
//

$(function (){

  $("#search-query").autocomplete({
    source: "/search_suggestions",
    minLength: 2,
    focus: function(event, ui) {
      $('#search-query').val(ui.item.title);
    },
    select: function(event, ui) {
      window.location.replace('/' + ui.item.id);
    }
  }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
    return $( "<li></li>" )
    .data( "item.autocomplete", item )
    .append("<a><img class=\"autocomplete_image\" src=/assets/" + item.image_url + "/>" +
              "<div class=\"autocomplete_details\">" +
              "<div class=\"autocomplete_title\">" + item.title + "</div>" +
              "<div class=\"autocomplete_price\">" + item.price + " USD</div></div></a>")
    .appendTo( ul );
  };
});
