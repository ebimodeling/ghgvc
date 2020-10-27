var id_seed = 0;
function generate_id() { return ++id_seed; };

// Turn on bootstrap tooltips when the page is loaded
$(document).ready(function(){
  $('[data-toggle="popover"]').popover();
});

function remove_google_maps_pin( biome_site_id ) {
  if ( markersArray[biome_site_id] != undefined ) { markersArray[biome_site_id].setMap(null) };
};

// The calculation is posted from JS, so we need a way to return the result and
// convert it into a CSV & JSON to allow for downloading. This is a first pass
// at inspecting the results and looking to create a CSV from the JS object.
//
// TODO: Replace this with an actual JS library that handles quotes, commas,
// etc. Shouldn't need to hand-roll this


function convert_to_csv(input_data) {
  const data = {...input_data}
  debugger
  json2csvParser = json2csv.Parser;
  let flat_data = [];
  for (site in data) {
    for (ecosystem in data[site]) {
      let cleaned = {...data[site][ecosystem]}
      for(field in cleaned){
          cleaned[field] = data[site][ecosystem][field].join(", ")
      }
      flat_data.push(cleaned);
    }
  }
  columns= flat_data.reduce(function (x, y) {
    keys = Object.keys(y)
    for(columns in keys){
      if(x.indexOf(keys[columns]) === -1){
        x.push(keys[columns])
      }
    }
    return x
  },[])

  parser = new json2csvParser(columns, flatten=true);
  str = parser.parse(flat_data)
  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/csv;charset=utf-8,' + encodeURIComponent(str));
  element.setAttribute('download', 'data.csv');

  element.style.display = 'none';
  document.body.appendChild(element);

  element.click();

  document.body.removeChild(element);
  console.log(str);
}

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

    $('#biome_instance-' + active_biome_site).find(".json_store").remove();
    $('#biome_instance-' + active_biome_site).find(".json_saved").remove();

    // At this point json_store contains all the possible data source,value pairs at this location
    $('#biome_instance-' + active_biome_site ).prepend( // used for default values in popups
      '<div class="json_store">' +
        JSON.stringify(data) + // stringify will work with IE8
      '</div>'
    );

    var data_defaults = data;

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
    function biome_div(type) {
      return function make_element(k,v) {
        element = '<div class="biome_match checkbox">' +
          '<label class="biome-match"><input type="checkbox">' + k.replace(/_/g," ") + '</input></label>'
        if(v['in_synmap'][0]){
          element = element.concat('<span class="synmap-flag" style="color: red; font-size: 20px;">*</span>')
          $('#synmap-key').css("display","inline")
        }
        element = element.concat(
        '<a class="edit_icon_link action-link" data-toggle="modal" data-target="#ecosystem_popup" href="#ecosystem_popup">' +
          '<i class="glyphicon glyphicon-list-alt" rel="tooltip" title="Edit"></i>' +
        '</a>' +
        '<a class="biome_pdf_link action-link"href="' +
        '/ecosystem_fact_sheets/' + v.code + '.pdf' + //pdf file name
        '" download><img class="download-pdf-icon" src="/assets/pdf_24x24.png"></a>' +
      '</div>')
        $('div.well:not(.inactive_site)').find(type).find('.biome_list').append(
          element
        ).parent().css("height", "auto");
        // Could add delegate option here to show / hide the EDIT icon on checking the checkbox
      };
    };
    if ( data.native_eco != null ) {
      $.each( data.native_eco, biome_div('.native_biomes'));
    };
    if ( data.agroecosystem_eco != null ) {
      $.each( data.agroecosystem_eco, biome_div('.agroecosystem_biomes'));
    };
  });
};

// narf
function initialize_google_map(lat, lng, zoom) {
  var type = $(document).find('.map_type_selector.active').html().toLowerCase();

  var mapBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(-90, -180), // south-west
      new google.maps.LatLng(90, 180) // north-east
  );

  var mapMinZoom = 2;
  var mapMaxZoom = 13; //Goes to 19 according to google docs
  var geocoder;
  var address;
  var latlng = new google.maps.LatLng(31,-15);
  // set scrollwheel: false in options to disable accidental zoom on scroll
  var overlayOptions = {
    opacity: 0.6,
    zoom: mapMinZoom,
    minZoom: mapMinZoom,
    streetViewControl: false,
    mapTypeControl: false,
    panControl: false,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.SATELLITE
  };

  map = new google.maps.Map(document.getElementById("map_canvas"), overlayOptions);

  $('div[id*="_biomes"]').find('.biomes').html("");

  // These boundaries represent the northern- and southern-most latitudes we
  // should allow the map to move to
  var northBoundary = 85.07606520571666
  var southBoundary = -85.05645476301743

  // Listen for the map click events and re-center the map if it's outside
  // the bounds we've set. This method helps re-center the map so the user
  // isn't left with an empty area above or below the map container
  google.maps.event.addListener(map, "center_changed", function() {
    var bounds = map.getBounds();
    var ne = bounds.getNorthEast();
    var sw = bounds.getSouthWest();
    var center = map.getCenter();

    if(ne.lat() > northBoundary) {
      map.setCenter({lat: center.lat() - (ne.lat() - northBoundary), lng: center.lng()})
    }

    if(sw.lat() < southBoundary) {
      map.setCenter({lat: center.lat() - (sw.lat() - southBoundary), lng: center.lng()})
    }
  });

  // Limit the zoom level
  google.maps.event.addListener(map, "zoom_changed", function() {
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

    // Once the user has set the location for the active site, display
    // the button for adding additional sites:
    $('#add_additional_biome_site').removeClass("off_page");
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
   case"US corn": case"BR sugarcane":case"soybean":case"BR soy":
      $('#management_related').show();
      $('#fossil_fuel').show();
      $('#biophysical').show();
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
  $("#ecosystem_popup").find(".modal-content").each(function() {
    $(this).find(".popup_heading").text( biome_type + ": " + biome_name.replace(/_/g," ") );

    // get the ecosystems from that biome_instance
    var location_default_ecosystems = $.parseJSON( $('#biome_instance-' + site_id).find('.json_store').text() );
    var current_default_ecosystem = location_default_ecosystems[biome_type + "_eco"][biome_name.replace(/ /g,"_")];
    console.log("pushing this into popup: " + JSON.stringify(current_default_ecosystem));

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
    console.log("preselecting these: " + JSON.stringify(user_current_saved_ecosystem));

    $.each( user_current_saved_ecosystem, function( csep_key, csep_value ) {
      // Find the row corresponding to a CSEP value ( EX: "OM_ag")
      $.each( $('#ecosystem_edit').find('tr#' + csep_key), function() {
        var csep_row = $(this);
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
          // R is sometimes returning [NaN] and [null] values in the resulting JSON
          // This will cause problems when submitting the form with this data.
          // This change prevents that
          if(value == ["NaN"] || value == [null] || value == undefined) { value = ""; }
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
  var ecosystems_at_this_location = location.find('label');
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

function toggle_input_state_for_charts() {
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

// TODO: Reenable when biophysical is working
//  $('#run_button_container').mouseenter(function(){
//      $('#calc_sub_modules').css("display","inline-block");
//  }).mouseleave( function(){
//      $('#calc_sub_modules').css("display","none");
//  });

//  $('#calc_sub_modules').animate({opacity:'toggle'},500)

  initialize_google_map();

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

  $('#run_ghgvc_calculator').on('click' ,function() {
    // Check to see that we've got at least one "checked" input
    if ( $('[id|="biome_instance"]').find('label.biome-match').find('input').is(':checked') == false ) {
      alert("Please check one or more ecosystems");
      return;
    };

    // when we're missing values, the output will be the same regardless of what checkboxes are checked.
    // $('#biogeochemical').is(':checked')
    // $('#biophysical').is(':checked')

    // deactivate page with lightbox overlay
    $('#toggle_ghgvcR_processing_popup').trigger("click");

    ghgvcR_input = {};

    var all_locations = $('[id|="biome_instance"]');
    var all_input_ecosystems = $('[id|="biome_instance"]').find('.json_saved');

    // Here the values given by the user, or the default values for the CSEPs
    // are written into a json object to be used as input for the R script

    // go through each location
    $.each( all_locations, function() {
      var biome_group =  $(this);
      var ecosystem_to_include = get_selected_ecosystems_name_and_type( $(this) );
      var current_biomes_json = $.parseJSON( biome_group.find('.json_saved').text() );
      //console.log("current_biomes_json: " + JSON.stringify(current_biomes_json));

      var loc = biome_group.find(".biome_site_header .site_latlng").text();
      var lat_lng_matcher = /\( *([\d\.-]+) *, *([\d\.-]+) *\)/;
      var result = loc.match(lat_lng_matcher);
      var lat = result[1];
      var lng = result[2];

      const biome_group_id_splits = biome_group.attr('id').split('-');
      const siteNumber = biome_group_id_splits[biome_group_id_splits.length - 1];
      var biome_group_string = "site_" + siteNumber + "_data";

      ghgvcR_input[biome_group_string] = {}
      ghgvcR_input[biome_group_string]['lat'] = lat
      ghgvcR_input[biome_group_string]['lng'] = lng
      ghgvcR_input[biome_group_string]["ecosystems"] = {}

      $.each( ecosystem_to_include, function(i,v) {
        var input_ecosystem_json = current_biomes_json[v[0] + "_eco"][v[1].replace(/ /g,"_")];
        //console.log( input_ecosystem_json );
        var biome_name_string = v[1].replace(/ /g,"_")

        ghgvcR_input[biome_group_string]["ecosystems"][biome_name_string] = input_ecosystem_json;
        // Remove unnecessary settings that are in global
        delete ghgvcR_input[biome_group_string]["ecosystems"][biome_name_string]["T_A"];
        delete ghgvcR_input[biome_group_string]["ecosystems"][biome_name_string]["T_E"];
        delete ghgvcR_input[biome_group_string]["ecosystems"][biome_name_string]["r"];
      });
    });



    function parseFormInput(element) {
      if(setting.type === "checkbox") {
        return setting.checked ? "TRUE" : "FALSE";
      }
      return setting.value;
    }

    // Get and set global settings
    const optionsData = {}
    const advancedSettings = document.querySelectorAll('#advanced-settings-form input');
    for(var i = 0; i < advancedSettings.length; i++) {
      var setting = advancedSettings[i]
      optionsData[setting.name] = parseFormInput(setting)
    }

    // At this point we've got the names of selected ecosystems at each location
    // Each CSEP contains a single Float value
    // console.log("ghgvcR_input: " + JSON.stringify(ghgvcR_input));

    // Hide all the input portions
    toggle_input_state_for_charts();

    const data = { sites: ghgvcR_input, options: optionsData };

    $.post("/create_config_input", data, function(data) {
      // Data is already returned as an object, no need to parse or stringify

      // Base64 decoding for SVG images
      mi_svg = atob(data.plots.mi[0]);
      var re = new RegExp('glyph','g');
      mi_svg = mi_svg.replace(re, "glyph-mi")
      co2_svg = atob(data.plots.co2[0]);
      mi_svg = mi_svg.replace(re, "glyph-co2")


      // Place SVGs on the map
      $("#mi_container").html(mi_svg);
      $("#co2_container").html(co2_svg);

      // make the returned data available so it can be exported to a csv
      window.json_data = data.results;
      // Add the message about the black dots
      $('#dot_container').html('Black dots indicate net values, and are displayed when all components are quantified. Missing values (particularly common for biophysical components) indicate that climate regulating values cannot be calculated because of insufficient data.');

      // debugger;

      // Reactivate page with lightbox overlay
      $('#toggle_ghgvcR_processing_popup').trigger("click");
      $('#csv_download_button').show();
      $('#new_simulation_button').show();
      // Show the charts class again
      $('#charts_container').removeClass('hidden');
    });
  });

  $('.popup_cite_dropdown').change( function() {
    // Assign the selected value in the drop down, to the sibling input box
    $(this).parentsUntil('tbody').find('.popup_value_field').val( $(this).val() );
  });

  $('.popup_value_field').on('focus', function() {
    // Assign the selected value in the drop down, to the sibling input box
    $(this).parentsUntil('tbody').find('.popup_cite_dropdown').val("user defined");
  });

  $("#popup_save_ecosystem_modifications").on('click', function() {
    // get all fields / values
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
    console.log("Ecosystem: " + JSON.stringify(ecosystem));
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
    console.log("This is what was saved:" + JSON.stringify(ecosystem));
    console.log("Ecosystems at site: " + JSON.stringify(all_ecosystems_at_site));

    // Finally write out the saved JSON
    $('#biome_instance-' + active_site_num ).find('.json_saved').text( JSON.stringify( all_ecosystems_at_site ) );

    // This will hit the hidden close button and invoke a close on the bootstrap modal
    $('.close-modal-btn').click();
  });

  $("#biome_input_container").delegate('.edit_icon_link', "click" , function() {
    var site_id = $(this).closest('div[id|="biome_instance"]').attr("id").split("-")[1]
    var biome_name = $(this).closest(".biome_match.checkbox").find("label.biome-match").text();
    var biome_type = $(this).closest("[class*='_biomes']").attr("class").split(" ")[0].split("_")[0]
    populate_ecosystem_shadowbox( site_id, biome_type, biome_name );
  });

  $('#add_additional_biome_site').on('click', function(event) {
    // If this is an actual user click, check that the currently
    // active site has at least one ecosystem checked:
    if (!event['isTrigger'] && $('[id|="biome_instance"]:not(.inactive_site)').find('label.biome-match').find('input').is(':checked') == false) {
      alert("Please check one or more ecosystems");
      return;
    };

    collapse_all_ecosystem_wells();

    if ( $('div[id|="biome_instance"]').length <= 9 && $('#add_additional_biome_site').hasClass("disabled") == false ) {
      // Add in new biome site, which will be ACTIVE
      var this_location_number = generate_id();

      $('#biome_input_container').prepend(
        '<div id="biome_instance-' + this_location_number + '" class="well well-small collapsed">' +
        '  <div class="biome_site_header inline-block"><h4><span class="site_latlng">( -- , -- )</span>: Location ' + this_location_number + '</h4></div>' +
        '  <div class="remove_biome_site btn btn-small btn-danger inline-block pull-right">' +
        '    <i class="glyphicon glyphicon-remove"></i> Remove Location' +
        '  </div>' + '  <br />' + '<hr/>' +
        '  <div class="native_biomes inline-block">' + '    <b>Native:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
        // '  <div class="aggrading_biomes inline-block">' + '    <b>Aggrading:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
        '  <div class="aggrading_biomes inline-block">' +  '    <div class="biome_list"></div>' + '  </div>' +
        '  <div class="agroecosystem_biomes inline-block">' + '    <b>Agroecosystem:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
        // '  <div class="biofuel_biomes inline-block">' + '    <b>Biofuel:</b>' + '    <div class="biome_list"></div>' + '  </div>' +
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

    // Hide the 'Add Additional Site' button until user selects a map
    // location:
    $('#add_additional_biome_site').addClass("off_page");
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

    initialize_google_map();
  });
});

function getMaximum(value) {
  if(!value) {
    return 100;
  } else {
    return parseFloat(value);
  }
}

function getMinimum(value) {
  if(!value) {
    return 0;
  } else {
    return parseFloat(value);
  }
}

function getSliderRange(input) {
  const max = getMaximum(input.max);
  const min = getMinimum(input.min);
  return { 'min': min, 'max': max }
}

// Additional Settings Form Related JS
$( document ).ready(function() {
  var sliders = document.getElementsByClassName("ui-slider");
  var slidersInputs = document.getElementsByClassName("ui-slider-input");

  for ( var i = 0; i < sliders.length; i++ ) {
    const slider = sliders[i];
    const inputNumber = slidersInputs[i];
    const steps = inputNumber.getAttribute('data-step-units');
    const rounded = inputNumber.getAttribute('data-rounded') === "true";

    var sliderOptions = {
      start: inputNumber.value,
      connect: [true, false],
      range: getSliderRange(inputNumber),
      tooltips: true
    }
    if(steps) sliderOptions.step = parseInt(steps);
    if(rounded) sliderOptions.tooltips = [wNumb({decimals: 0})];

    noUiSlider.create(slider, sliderOptions);

    slider.noUiSlider.on('update', function( value ) {
      inputNumber.value = rounded ? Math.round(value) : value;
    });
    inputNumber.addEventListener('change', function(){
      slider.noUiSlider.set(this.value);
    });
  }
});
