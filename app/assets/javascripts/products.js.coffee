# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

#jQuery ->
  #$("#search-query").autocomplete
    #source: '/search_suggestions'
    #

jQuery ->
  if $('#endless_paginate').attr('on') == 'true'
    alert("fdshjfdhghsgljkdshlghsdhglsd")
    $(window).scroll ->
      url = $('.pagination .next_page a').attr('href')
      if url && $(window).scrollTop() > $(document).height() -
                                        $(window).height() - 200
        $('.pagination').text('Loading...')
        $.getScript(url)
    $(window).scroll()
