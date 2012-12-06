

//$('#dingo').click( function(){
//  alert('loaded');

//});


$("#dingo").live('click', function(){
  $.post("http://localhost:3000/get_biome", { lat: 229, lng: 191 });
});

//$("ul[id|=experience]").live('click', function(){ $(this).openState(); });
