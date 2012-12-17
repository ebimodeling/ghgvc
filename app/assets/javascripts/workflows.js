

function initalize_google_map(lat, lng, zoom){
  var type = $(document).find('.map_type_selector.active').html().toLowerCase();
  console.log('initalize_google_map: '+ type);

  var minZoomLevel = 2;
  var geocoder;
  var address;
  var latlng = new google.maps.LatLng(31,-26);
  var myOptions = {
    zoom: minZoomLevel,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var overlayOptions = {
    opacity: 0.6,
  }

  // Google coordinate plane increases in the positive number direction left to right
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  // setup of globalbiomes map  
  var globalbiomes_bounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(-92,-179 ), // south-west
    new google.maps.LatLng(84.8,178.7) // north-east
  );
  var globalbiomes = new google.maps.GroundOverlay( 'globalbiomes_overlay.png', globalbiomes_bounds, overlayOptions);
  // setup of vegtype map  
  var vegtype_bounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(-59,-176.8), // south-west
    new google.maps.LatLng(84,179) // north-east
  );
  var vegtype = new google.maps.GroundOverlay( 'vegtype_overlay.png', vegtype_bounds, overlayOptions );
 
  // clear out existing biome matches
  //$('div[id*="_biomes"]').hide();
  $('div[id*="_biomes"]').find('.biomes').html("");
  
  if (type == "vegtype" ){
    vegtype.setMap(map);
  } else if (type == "globalbiomes" ) {
    globalbiomes.setMap(map);
  } else {
    // no map overlay
  }
  
  //overlay = [];
  
  // Bounds for North America
   var strictBounds = new google.maps.LatLngBounds(
     new google.maps.LatLng(-70, -170), // bottom-left
     new google.maps.LatLng(70, 170)   // top-right
   );

   // Listen for the dragend event
   google.maps.event.addListener(map, 'dragend', function() {
     if (strictBounds.contains(map.getCenter())) return;

     // We're out of bounds - Move the map back within the bounds
     var c = map.getCenter(),
         x = c.lng(),
         y = c.lat(),
         maxX = strictBounds.getNorthEast().lng(),
         maxY = strictBounds.getNorthEast().lat(),
         minX = strictBounds.getSouthWest().lng(),
         minY = strictBounds.getSouthWest().lat();

     if (x < minX) x = minX;
     if (x > maxX) x = maxX;
     if (y < minY) y = minY;
     if (y > maxY) y = maxY;

     map.setCenter(new google.maps.LatLng(y, x));
   });

   // Limit the zoom level
   google.maps.event.addListener(map, 'zoom_changed', function() {
     if (map.getZoom() < minZoomLevel) map.setZoom(minZoomLevel);
   });
  
  google.maps.event.addListener(vegtype, "click", function(event) {
    console.log("google maps addListener triggered");

    //if ( overlay.length > 0 ) { overlay[0].setMap(null); overlay.length = 0; }

    var radius = $('#radius').val();
    var lat = event.latLng.lat();
    var lon = event.latLng.lng();

    var latOffset = radius/(69.1);
    var lonOffset = radius/(53.0);

    // clear out existing biome matches
    $('div[id*="_biomes"]').find('.biome_list').html("");

    // Ajax post to get the biome number
    $.get("get_biome", { lng: Math.round(lon), lat: Math.round(lat) }, function(data) {     
      console.log(data["native"]);
      console.log(data["biofuels"]);
      // find a 
      if (data["native"] != undefined ) {
        $('#native_biomes').find('.biome_list').append('<label class="checkbox"><input type="checkbox">' + data["native"].name + '</input></label>');
      }
      
      if (data["biofuels"] != undefined ) {
        $('#biofuels_biomes').find('.biome_list').append('<label class="checkbox"><input type="checkbox">' + data["biofuels"].name + '</input></label>');
      }
      
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

  });
  
}

$(document).ready(function() {
  initalize_google_map();

  $('#add_additional_biome_site').on('click', function(){
    // All other biome lists
    
    $('#biome_input_container').find('div.well').css("height","100px").find('div[id*="_biomes"]').css("height","50px");
    $('#biome_input_container').find("div.well").css("background-color","darkGray").css("color","gray").addClass("inactive_site").find('input').attr("disabled", "false");
      // deactivate the "checked" checkboxes
      // hide  "unchecked"

    // Add in new biome site
    $('#biome_input_container').prepend(
      '<div class="well well-small">' +
      '  <div class="biome_site_header inline-block"><h4>Site Lat/Lng: -45.8, 90.88</h4></div>' + 
      '  <div class="remove_biome_site btn btn-small btn-danger inline-block pull-right">' + 
      '    <i class="icon-search icon-remove"></i> Remove Site' +
      '  </div>' +
      
      '  <br />' + '<hr/>' +
      '  <div id="native_biomes" class="inline-table">' + '    <b>Native:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
      '  <div id="aggrading_biomes" class="inline-table">' + '    <b>Aggrading:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
      '  <div id="agroecosystems_biomes" class="inline-table">' + '    <b>Agroecosystems:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
      '  <div id="biofuels_biomes" class="inline-table">' + '    <b>Biofuels:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
      '</div>'
    );

    $('div.well').first().delegate(".remove_biome_site", "click", function() {
      $(this).toggleClass("chosen");
      $(this).parent().remove();
    });
  
  });
  // Add inital biome list using above code:
  $('#add_additional_biome_site').trigger('click');

  $('.map_type_selector').on('click', function () {
    $(document).find('.map_type_selector').removeClass('active');
    $(this).addClass('active');
    
    // clear out existing biome matches
    $('div[id*="_biomes"]').hide();
    $('div[id*="_biomes"]').find('.biomes').html("");
  
    console.log(map.getZoom());
    console.log("lat: " + map.getCenter().lat() );
    console.log("lng: " + map.getCenter().lng() );
    
    initalize_google_map();
  });
  
});
