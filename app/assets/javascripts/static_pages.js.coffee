# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

    <script type="text/javascript">
//<![CDATA[ 
      var geocoder;
      var address;
      var latlng = new google.maps.LatLng(40.44,-95.98);
      var myOptions = {
        zoom: 4,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };

      map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
 
      overlay = [];

      google.maps.event.addListener(map, "click", function(event) { 

        if(overlay.length > 0) {        
          overlay[0].setMap(null);
          overlay.length = 0;
        }
        var radius = $('radius').value;
        var lat = event.latLng.lat();
        var lon = event.latLng.lng();
        <%= remote_function( :url => { :action => "show_sites"}, :with => "'lat=' + lat + '&lng=' + lon + '&radius=' + radius"  ) %>;

        var latOffset = radius/(69.1);
        var lonOffset = radius/(53.0);
        var paths = [new google.maps.LatLng(lat + latOffset, lon + lonOffset),
                   new google.maps.LatLng(lat - latOffset, lon + lonOffset),
                   new google.maps.LatLng(lat - latOffset, lon - lonOffset),
                   new google.maps.LatLng(lat + latOffset, lon - lonOffset),
                   new google.maps.LatLng(lat + latOffset, lon + lonOffset)];
        overlay.push( new google.maps.Polygon({
          paths: paths,
          strokeColor: "#ff0000",
          strokeWeight: 0,
          strokeOpacity: 1,
          fillColor: "#ff0000",
          fillOpacity: 0.2,
          clickable: false,
          map: map
        }))
      });


//]]>
    </script>
