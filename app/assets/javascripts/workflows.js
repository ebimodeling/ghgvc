var id_seed = 0;
function generate_id() { return id_seed++; };

function remove_google_maps_pin( biome_site_id ) {
  if ( markersArray[biome_site_id] != undefined ) { markersArray[biome_site_id].setMap(null) };
};

function activate_biome_location( obj ) {
    collapse_all_ecosystem_wells();
    obj.find('.remove_biome_site').show();
    $('label.checkbox').find('input').removeAttr("disabled");
    
    obj.removeClass('inactive_site');
    obj.find('input').show();
    obj.find('label').show();
    obj.find('a').show();
    // effectively cuts and pastes the obj to the top of the biome_input_container
    obj.prependTo("#biome_input_container");
};


// Called everytime a user clicks on google maps
// Handles whether to keep a given marker at a lat/lng or remove it
function place_google_maps_pin( lat, lng, biome_site_id ) {
  // remove any markers tied to a biome_site_id
  remove_google_maps_pin(biome_site_id);

  // generate a new marker
  var marker = new google.maps.Marker({ 
    position: new google.maps.LatLng( lat , lng ),
    // Add in a marker with the location number
    icon: 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=' + biome_site_id + '|FE7569|000000'
  });
  // push the marker into the storage array
  markersArray[biome_site_id] = marker;
  
  // Add listener to activate a biome location on clicking the corresponding map marker
  google.maps.event.addListener( markersArray[biome_site_id], 'click', function() {
    activate_biome_location( $('#biome_instance-' + biome_site_id) );
  });
  
  return marker
};

function get_active_site_number() {
  // find the first div#biome_instance without .inactive_site ... and grab the id number
  return $('div[id|="biome_instance"]:not(inactive_site)').attr('id').split('-').pop()
};

// This function swaps out the abbreviated data source names
// for the full names: "s000" = "Anderson-Teixeira and DeLucia (2011)" 
// Expecting input formatted as:
// {"s000":234,"s001":9992}
function populate_data_sources_fullname_for_csep( csep_value ) {
//  console.log("asdfasdf");
//  console.log(csep_value);
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
      case "s002": 
        csep_value["Harmonized World Soil DB v1.2 (2012)"] = sources_value;
        delete csep_value.s002
        break; 
    }
  });
  return csep_value;
};

function populate_html_from_latlng( lat, lng ) {
  $.get("/get_biome", { lng: Math.round(lng), lat: Math.round(lat) }, function(data) {

    // Ensure we clear out existing stores, before making more
    $('[id|="biome_instance"]:not(.inactive_site)').find(".json_store").remove().find("json_saved").remove();
    
  
    var active_biome_site = get_active_site_number();
    
    // expand all values to their full source names
    data.native_eco = $.each( data.native_eco, function(k,v) {
      $.each( v, function(eco_k, eco_v) {
        data["native_eco"][k][eco_k] = populate_data_sources_fullname_for_csep( eco_v );
      });
    });
    data.aggrading_eco = $.each( data.aggrading_eco, function(k,v) {
      $.each( v, function(eco_k, eco_v) {
        data["aggrading_eco"][k][eco_k] = populate_data_sources_fullname_for_csep( eco_v );
      });
    });
    data.agroecosystem_eco = $.each( data.agroecosystem_eco, function(k,v) {
      $.each( v, function(eco_k, eco_v) {
        data["agroecosystem_eco"][k][eco_k] = populate_data_sources_fullname_for_csep( eco_v );
      });
    });
    data.biofuel_eco = $.each( data.biofuel_eco, function(k,v) {
      $.each( v, function(eco_k, eco_v) {
        data["biofuel_eco"][k][eco_k] = populate_data_sources_fullname_for_csep( eco_v );
      });
    });
    

    $('#biome_instance-' + active_biome_site).find(".json_store").remove();
    $('#biome_instance-' + active_biome_site).find(".json_saved").remove();

    // At this point json_store contains all the possible data source,value pairs at this location
    $('#biome_instance-' + active_biome_site ).prepend( // used for default values in popups
      '<div class="json_store">' + 
        JSON.stringify(data) + // stringify will work with IE8
      '</div>'
    );

    var data_defaults = data;

    // write default values to all CSEPs
    if ( data_defaults.native_eco != null ) {
      $.each( data_defaults.native_eco, function( k, v ) { // ecosystems
        $.each( data_defaults.native_eco[k] , function( csep_k, csep_v ){ // CSEPs
          data_defaults.native_eco[k][csep_k] = {"Anderson-Teixeira and DeLucia (2011)": csep_v["Anderson-Teixeira and DeLucia (2011)"]};
        });
      });
    };
    if ( data_defaults.agroecosystem_eco != null ) {
      $.each( data_defaults.agroecosystem_eco, function( k, v ) { // ecosystems
        $.each( data_defaults.agroecosystem_eco[k] , function( csep_k, csep_v ){ // CSEPs
          data_defaults.agroecosystem_eco[k][csep_k] = {"Anderson-Teixeira and DeLucia (2011)": csep_v["Anderson-Teixeira and DeLucia (2011)"]};
        });
      })
    };
    if ( data_defaults.aggrading_eco != null ) {
      $.each( data_defaults.aggrading_eco, function( k, v ) { // ecosystems
        $.each( data_defaults.aggrading_eco[k] , function( csep_k, csep_v ){ // CSEPs
          data_defaults.aggrading_eco[k][csep_k] = {"Anderson-Teixeira and DeLucia (2011)": csep_v["Anderson-Teixeira and DeLucia (2011)"]};
        });
      });
    };  
    if ( data_defaults.biofuel_eco != null ) {
     $.each( data_defaults.biofuel_eco, function( k, v ) { // ecosystems
        $.each( data_defaults.biofuel_eco[k] , function( csep_k, csep_v ){ // CSEPs
          data_defaults.biofuel_eco[k][csep_k] = {"Anderson-Teixeira and DeLucia (2011)": csep_v["Anderson-Teixeira and DeLucia (2011)"]};
        });
      });
    };



    $('#biome_instance-' + active_biome_site ).append( // used to store the values the user has selected
      '<div class="json_saved">' + 
        JSON.stringify(data_defaults) + // stringify will work with IE8
      '</div>'
    );

    // given a marker... assign it a Location number ... and write that number into the marker
    
    marker = place_google_maps_pin( lat, lng, active_biome_site );
    marker.setMap(map); // To add the marker to the map, call setMap();

    // Tag the site w the given lat and lng
    $('div.well:not(.inactive_site)').find('.site_latlng').text("( "+ lat.toFixed(2) + ", " + lng.toFixed(2) + " )");

    if ( data.native_eco != null ) {
      $.each( data.native_eco, function(k,v) {
        $('div.well:not(.inactive_site)').find('.native_biomes').find('.biome_list').append(
          '<div class="biome_match">' +
            '<label class="checkbox inline-block"><input type="checkbox" class="inline-block">' + k.replace(/_/g," ") + '</input></label>' +
            '<a class="edit_icon_link" data-toggle="lightbox" href="#ecosystem_popup">' + 
              '<i class="icon-search icon-list-alt inline-block edit_icon" rel="tooltip" title="edit"></i>' + 
            '</a>' + 
          '</div>'
        ).parent().css("height", "auto");
        // Could add delegate option here to show / hide the EDIT icon on checking the checkbox
      });
    };
    
    if ( data.biofuel_eco != null ) {
      $.each( data.biofuel_eco, function(k,v) {
        $('div.well:not(.inactive_site)').find('.biofuel_biomes').find('.biome_list').append(
          '<div class="biome_match">' +
            '<label class="checkbox inline-block"><input type="checkbox" class="inline-block">' + k.replace(/_/g," ") + '</input></label>' +
            '<a class="edit_icon_link" data-toggle="lightbox" href="#ecosystem_popup">' + 
              '<i class="icon-search icon-list-alt inline-block edit_icon" rel="tooltip" title="edit"></i>' + 
            '</a>' + 
          '</div>'
        ).parent().css("height", "auto");
        // Could add delegate option here to show / hide the EDIT icon on checking the checkbox
      });
    };

    if ( data.agroecosystem_eco != null ) {
      $.each( data.agroecosystem_eco, function(k,v) { 
        $('div.well:not(.inactive_site)').find('.agroecosystem_biomes').find('.biome_list').append(
          '<div class="biome_match">' +
            '<label class="checkbox inline-block"><input type="checkbox" class="inline-block">' + k.replace(/_/g," ") + '</input></label>' +
            '<a class="edit_icon_link" data-toggle="lightbox" href="#ecosystem_popup">' + 
              '<i class="icon-search icon-list-alt inline-block edit_icon" rel="tooltip" title="edit"></i>' + 
            '</a>' + 
          '</div>'
        ).parent().css("height", "auto");
        // Could add delegate option here to show / hide the EDIT icon on checking the checkbox
      });
    };
   

  });
};

// narf
function initalize_google_map(lat, lng, zoom) {
  var type = $(document).find('.map_type_selector.active').html().toLowerCase();

  var mapBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(-85.8, -179.999894), // south-west
      new google.maps.LatLng(90.8, 179.773283) // north-east
  );

  var mapMinZoom = 2;
  var mapMaxZoom = 5;
  var geocoder;
  var address;
  var latlng = new google.maps.LatLng(31,-15);
  var overlayOptions = {
    opacity: 0.6,
    zoom: mapMinZoom,
    streetViewControl: false,
    mapTypeControl: false,
    panControl: false,
    center: latlng,
    zoom: mapMinZoom,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById("map_canvas"), overlayOptions);

  // tile overlay code
  var maptiler = new google.maps.ImageMapType({
    getTileUrl: function(coord, zoom) { 
        var proj = map.getProjection();
        var z2 = Math.pow(2, zoom);
        var tileXSize = 256 / z2;
        var tileYSize = 256 / z2;
        var tileBounds = new google.maps.LatLngBounds(
            proj.fromPointToLatLng(new google.maps.Point(coord.x * tileXSize, (coord.y + 1) * tileYSize)),
            proj.fromPointToLatLng(new google.maps.Point((coord.x + 1) * tileXSize, coord.y * tileYSize))
        );
        var y = coord.y;
        if (mapBounds.intersects(tileBounds) && (mapMinZoom <= zoom) && (zoom <= mapMaxZoom)) {
            return "/map_tiles/" + zoom + "/" + coord.x + "/" + y + ".png";
        } else {
            return "http://www.maptiler.org/img/none.png";
        }
    },
    tileSize: new google.maps.Size(256, 256),
    isPng: true,
    opacity: 0.6
  });
  map.overlayMapTypes.insertAt(0, maptiler);


  $('div[id*="_biomes"]').find('.biomes').html("");
    
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
    map.overlayMapTypes.insertAt(0, maptiler);
  });

  // Limit the zoom level
  google.maps.event.addListener(map, 'zoom_changed', function() {
    if (map.getZoom() > mapMaxZoom) map.setZoom(mapMaxZoom);
  });
  
  markersArray = [];
  google.maps.event.addListener(map, "click", function(event) {

    var lat = event.latLng.lat();
    var lng = event.latLng.lng();

    // clear out existing biome matches
    $('#biome_input_container').find('div.well:not(.inactive_site)').find('div[class*="_biomes"]').find('.biome_list').html("");

    populate_html_from_latlng( lat, lng );

    // for offline testing
//     populate_html_from_latlng( 39.16113, -4.978971 );
    
  });
};

function show_csep_groups_for_ecosystem( biome_type ,ecosystem_name ) {

  // Hide non-default groups 
  $('#natural_fire').hide();
  $('#management_related').hide();
  $('#fossil_fuel').hide();
  $('#biophysical').hide();
    
  switch( biome_type ) {
    case"native":
    $('#biophysical').show();
    break;
  }
    
  switch ( ecosystem_name ) { 
    case"temperate forest": case"boreal forest": case"tropical peat forest": case"tropical forest":
      $('#natural_fire').show();
      break;
   case"US corn": case"BR sugarcane": 
      $('#management_related').show();
      $('#fossil_fuel').show();
      break;
   case"temperate pasture": case"tropical pasture": case"temperate cropland": case"soybean": case"tropical cropland":
      $('#management_related').show();
      break;
   case"temperate grassland": case"temperate pasture": case"tropical pasture": case"temperate cropland": case"soybean": case"tropical cropland": case"scrub/woodland":
      $('#biophysical').show();
      break;
  }
}


function populate_ecosystem_shadowbox( site_id, biome_type, biome_name ) {
  $("#ecosystem_popup").find(".lightbox-content").each(function() {
    $(this).find(".popup_heading").text( biome_type + ": " + biome_name.replace(/_/g," ") );

    // get the ecosystems from that biome_instance
    var location_default_ecosystems = $.parseJSON( $('#biome_instance-' + site_id).find('.json_store').text() );
    var current_default_ecosystem = location_default_ecosystems[biome_type + "_eco"][biome_name.replace(/ /g,"_")];

    console.log("pushing this into popup:");
    console.log(current_default_ecosystem);
    
    show_csep_groups_for_ecosystem( biome_type, biome_name.replace(/_/g," ") );
    

    // Clear out all existing drop-down values
    $('.popup_cite_dropdown').empty();
   
    // For the current_ecosystem ( EX: "miscanthus" )
    $.each( current_default_ecosystem, function( csep_key, csep_value ) {
      // Find the row corresponding to a CSEP value ( EX: "OM_ag")
      $.each( $('#ecosystem_edit').find('tr#' + csep_key), function() {
        var csep_row = $(this);

        // if a custom field doesn't exist ... add it in
        if ( csep_value['User defined'] == null ) {
          csep_value['User defined'] = 'custom';
        };

        // Each CSEP is a hash
        // which contains multiple data sources
        // loop through those sources and place them within the dropdown
        $.each( csep_value, function( sources_key, sources_value ) {
          // populate in the saved values, or default values from json_saved
          csep_row.find('.popup_cite_dropdown').append( $("<option></option>").attr("value", sources_value).text(sources_key) );
        });
      });
    });
    
    // At this point all values are populated in
    // Next we need to select the values the user has saved (  values in .json_saved )
    // ... which could be default values, or those that the user has saved )
    var user_saved_ecosystems = $.parseJSON( $('#biome_instance-' + site_id).find('.json_saved').text() );
    var user_current_saved_ecosystem = user_saved_ecosystems[biome_type + "_eco"][biome_name.replace(/ /g,"_")];
    
    console.log("preselecting these:");
    console.log(user_current_saved_ecosystem);
    
    $.each( user_current_saved_ecosystem, function( csep_key, csep_value ) {
      // Find the row corresponding to a CSEP value ( EX: "OM_ag")

//      console.log(value);
//      if ( csep_key == "sw_radiative_forcing"  || csep_key == "latent" ){
//        console.log("DINGOESSSSSSSSS");
//        console.log(csep_value);
//      }

      $.each( $('#ecosystem_edit').find('tr#' + csep_key), function() {
        var csep_row = $(this);
//        console.log(csep_row);
        // Each CSEP will have a value saved in the users json_saved
        // So we iterate through the json_saved
        // And set the dropdown for that CSEP to the value in json_saved
        $.each(csep_value, function (index, value) {
          // Check the text of each drop down option
          $('#' + csep_key + '-source option').each(function() {
            // if it matches the saved one... make it the active selection
            if($(this).text() == String(index)) {
              $(this).attr('selected', 'selected');            
            };
          });
          
          $('#ecosystem_' + csep_key).attr("value", value);
          
        // At this point all the the saved options should be displaying as whats selected in the popup          
          
        });       
      });
    });
    
    

  });
};

function open_previous_biome_site() {
  $('#biome_input_container').find('div.well').first().removeClass('inactive_site');
};

function collapse_all_ecosystem_wells() {
  $('#biome_input_container').find('div.well').addClass('inactive_site');
  $('#biome_input_container').find('.remove_biome_site').hide();
  $('#biome_input_container').find('div.well').find('label.checkbox').each( function() {
    if ( $(this).find('input').is(':checked') == false ) {
      // hide the label and checkbox
      $(this).hide();
      // hide associated edit icon
      $(this).siblings('a').hide();
      
    }
  });
};


function get_selected_ecosystems_name_and_type( location ) {
  var ecosystems_at_this_location = location.find('label.checkbox');
  
  var selected_ecosystem_names = [];
  
  // Iterate through the checkboxes associated with the ecosystem names
  // And if they're checked ... add them to the selected_ecosystem_names
  $.each( ecosystems_at_this_location, function() {
    if ( $(this).find('input').is(':checked') ) {
      var ecosystem_type = $(this).closest("[class*='_biomes']").attr("class").split(" ")[0].split("_")[0];
      var ecosystem_name = $(this).text();
      selected_ecosystem_names.push( [ ecosystem_type, ecosystem_name ] );
    }; 
  });
  return selected_ecosystem_names;    
};

function toggle_input_state_for_highcharts() {
  $('#biome_input_container').toggle();
  $('#run_button_container').toggle();
  $('#add_additional_biome_site').toggle();
  $('#location_counter_container').toggle();
};

function update_location_count(){
  $('#total_location_count').text( $('div[id|="biome_instance"]').length );
};

$(document).ready(function() {
  $('input:checkbox[name=biogeochemical]').attr('checked',true);
  $('input:checkbox[name=biophysical]').attr('checked',true);
  
  $('#run_button_container').mouseenter(function(){
      $('#calc_sub_modules').css("display","inline-block");
  }).mouseleave( function(){
      $('#calc_sub_modules').css("display","none");
  });
  
  
//  $('#calc_sub_modules').animate({opacity:'toggle'},500)

  initalize_google_map();
  
  $('#calc_ethanol_yield').on('click' ,function() { 
    console.log("calc_ethanol_yield");
    
    $('#eth_yield').find('.popup_value_field').val(
      $('#ac_yield').find('.popup_value_field').val() * $('#con_energy').find('.popup_value_field').val()
    );
  });
  
  $('#calc_gasoline_displacement').on('click' ,function() { 
    $('#G_C02').find('.popup_value_field').val(
      // -0.0348 is used for US Corn, Miscanthus, BZ Sugarcane, US prarie
      $('#eth_yield').find('.popup_value_field').val() * -0.0348
    );
  });
  
  
    
    
//    -0.0348
//US corn:
//first * second = third 
//4th = 3rd * -0.0348
    

  
  
  $('#run_ghgvc_calculator').on('click' ,function() {
  
    // Check to see that we've got at least one "checked" input
    if ( $('[id|="biome_instance"]').find('label.checkbox').find('input').is(':checked') == false ) {
      alert("Please check one or more ecosystems");  
      return;
    };
    
    // when we're missing values, the output will be the same regardless of what checkboxes are checked.
//    $('#biogeochemical').is(':checked')
//    $('#biophysical').is(':checked')
    
    // deactivate page with lightbox overlay
    $('#toggle_ghgvcR_processing_popup').trigger("click");

    ghgvcR_input = {};

    // run the stuff to init the calculator
    var all_locations = $('[id|="biome_instance"]');
    var all_input_ecosystems = $('[id|="biome_instance"]').find('.json_saved');
    
    $.each( all_locations, function() {
    
      // go through each location
      var biome_group =  $(this);
      var ecosystem_to_include = get_selected_ecosystems_name_and_type( $(this) );
      var current_biomes_json = $.parseJSON( biome_group.find('.json_saved').text() );
      console.log("current_biomes_json");
      console.log(current_biomes_json);
      
      $.each( ecosystem_to_include, function(i,v){
        // and each ecosystem

        var input_ecosystem_json = current_biomes_json[v[0] + "_eco"][v[1].replace(/ /g,"_")];
        console.log( input_ecosystem_json );
        var biome_group_string = biome_group.attr('id');
        var biome_type_string = v[0] + "_eco";
        var biome_name_string = v[1].replace(/ /g,"_")
        
        // if keys dont exist ... add them
        if (!( biome_group_string in ghgvcR_input ))  ghgvcR_input[biome_group_string] = {};
        if (!( biome_type_string in ghgvcR_input[biome_group_string] ))  ghgvcR_input[biome_group_string][biome_type_string] = {};
        
        ghgvcR_input[biome_group_string][biome_type_string][biome_name_string] = input_ecosystem_json;
        
        // Current R code requires sensible value, even though we dont use sensible
        ghgvcR_input[biome_group_string][biome_type_string][biome_name_string]["sensible"] = {"Anderson-Teixeira and DeLucia (2011)":"0"};
        
      });
    });


//    <sw_radiative_forcing>-0.387200238397716</sw_radiative_forcing>
//		<latent>0.06180009880958</latent>
//		<sensible>0.327720400257219</sensible>

    // Uncomment these to try out the biophysical
//    ghgvcR_input["biome_instance-0"]["native_eco"]["temperate_grassland"]["sw_radiative_forcing"] = {};
//    ghgvcR_input["biome_instance-0"]["native_eco"]["temperate_grassland"]["sw_radiative_forcing"]["Anderson-Teixeira and DeLucia (2011)"] = -0.387200238397716; 

//    ghgvcR_input["biome_instance-0"]["native_eco"]["temperate_grassland"]["latent"] = {};
//    ghgvcR_input["biome_instance-0"]["native_eco"]["temperate_grassland"]["latent"]["Anderson-Teixeira and DeLucia (2011)"] = -0.387200238397716;

//    ghgvcR_input["biome_instance-0"]["native_eco"]["temperate_grassland"]["sensible"] = {};
//    ghgvcR_input["biome_instance-0"]["native_eco"]["temperate_grassland"]["sensible"]["Anderson-Teixeira and DeLucia (2011)"] = -0.387200238397716;


    // At this point we've got the names of selected ecosystems at each location
    // Each CSEP contains a single Float value
    console.log("ghgvcR_input");    
    console.log( ghgvcR_input );
    
    //// Workaround for R-Code only running 1 biophysical value
    // Here we write the input swRadF value into the DOM
    // So we can compare it to the output swRadF value
    // Which gives us a scale factor to apply to the latent value
    
    /*  
    
    Latent should already be in there...

    for each lat/lng
      for every biome_type_group
        for each biome
    write the latent 
    
    
    */
    
    // Hide all the input portions
    toggle_input_state_for_highcharts();
    
    $.post("/create_config_input", { ecosystems: ghgvcR_input }, function(data) {
      console.log("###### output from ghgvcR code: ######");
      console.log(data);
      
      // run highcharts scripts here
      $.each(data, function(k,v){
        console.log("key: "+k+" .. and value:");
        console.log(v); 
        var location_num = k.split('_')[1]
        
        // TODO: parseFloat(v) might be needed here:
        create_results_table( v ,location_num );
        
      });
      
      // reactivate page with lightbox overlay
      $('#toggle_ghgvcR_processing_popup').trigger("click");
      $('#csv_download_button').show();
      $('#new_simulation_button').show();
      

    });
    
    
    // use the JSON >> XML conversion code here

  });
  

  $('.popup_cite_dropdown').change( function() {
    // Assign the selected value in the drop down, to the subling input box
    $(this).parentsUntil('tbody').find('.popup_value_field').val( $(this).val() );
  });
  $('.popup_value_field').on('focus', function() {
    // Assign the selected value in the drop down, to the subling input box
    $(this).parentsUntil('tbody').find('.popup_cite_dropdown').val("user defined");
  });
  
  
  $("#popup_save_ecosystem_modifications").on('click', function() {
    // get all fields / values
//    console.log( $('#ecosystem_edit').find('.popup_value_field') );
    var ecosystem_type_being_saved = $('#ecosystem_edit').find('.popup_heading').text().split(":")[0] + "_eco";
    var ecosystem_being_saved = $('#ecosystem_edit').find('.popup_heading').text().split(":")[1].trim().replace(/ /g,"_");    
    var active_site_num = get_active_site_number();
    var all_ecosystems_at_site = $.parseJSON( $('#biome_instance-' + active_site_num ).find('.json_saved').text() );
    console.log("########");
    console.log(all_ecosystems_at_site);
    console.log(ecosystem_type_being_saved);
    console.log(ecosystem_being_saved);


    var ecosystem = all_ecosystems_at_site[ecosystem_type_being_saved][ecosystem_being_saved]

    // while in the popup
    // discard custom values... if the ecosystem is saved with one of the default values
    
    // then when populating the edit_popup ... if a ['custom'] exists .. use it as the default

    console.log("Gets there");
    console.log(ecosystem);
    
    $.each( ecosystem , function( csep_k, csep_v ){
      // find associated CSEP value and store whats in the .popup_value_field
      var save_csep_source = $("#" + csep_k + "-source option:selected").text();
      var save_csep_value = $("#ecosystem_" + csep_k).val();

      ecosystem[csep_k] = {};
      ecosystem[csep_k][save_csep_source] = save_csep_value;
      console.log("Wrote out: " + csep_k + " as: " + save_csep_source +":"+save_csep_value);
      
    });

    // At this point the ecosystem object will contain *ONLY* a single key/value pair ( source / value pair )
    // It should cointain a Hash object for each CSEP
    console.log("This is what was saved:");
    console.log(ecosystem);



    console.log("In this big guy:");
    console.log(all_ecosystems_at_site);

    

    // Finally write out the saved JSON
    $('#biome_instance-' + active_site_num ).find('.json_saved').text( JSON.stringify( all_ecosystems_at_site ) );
    
    // This will hit the hidden close button and invoke the close operation in bootstrap-lightbox
    $("#hidden_close_button").trigger("click");
  });
  
  $("#popup_discard_ecosystem_modifications").on('click', function() {
    // This will hit the hidden close button and invoke the close operation in bootstrap-lightbox
    $("#hidden_close_button").trigger("click");
  });
  
  $("#biome_input_container").delegate('.edit_icon', "click" , function() {
    var site_id = $(this).closest('[id]|="biome_instance"').attr("id").split("-")[1]
    var biome_name = $(this).closest(".biome_match").find("label.checkbox").text();
    var biome_type = $(this).closest("[class*='_biomes']").attr("class").split(" ")[0].split("_")[0]
    populate_ecosystem_shadowbox( site_id, biome_type, biome_name );
  });

  $('#add_additional_biome_site').on('click', function() {
    collapse_all_ecosystem_wells();

    if ( $('div[id|="biome_instance"]').length <= 9 && $('#add_additional_biome_site').hasClass("disabled") == false ) {
      // Add in new biome site, which will be ACTIVE 
      
      var this_location_number = generate_id();
      
      $('#biome_input_container').prepend(
        '<div id="biome_instance-' + this_location_number + '" class="well well-small collapsed">' +
        '  <div class="biome_site_header inline-block"><h4><span class="site_latlng">( -- , -- )</span>: Location ' + this_location_number + '</h4></div>' + 
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
        if ( $('div[id|="biome_instance"]').length < 10 ){
          $('#add_additional_biome_site').removeClass("disabled");
        };
        update_location_count();
      });
      
      if ( $('div[id|="biome_instance"]').length == 10 ) {
        $('#add_additional_biome_site').addClass("disabled");
      };
    };

    update_location_count();

  });

  // Add inital biome list using above code:
  $('#add_additional_biome_site').trigger('click');

  
  // handles reactivating a site when selected
  $('#biome_input_container').on("click", ".inactive_site" , function() {
    activate_biome_location( $(this) );
  });

  $(".biome_list").tooltip({
    'selector': 'i',
    'placement': 'right'
  });

  $('.map_type_selector').on('click', function() {
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
