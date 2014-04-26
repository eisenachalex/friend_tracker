var geo_lat;
var geo_long;


function initialize()
{
var mapProp = {
  zoom:14,
  mapTypeId:google.maps.MapTypeId.ROADMAP
  };
var map=new google.maps.Map(document.getElementById("googleMap")
  ,mapProp);

if(navigator.geolocation) {
  navigator.geolocation.getCurrentPosition(function(position) {
    geo_lat = position.coords.latitude;
    geo_long = position.coords.longitude;
    initialLocation = new google.maps.LatLng(geo_lat,geo_long);
    map.setCenter(initialLocation);
  });
}



var bounds = new google.maps.LatLngBounds();

for (i = 0; i < gon.users.length; i++) {  
  marker = new google.maps.Marker({
    position: new google.maps.LatLng(gon.users[i].lat, gon.users[i].long),
    map: map
  });
    console.log(gon.users[i].lat)

  //extend the bounds to include each marker's position
  bounds.extend(marker.position);
  var infowindow = new google.maps.InfoWindow({
  });


  google.maps.event.addListener(marker, 'click', (function(marker, i) {
    return function() {
      infowindow.setContent(gon.users[i].username);
      infowindow.open(map, marker);
    }
  })(marker, i));
}

//now fit the map to the newly inclusive bounds
map.fitBounds(bounds);
}



$(document).ready(function() {
  $.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});
  $(document).on("submit", "form", function(e) {
    e.preventDefault();
    console.log(geo_lat,geo_long)
    $("#user_lat").val(geo_lat);
    console.log($("#user_lat").val());
    $("#user_long").val(geo_long);

    var url = $(this).attr("action");
    var data = $(this).serialize();

    $.post(url, data, function(data) {
       window.location = "/map"

    });

  })
})
