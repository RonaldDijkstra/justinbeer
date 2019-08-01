$(document).ready(function () {

  function initialize() {
    var myLatlng = new google.maps.LatLng(53.2160138, 6.5646375);
    var imagePath = '/assets/images/maps-marker.png';
    var mapOptions = {
      zoom: 15,
      center: myLatlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
    };

    var map = new google.maps.Map(document.getElementById('map'), mapOptions);

    //Callout Content
    var contentString = 'Just in Beer Craft Beer Store';

    //Set window width + content
    var infowindow = new google.maps.InfoWindow({
      content: contentString,
      maxWidth: 500,
    });

    //Add Marker
    var marker = new google.maps.Marker({
      position: myLatlng,
      map: map,
      icon: imagePath,
      title: 'Just in Beer Craft Beer Store',
    });

    google.maps.event.addListener(marker, 'click', function () {
      infowindow.open(map, marker);
    });

    //Resize Function
    google.maps.event.addDomListener(window, 'resize', function () {
      var center = map.getCenter();
      google.maps.event.trigger(map, 'resize');
      map.setCenter(center);
    });
  }

  google.maps.event.addDomListener(window, 'load', initialize);

});
