id_seed = 0;
function generate_id() { return id_seed++ };

function remove_google_maps_pin(biome_site_id){
  if ( markersArray[biome_site_id] != undefined ) { markersArray[biome_site_id].setMap(null) };
};

function activate_biome_location ( obj ){
    $('#biome_input_container').find('div.well').addClass('inactive_site');
    
    hide_inactive_biome_checkboxes();
    
    $('label.checkbox').find('input').attr("disabled", "false");
    //$('label.checkbox').find('input').removeAttr("disabled");
    obj.removeClass('inactive_site');
    obj.find('input').show();
    obj.find('label').show();
    obj.prependTo("#biome_input_container")
};

function place_google_maps_pin( lat, lng, biome_site_id ){
  // remove any markers tied to a biome_site_id
  remove_google_maps_pin(biome_site_id);

  // generate a new marker
  var marker = new google.maps.Marker({ position: new google.maps.LatLng( lat , lng ) });
  // push the marker into the storage array
  markersArray[biome_site_id] = marker;
  
  // Add listener to activate a biome location on clicking the corresponding map marker
  google.maps.event.addListener( markersArray[biome_site_id], 'click', function() {
    activate_biome_location( $('#biome_instance-' + biome_site_id) );
  });
  
  return marker
};

function initalize_google_map(lat, lng, zoom){
  var type = $(document).find('.map_type_selector.active').html().toLowerCase();
  console.log('initalize_google_map: '+ type);

  var minZoomLevel = 2;
  var geocoder;
  var address;
  var latlng = new google.maps.LatLng(31,-15);
  var myOptions = {
    zoom: minZoomLevel,
    streetViewControl: false,
    mapTypeControl: false,
    panControl: false,
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
  var globalbiomes = new google.maps.GroundOverlay( '../globalbiomes_overlay.png', globalbiomes_bounds, overlayOptions);
  // setup of vegtype map  
  var vegtype_bounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(-59,-176.8), // south-west
    new google.maps.LatLng(84,179) // north-east
//        new google.maps.LatLng(-50,-124.8), // south-west
//        new google.maps.LatLng(80,115) // north-east  

  );
  var vegtype = new google.maps.GroundOverlay( '../vegtype_overlay.png', vegtype_bounds, overlayOptions );
 
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
  
  // Bounds for A single map
   var strictBounds = new google.maps.LatLngBounds(
     new google.maps.LatLng(-70, -170), // bottom-left
     new google.maps.LatLng(70, 170)   // top-right
   );

   // Listen for the map click events
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
  
  markersArray = [];
  google.maps.event.addListener(vegtype, "click", function(event) {
    console.log("google maps addListener triggered");

    //if ( overlay.length > 0 ) { overlay[0].setMap(null); overlay.length = 0; }

    var radius = $('#radius').val();
    var lat = event.latLng.lat();
    var lon = event.latLng.lng();

    var latOffset = radius/(69.1);
    var lonOffset = radius/(53.0);

    // clear out existing biome matches
    $('#biome_input_container').find('div.well:not(.inactive_site)').find('div[class*="_biomes"]').find('.biome_list').html("");
    
    // Ajax post to get the biome number
    $.get("/get_biome", { lng: Math.round(lon), lat: Math.round(lat) }, function(data) {     
      
      var active_biome_site = $('div[id|="biome_instance"]:not(inactive_site)').attr('id').split('-').pop()
      
      console.log( "active site id: " + active_biome_site );
      
      marker = place_google_maps_pin( lat, lon, active_biome_site );
      marker.setMap(map); // To add the marker to the map, call setMap();
      
      console.log(data["native"]);
      console.log(data["agroecosystems"]);
      console.log(data["biomes"]);
      console.log(data["biofuels"]);
      
      // Tag the site w the given lat and lng
      $('div.well:not(.inactive_site)').find('.site_latlng').text("( "+ lat.toFixed(2) + ", " + lon.toFixed(2) + " )");
      
      
      
//      if (data["biomes"] != undefined ) {
//        $('div.well:not(.inactive_site)').find('.native_biomes').find('.biome_list').append(
//          '<label class="checkbox"><input type="checkbox">' + data["native"].name + '</input></label>'
//        ).parent().css("height", "auto");
//      };
      
      if (data["native"].length > 0 ) {
        $.each( data["native"] , function(k,v){      
          $('div.well:not(.inactive_site)').find('.native_biomes').find('.biome_list').append(
            '<div class="biome_match">' +
              '<label class="checkbox inline-block"><input type="checkbox" class="inline-block">' + v + 
              '</input></label><a data-toggle="lightbox" href="#biome_popup"><i class="icon-search icon-list-alt inline-block edit_icon" rel="tooltip" title="edit"></i></a>' + 
            '</div>'
          ).parent().css("height", "auto");
        });
      };
      
      if (data["biofuels"].name.length > 0 ) {
        $.each( data["biofuels"].name.split(',') , function(k,v){      
          $('div.well:not(.inactive_site)').find('.biofuels_biomes').find('.biome_list').append(
            '<div class="biome_match">' +
              '<label class="checkbox inline-block"><input type="checkbox" class="inline-block">' + v + 
              '</input></label><a data-toggle="lightbox" href="#biome_popup"><i class="icon-search icon-list-alt inline-block edit_icon" rel="tooltip" title="edit"></i></a>' + 
            '</div>'
          ).parent().css("height", "auto");
        });
      };
      
      if (data["agroecosystems"].name.length > 0 ) {
        $.each( data["agroecosystems"].name.split(',') , function(k,v){      
          $('div.well:not(.inactive_site)').find('.agroecosystems_biomes').find('.biome_list').append(
            '<div class="biome_match">' +
              '<label class="checkbox inline-block"><input type="checkbox" class="inline-block">' + v + 
              '</input></label><a data-toggle="lightbox" href="#biome_popup"><i class="icon-search icon-list-alt inline-block edit_icon" rel="tooltip" title="edit"></i></a>' + 
            '</div>'
          ).parent().css("height", "auto");
        });
      };
      
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

function populate_biome_popup( biome_name ){
  $("#biome_popup").find(".lightbox-content").each(function(){
    $(this).find(".popup_heading").text( biome_name )
    ecosystems = $.parseJSON( $("#ecosystem_json_store").text() )
    console.log(biome_name);
    // here I'd like to be able to do ecosystems["temperate forest"]
    
  })
}

function open_previous_biome_site(){
  console.log('opening previous site');
  $('#biome_input_container').find('div.well').first().removeClass('inactive_site');
};

function hide_inactive_biome_checkboxes(){
  $('#biome_input_container').find('div.well').find('label.checkbox').each(function(){
    if ( $(this).find('input').is(':checked') == false ){
      $(this).hide();
    }
  });
};

function show_inactive_biome_checkboxes(){
  $('#biome_input_container').find('div.well').find('label.checkbox').each(function(){
    if ( $(this).find('input') ){
      $(this).show();
    }
  });
};



$(document).ready(function() {
  initalize_google_map();
  
  $("#biome_input_container").delegate('.edit_icon', "click" , function() {
    biome = $("i.edit_icon").eq(0).closest(".biome_match").find("label.checkbox").text();
    populate_biome_popup( biome );
  });

  $('#add_additional_biome_site').on('click', function(){
    // Mark all biomes as INACTIVE    
    $('#biome_input_container').find('div.well').addClass('inactive_site');

    // Add in new biome site, which will be ACTIVE 
    $('#biome_input_container').prepend(
      '<div id="biome_instance-' + generate_id() + '" class="well well-small collapsed">' +
      '  <div class="biome_site_header inline-block"><h4>Location Lat/Lng: <span class="site_latlng">( -- , -- )</span></h4></div>' + 
      '  <div class="remove_biome_site btn btn-small btn-danger inline-block pull-right">' + 
      '    <i class="icon-search icon-remove"></i> Remove Location' +
      '  </div>' + '  <br />' + '<hr/>' +
      '  <div class="native_biomes inline-block">' + '    <b>Native:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
      '  <div class="aggrading_biomes inline-block">' + '    <b>Aggrading:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
      '  <div class="agroecosystems_biomes inline-block">' + '    <b>Agroecosystems:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
      '  <div class="biofuels_biomes inline-block">' + '    <b>Biofuels:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
      '</div>'
    ).delegate(".remove_biome_site", "click", function() {
      remove_google_maps_pin( $(this).parent().attr('id').split('-').pop() );
      $(this).parent().remove();
      open_previous_biome_site();
    });
    
    hide_inactive_biome_checkboxes();
     
  
  });
  // Add inital biome list using above code:
  $('#add_additional_biome_site').trigger('click');

  
  // handles reactivating a site when selected
  $('#biome_input_container').on("click", ".inactive_site" , function(){
    activate_biome_location( $(this) );
  });

  $(".biome_list").tooltip({
    'selector': 'i',
    'placement': 'right'
  });

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
