// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// jQuery.ajaxSetup({ "beforeSend": function(xhr) { xhr.setRequestHeader("Accept", "text/javascript") } })

function check_for_confirmation(url) {

  $.ajax({
    url: url,
    cache: false,
    dataType: 'json',
    contentType: 'application/json',
    success: function(data, status, xhr) {
      if (!data.user.confirmed) {
        // continue polling
        setTimeout(function() { check_for_confirmation(url); }, 1500); // wait 15 seconds than call ajax request again
      } else {
        alert(data.user.toSource());
      }
    } 
  });
}

function show_searches(url) {
  $('#searches').load(url, function() {
    setTimeout(function() { show_searches(url); }, 15000);
  });
}

function show_lightbox() {
  
}
