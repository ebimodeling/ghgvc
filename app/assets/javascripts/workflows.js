

$(function initialize() {
  var geocoder;
  var address;
  var latlng = new google.maps.LatLng(40.44,-95.98);
  var myOptions = {
    zoom: 4,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  // Google coordinate plane increases in the positive number direction left to right
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  var vegtype_bounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(-59,-176.8),
      new google.maps.LatLng(84,179)
  );
  var vegtype = new google.maps.GroundOverlay( 'http://pecandev.igb.illinois.edu/bety/main_overlay_80.png', vegtype_bounds);
  vegtype.setMap(map);

  
  //overlay = [];

  google.maps.event.addListener(vegtype, "click", function(event) { 
    console.log("google maps addListener triggered");
    
    //if ( overlay.length > 0 ) { overlay[0].setMap(null); overlay.length = 0; }
    
    var radius = $('#radius').val();
    var lat = event.latLng.lat();
    var lon = event.latLng.lng();

    var latOffset = radius/(69.1);
    var lonOffset = radius/(53.0);
    
    // Ajax post to get the biome number
    $.get("get_biome", { lng: Math.round(lon), lat: Math.round(lat) }, function(data) {
      console.log(data);
    });
    
    console.log("lon: " + lon + " lat: " + lat );
    //console.log("TopLeftCoord:     " + (lat + latOffset) + ", " + (lon + lonOffset) );
    //console.log("BottomRightCoord: " + (lat - latOffset) + ", " + (lon - lonOffset) );
    
    // 5 points are used to create a square 
    // 4 corners and then a 5th point at the 
    // exact coords of the first completing the shape
    var paths = [
       new google.maps.LatLng(lat + latOffset, lon + lonOffset), // top right
       new google.maps.LatLng(lat - latOffset, lon + lonOffset), // bottom right
       new google.maps.LatLng(lat - latOffset, lon - lonOffset), // bottom left
       new google.maps.LatLng(lat + latOffset, lon - lonOffset), // top left
       new google.maps.LatLng(lat + latOffset, lon + lonOffset)  // top right
    ];

    // Sends out the square object to google maps to be drawn
    //overlay.push( new google.maps.Polygon({
    //  paths: paths,
    //  strokeColor: "#ff0000",
    //  strokeWeight: 0,
    //  strokeOpacity: 1,
    //  fillColor: "#ff0000",
    //  fillOpacity: 0.2,
    //  clickable: false,
    //  map: map
    //}))
    
  })
  
})

