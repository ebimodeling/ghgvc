var id_seed = 0;
function generate_id() { return id_seed++; };

function remove_google_maps_pin( biome_site_id ) {
  if ( markersArray[biome_site_id] != undefined ) { markersArray[biome_site_id].setMap(null) };
};

function activate_biome_location( obj ){
    $('#biome_input_container').find('div.well').addClass('inactive_site');
    
    hide_inactive_biome_checkboxes();
    
    $('label.checkbox').find('input').attr("disabled", "false");
    //$('label.checkbox').find('input').removeAttr("disabled");
    obj.removeClass('inactive_site');
    obj.find('input').show();
    obj.find('label').show();
    obj.prependTo("#biome_input_container")
};


// Called everytime a user clicks on google maps
// Handles whether to keep a given marker at a lat/lng or remove it
function place_google_maps_pin( lat, lng, biome_site_id ) {
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

function populate_html_from_latlng( lat, lng ){

  $.get("/get_biome", { lng: Math.round(lng), lat: Math.round(lat) }, function(data) {
    // find the first div#biome_instance without .inactive_site ... and grab the id number
    var active_biome_site = $('div[id|="biome_instance"]:not(inactive_site)').attr('id').split('-').pop()

//    console.log( data );
//    console.log(data["native_eco"]);
//    console.log(data["agroecosystem_eco"]);
//    console.log(data["aggrading_eco"]);
//    console.log(data["biofuel_eco"]);
    
    $('#biome_instance-'+active_biome_site).prepend(
      '<div class="json_store" style="display:none">' + JSON.stringify(data) + '</div>' // stringify will work with IE8 +
    )
    
    marker = place_google_maps_pin( lat, lng, active_biome_site );
    marker.setMap(map); // To add the marker to the map, call setMap();

    // Tag the site w the given lat and lng
    $('div.well:not(.inactive_site)').find('.site_latlng').text("( "+ lat.toFixed(2) + ", " + lng.toFixed(2) + " )");
    
    if ( data.native_eco != null ) {
      $.each( data.native_eco, function(k,v){
        $('div.well:not(.inactive_site)').find('.native_biomes').find('.biome_list').append(
          '<div class="biome_match">' +
            '<label class="checkbox inline-block"><input type="checkbox" class="inline-block">' + k.replace("_"," ") + 
            '</input></label><a data-toggle="lightbox" href="#ecosystem_popup"><i class="icon-search icon-list-alt inline-block edit_icon" rel="tooltip" title="edit"></i></a>' + 
          '</div>'
        ).parent().css("height", "auto");
      });
    };
    
    if ( data.biofuel_eco != null ) {
      $.each( data.biofuel_eco, function(k,v){
        $('div.well:not(.inactive_site)').find('.biofuel_biomes').find('.biome_list').append(
          '<div class="biome_match">' +
            '<label class="checkbox inline-block"><input type="checkbox" class="inline-block">' + k.replace("_"," ") + 
            '</input></label><a data-toggle="lightbox" href="#ecosystem_popup"><i class="icon-search icon-list-alt inline-block edit_icon" rel="tooltip" title="edit"></i></a>' + 
          '</div>'
        ).parent().css("height", "auto");
      });
    };
    
    if ( data.agroecosystem != null ) {
      $.each( data.agroecosystem_eco, function(k,v){ 
        $('div.well:not(.inactive_site)').find('.agroecosystem_biomes').find('.biome_list').append(
          '<div class="biome_match">' +
            '<label class="checkbox inline-block"><input type="checkbox" class="inline-block">' + k.replace("_"," ") + 
            '</input></label><a data-toggle="lightbox" href="#ecosystem_popup"><i class="icon-search icon-list-alt inline-block edit_icon" rel="tooltip" title="edit"></i></a>' + 
          '</div>'
        ).parent().css("height", "auto");
      });
    };
   

  });
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
    var lng = event.latLng.lng();

    // clear out existing biome matches
    $('#biome_input_container').find('div.well:not(.inactive_site)').find('div[class*="_biomes"]').find('.biome_list').html("");
    
    // Gets JSON data with all ecosystems within a given location
//    http://localhost:3000/get_biome.json?lng=&lat=

    populate_html_from_latlng( lat, lng );
    
//    $.get("/get_biome", { lng: -4.978971, lat: 39.16113 }, function(data) {  // for offline testing
  });
};

// This function swaps out the abbreviated data source names
// for the full names: "s000" = "Anderson-Teixeira and DeLucia (2011)" 
// Expecting input formatted as:
// {"s000":234,"s001":9992}
function populate_fullname_in_data_source( csep_value ) {

  $.each( csep_value, function( sources_key, sources_value) {
    switch ( sources_key ) { 
      case "s000": 
        csep_value["Anderson-Teixeira and DeLucia (2011)"] = sources_value;
        delete csep_value.s000
        break;
      case "s001": 
        csep_value["Saatchi and others (2011)"] = sources_value;
        delete csep_value.s001
        break; 
    }
  });
  return csep_value;
};

function populate_biome_popup( site_id, biome_type, biome_name ) {
  $("#ecosystem_popup").find(".lightbox-content").each(function() {
    $(this).find(".popup_heading").text( biome_name.replace("_", " ") )

    // get the ecosystems from that biome_instance
    var ecosystems = $.parseJSON( $('#biome_instance-' + site_id).find('.json_store').text() )    
    
    // then spool through entries to populate the CSEPs

   
    // with all data sources ( EX: "s001" )
    var current_ecosystem = ecosystems[biome_type + "_eco"][biome_name.replace(" ", "_")];

    // For the current_ecosystem ( EX: "miscanthus" )
    $.each( current_ecosystem, function( csep_key, csep_value ){
      // Find the row corresponding to a CSEP value ( EX: "OM_ag")
      $.each( $('#ecosystem_edit').find('tr#' + csep_key), function(){
        var csep_row = $(this)
        
        // Since we've got place holders for the source names such as "s000"
        // Instead of the desired "Anderson-Teixeira and DeLucia (2011)"
        csep_value = populate_fullname_in_data_source(csep_value)

        // Add in a custom dropdown option for users to add their own inputs
        csep_value['custom'] = 'custom'

        // Finally the value of each CSEP is a hash
        // which contains multiple data sources
        // loop through those sources and place them within the dropdown
        $.each( csep_value, function( sources_key, sources_value) {
          csep_row.find('.popup_cite_dropdown').append( $("<option></option>").attr("value", sources_value).text(sources_key) );
        });
        
        // Set the associated field to the default value
        $(this).find('.popup_value_field').val(csep_value["Anderson-Teixeira and DeLucia (2011)"])
      });
    
    });

      

  })
}

function open_previous_biome_site(){
  $('#biome_input_container').find('div.well').first().removeClass('inactive_site');
};

function hide_inactive_biome_checkboxes(){
  $('#biome_input_container').find('div.well').find('label.checkbox').each( function() {
    if ( $(this).find('input').is(':checked') == false ) {
      $(this).hide();
    }
  });
};

function show_inactive_biome_checkboxes(){
  $('#biome_input_container').find('div.well').find('label.checkbox').each( function() {
    if ( $(this).find('input') ) {
      $(this).show();
    }
  });
};



$(document).ready(function() {
  initalize_google_map();
  
  $('.popup_cite_dropdown').change( function() {
    // Assign the selected value in the drop down, to the subling input box
    $(this).parentsUntil('tbody').find('.popup_value_field').val( $(this).val() )
  });
  $('.popup_value_field').on('click', function() {
    // Assign the selected value in the drop down, to the subling input box
    $(this).parentsUntil('tbody').find('.popup_cite_dropdown').val("custom")
  });
  
  
  
  $("#popup_save_ecosystem_modifications").on('click', function() {
    // get all fields / values
    console.log( $('#ecosystem_edit').find('.popup_value_field') );
    // convert them to JSON and write out into
//    $('#ecosystem_json_store').text()
  })
  
  $("#biome_input_container").delegate('.edit_icon', "click" , function() {
    var site_id = $(this).closest('[id]|="biome_instance"').attr("id").split("-")[1]
    var biome_name = $(this).closest(".biome_match").find("label.checkbox").text();
    var biome_type = $(this).closest("[class*='_biomes']").attr("class").split(" ")[0].split("_")[0]
    populate_biome_popup( site_id, biome_type, biome_name );
  });

  $('#add_additional_biome_site').on('click', function() {
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
      '  <div class="agroecosystem_biomes inline-block">' + '    <b>Agroecosystem:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
      '  <div class="biofuel_biomes inline-block">' + '    <b>Biofuel:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
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
