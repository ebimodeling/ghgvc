function Parameter(name, long_name, category, value) {
	this.name = name;
	this.descriptive_name = name;
	this.category = category;
	this.value = value;
}

function Experiment(name, ecosystems, options) {
	this.name = name;
	this.ecosystems = ecosystems;
	this.options = options;
}

function CustomEcosystem(name, eco_index, description, category, variables){
	this.name = name;
	this.category = category;
	this.eco_index = eco_index;
	this.description = description;
	this.variables = variables;
}

var options = {
	storage: true,
	flux: true,
	disturbance: false,
	co2: true,
	ch4: true,
	n2o: true,
	T_A: 100,
	T_E: 50,
	r: 0,
	Rnet: 0
};

var experiment = new Experiment("untitled", [], options);
var included_ecosystems = experiment.ecosystems;

function showPopup(contentName) {
	var popup = $("#popup_div");
	var disable = $("#disable_div");
	disable.show();

	var contentURL = "content/" + contentName + "/" + contentName + ".html",
		scriptURL = "content/" + contentName + "/" + contentName + ".js";

	popup.html(CONTENT[contentName].html);
	eval(CONTENT[contentName].js);
	centerPopup();
	popup.show();

function centerPopup() {
	var popup = $("#popup_div");
	popup.css({ "margin-left": -popup.width() / 2, "margin-top": -popup.height() / 2 });
}

function showPopupDiv() {
	$("#disable_div").show();
	$("#popup_div").show();
}

function hidePopupDiv() {
	$("#popup_div").html("");
	$("#popup_div").hide();
	$("#disable_div").hide();
	$("#popup_div").width("auto");
	$("#popup_div").height("auto");
}

var selected_index=-1;
//Row clicks in overview table
function tableRowClick(event) {
	$("#add_table tr").css("background-color", "#FFFFFF");
	$("#add_table tr").css("color", "#000000");
	$(this).css("background-color", "#3399FF");
	$(this).css("color", "#FFFFFF");
	selected_index = $(this).parent().children().index($(this));
	return false;
}

changeView = function(id) {
	$(".mainView").hide();
	$("#" + id).show();
}

function create_new_divs_for_chart_location(num) {
  $("#charts_container").append(
    '<br />' + '<h2>Location: ' + num + '</h2>' + '<hr />' +
    '<div id="storage_chart_' + num + '" class="inline-table"></div>' +
    '<div id="flux_chart_' + num + '" class="inline-table"></div>' +
    '<div id="dist_chart_' + num + '" class="inline-table"></div>' +
    '<div id="biophys_chart_' + num + '" class="inline-table"></div>' +
    '<div id="crv_chart_' + num + '" class="inline-table"></div>'
  );
}

$(document).ready(function() {
	$(window).resize(function(event) {
		centerPopup();
		var height = $(window).height() - 175;
		$("#results_image").height(height);
		$("#results_image").width(height * 1.5);
		$("#legend").width(height * 1.5 - 25);
		$(".mainView").css("max-height", (height + 37) + "px");
	});

	new_experiment = function() {
		if (confirm("Any unsaved data for the current experiment will be lost. Continue?")) {
			experiment = new Experiment("untitled", [], options);
			included_ecosystems = experiment.ecosystems;

			$("#add_table tbody tr").remove();
			selected_index = -1;
			changeView("comparison");
		}
	}

	create_results_table = function(results_array, location_number) {
		create_new_divs_for_chart_location(location_number);

		$('#results_table thead tr').html('<th>&nbsp;</th>');

		$('#co2_storage_row').html('<td>CO2 Storage</td>');
		$('#ch4_storage_row').html('<td>CH4 Storage</td>');
		$('#n2o_storage_row').html('<td>N2O Storage</td>');
		$('#co2_flux_row').html('<td>CO2 Flux</td>');
		$('#ch4_flux_row').html('<td>CH4 Flux</td>');
		$('#n2o_flux_row').html('<td>N2O Flux</td>');
		$('#co2_dist_row').html('<td>CO2 Disturbance</td>');
		$('#ch4_dist_row').html('<td>CH4 Disturbance</td>');
		$('#n2o_dist_row').html('<td>N2O Disturbance</td>');
		$('#Rnet_dist_row').html('<td>Biophysical Rnet</td>');
		$('#Rnet_dist_row').html('<td>Biophysical latent</td>');
		$('#crv_dist_row').html('<td>CRV</td>');

		var names = [];
		var co2_storage = [];
		var ch4_storage = [];
		var n2o_storage = [];
		var co2_flux = [];
		var ch4_flux = [];
		var n2o_flux = [];
		var co2_dist = [];
		var ch4_dist = [];
		var n2o_dist = [];
		var Rnet = [];
		var latent = [];
		var crv = [];

		for (i = 0; i < results_array.length; i++) {
			result = results_array[i];

			$('#results_table thead tr').append('<th>' + result.name + '</th>');

			$('#co2_storage_row').append('<td>' + result.S_CO2 + '</td>');
			$('#ch4_storage_row').append('<td>' + result.S_CH4 + '</td>');
			$('#n2o_storage_row').append('<td>' + result.S_N2O + '</td>');
			$('#co2_flux_row').append('<td>' + result.F_CO2 + '</td>');
			$('#ch4_flux_row').append('<td>' + result.F_CH4 + '</td>');
			$('#n2o_flux_row').append('<td>' + result.F_N2O + '</td>');
			$('#co2_dist_row').append('<td>' + result.D_CO2 + '</td>');
			$('#ch4_dist_row').append('<td>' + result.D_CH4 + '</td>');
			$('#n2o_dist_row').append('<td>' + result.D_N2O + '</td>');
			$('#Rnet_dist_row').append('<td>' + result.swRFV + '</td>');
			$('#latent_dist_row').append('<td>' + result.latent + '</td>');
			$('#crv_dist_row').append('<td>' + result.crv + '</td>');

			names.push(result.name.replace("_"," "));
			// Initial Storage
			co2_storage.push(result.S_CO2);
			ch4_storage.push(result.S_CH4);
			n2o_storage.push(result.S_N2O);
      // Ongoing Exchange
			co2_flux.push(result.F_CO2);
			ch4_flux.push(result.F_CH4);
			n2o_flux.push(result.F_N2O);
			// Total GHGV
			co2_dist.push(result.D_CO2);
			ch4_dist.push(result.D_CH4);
			n2o_dist.push(result.D_N2O);
      // Biophysical
			Rnet.push(-result.swRFV);
			latent.push(result.latent);
			// CRV
			crv.push(result.crv);
		}

		console.log("NAMES: " + JSON.stringify(names));

    //// Initial Storage
		new Highcharts.Chart({
			chart: {
				renderTo: String ('storage_chart_' + location_number ),
				type: 'bar',
			},
			title: {
				text: 'Initial Storage'
			},
			xAxis: {
				categories: names
			},
			yAxis: {
				title: {
					text: 'GHGV (Mg CO\u2082 -eq ha\u207B\u00B9 yr\u207B\u00B9)'
				}
			},
			credits: {
				enabled: false
			},
			series: [
			  { name: 'CO2', data: co2_storage },
			  { name: 'CH4', data: ch4_storage },
			  { name: 'N2O', data: n2o_storage }
			]
		}).setSize(185, 170 + eval( names.length * 30 ));

    //// Ongoing Exchange
		new Highcharts.Chart({
			chart: {
				renderTo: String ('flux_chart_' + location_number ),
				type: 'bar',
			},
			title: {
				text: 'Ongoing Exchange'
			},
			xAxis: {
				categories: " ",
				enabled: false
			},
			yAxis: {
				title: {
					text: 'GHGV (Mg CO\u2082 -eq ha\u207B\u00B9 yr\u207B\u00B9)'
				}
			},
			credits: {
				enabled: false
			},
			series: [
			  { name: 'CO2', data: co2_flux },
			  { name: 'CH4', data: ch4_flux },
			  { name: 'N2O', data: n2o_flux }
			]
		}).setSize(185, 170 + eval( names.length * 30 ));

    //// Total GHGV
		new Highcharts.Chart({
			chart: {
				renderTo: String ('dist_chart_' + location_number ),
				type: 'bar',
			},
			title: {
				text: 'Total GHGV'
			},
			xAxis: {
				categories: " ",
				enabled: false
			},
			yAxis: {
				title: {
					text: 'GHGV (Mg CO\u2082 -eq ha\u207B\u00B9 yr\u207B\u00B9)'
				}
			},
			credits: {
				enabled: false
			},
			series: [
			  { name: 'CO2', data: co2_dist },
			  { name: 'CH4', data: ch4_dist },
			  { name: 'N2O', data: n2o_dist }
			]
		}).setSize(185, 170 + eval( names.length * 30 ));

		//// Biophysical
		new Highcharts.Chart({
			chart: {
				renderTo: String ('biophys_chart_' + location_number ),
				type: 'bar',
			},
			title: {
				text: 'Biophysical'
			},
			xAxis: {
				categories: " ",
				enabled: false
			},
			yAxis: {
				title: {
					text: 'Biophysical'
				}
			},
			credits: {
				enabled: false
			},
			series: [
			  { name: 'Rnet', data: Rnet },
			  { name: 'latent', data: latent },
			]
		}).setSize(185, 170 + eval( names.length * 30 ));

		//// CRV
  	new Highcharts.Chart({
			chart: {
				renderTo: String ('crv_chart_' + location_number ),
				type: 'bar',
			},
			title: {
				text: 'CRV'
			},
			xAxis: {
				categories: " ",
				enabled: false
			},
			yAxis: {
				title: {
					text: 'CRV'
				}
			},
			credits: {
				enabled: false
			},
			series: [
			  { name: 'CRV', data: crv }
			]
		}).setSize(185, 170 + eval( names.length * 30 ));

		return 0;
	}

	run_calculator = function() {
		//Make sure at least 1 ecosystem is included in the calculation
		if (included_ecosystems.length == 0) {
			alert("You must include at least one ecosystem in the calculation.");
			return false;
		}

		//including or excluding maximum ghgv values
		var trav;
		var orig_anth;
		var origAnthVals = new Array();
		for(trav=0;trav<(included_ecosystems.length);trav++)
		{
			var eco = included_ecosystems[trav];
			orig_anth = eco["F_anth"];
			origAnthVals[trav] = orig_anth;
		}

		/*eco copy tells you if it's the copy of the original ecosystem. you then place max ghgv in that one*/
		for(trav = 0; trav < (included_ecosystems.length); trav++) {
			var eco = included_ecosystems[trav];
			var name = eco.name;
			var include_max_eco = JSON.stringify(eco);
			include_max_eco.name = name;

			if(eco["reg_ghgv"] == true) {
				name = name + "(Eco)";
				included_ecosystems[trav].name = name;
			}

			if(eco["reg_ghgv"] == false && eco["max_ghgv"] == true) {
					/*set the ecosystem to a max ecosystem, then reset*/
					name = name+"(Max)";
					included_ecosystems[trav].name=name;

					if(eco["maxchec"]==0)
					{
					var valueETH = eco["eth_yield"];
					var valueG_C02 = -(valueETH*(0.0348));

					var newF_anth = (valueG_C02) + eco["F_anth"];
					eco["F_anth"] = newF_anth;
					}
					else
					{
					var valueG_C02 = eco["G_C02"];
					eco["F_anth"] = (valueG_C02) + eco["F_anth"];
					}
			}

			if(eco["max_ghgv"] == true && eco["reg_ghgv"]==true) {
				include_max_eco["eco_copy"] = 1;
				include_max_eco["reg_ghgv"] = 0;
				include_max_eco.name = include_max_eco.name+"(Max)";

				/*set the variables associated with include max eco*/
				if(include_max_eco["maxcheck"] == 0) { /*have not edited ecosystem*/
					var valueETH = include_max_eco["eth_yield"];
					var valueG_C02 = -(valueETH*(0.0348));

					var newF_anth = (valueG_C02) + eco["F_anth"];
					include_max_eco["F_anth"] = newF_anth;
				}

				eco["eco_copy"]=0; /*set this to 0 don't change, orig eco is not an eco copy*/
				included_ecosystems.splice((trav+1),0,include_max_eco);

				trav++;
			}

		}

		//Set time parameters to be the same for all ecosystems
			$.each(included_ecosystems, function(i) {
				var eco = included_ecosystems[i];
				eco.T_A = experiment.options.T_A;
				eco.T_E = experiment.options.T_E;
				eco.r = experiment.options.r;
			});

		ecoData = JSON.stringify(included_ecosystems);

		showPopupDiv();
		$("#popup_div").html('<p>Calculator is running, please wait...</p>');
		centerPopup();

		//Send ecosystem and options data to the server and run the calculator
		$.ajax({
			type: "POST",
			url: "run.php",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			data: "ecosystems=" + encodeURIComponent(ecoData) + "&options=" + encodeURIComponent(JSON.stringify(options)),
			success: function(msg) {
				hidePopupDiv();
				var height = $(window).height() - 175;
				//$("#results_image").html('<embed id="result_svg" type="image/svg+xml" pluginspage = "http://www.adobe.com/svg/viewer/install/" src="' + msg + '" height="100%" width="100%"></object>');
				//$("#results_image").html('<object id="result_svg" type="image/svg+xml" data="' + msg + '" height="100%" width="100%"></object>');
				//$("#results_image").height(height);
				//$("#results_image").width(height * 1.5);
				//$("#legend").width(height * 1.5 - 25);
				//response from server is a JSON object containing an array of results
				create_results_table(msg);
				changeView("results");
			}
		});

		i = 0;
		for(i; i<(included_ecosystems.length);i++) {
			eco = included_ecosystems[i];
			name = included_ecosystems[i].name;
			var origName;
			if(eco["reg_ghgv"] == true && eco["max_ghgv"] == true) {
			/*splice the second one out, rename the first*/
				included_ecosystems.splice((i+1), 1);
				origName = name.split("(Eco)");
				included_ecosystems[i].name = origName[0];
			}
			if(eco["reg_ghgv"] == true && eco["max_ghgv"] == false) {
				origName=name.split("(Eco)");
				included_ecosystems[i].name = origName[0];
			}
			if(eco["reg_ghgv"] == false && eco["max_ghgv"] == true) {
				origName=name.split("(Max)");
				included_ecosystems[i].name = origName[0];
			}
		}
		i=0;
		for(i; i <(included_ecosystems.length);i++) {
			var eco = included_ecosystems[i];
			eco["F_anth"] = origAnthVals[i];
		}
	};

	//add_ecosystem button click event handler
	$("#add_ecosystem").click(function(event) {
		showPopup("add_ecosystem");
	});

	//edit_ecosystem button click event handler
	$("#edit_ecosystem").click(function(event) {
		if(selected_index < 0) {
			alert("Please select an ecosystem first.");
			return;
		}
		else showPopup("edit_ecosystem");
	});

	//remove_ecosystem button click event handler
	$("#remove_ecosystem").click(function(event) {
		if(selected_index<0){
			alert("Please select an ecosystem to remove first.");
			return;
		}
		else {
			included_ecosystems.splice(selected_index, 1);
			$("#add_table > tbody").children().eq(selected_index).remove();
			selected_index=-1;
		}
	});

	//move_up button click event handler
	$("#move_up").click(function(event) {
		if (selected_index > 0) {
			var temp = included_ecosystems[selected_index-1];
			included_ecosystems[selected_index-1] = included_ecosystems[selected_index];
			included_ecosystems[selected_index] = temp;

			var html = $("#add_table tbody tr").eq(selected_index).html(),
				html1 = $("#add_table tbody tr").eq(selected_index-1).html();

			$("#add_table tbody tr").eq(selected_index-1).html(html);
			$("#add_table tbody tr").eq(selected_index).html(html1);$("#add_table tr").css("background-color", "#FFFFFF");

			selected_index--;
			$("#add_table tbody tr").css("background-color", "#FFFFFF");
			$("#add_table tbody tr").css("color", "#000000");
			$("#add_table tbody tr").eq(selected_index).css("background-color", "#3399FF");
			$("#add_table tbody tr").eq(selected_index).css("color", "#FFFFFF");
		}
	});

	//move_down button click event handler
	$("#move_down").click(function(event) {
		if (selected_index < included_ecosystems.length - 1) {
			var temp = included_ecosystems[selected_index+1];
			included_ecosystems[selected_index+1] = included_ecosystems[selected_index];
			included_ecosystems[selected_index] = temp;

			var html = $("#add_table tbody tr").eq(selected_index).html(),
			html1 = $("#add_table tbody tr").eq(selected_index+1).html();

			$("#add_table tbody tr").eq(selected_index+1).html(html);
			$("#add_table tbody tr").eq(selected_index).html(html1);

			selected_index++;
			$("#add_table tbody tr").css("background-color", "#FFFFFF");
			$("#add_table tbody tr").css("color", "#000000");
			$("#add_table tbody tr").eq(selected_index).css("background-color", "#3399FF");
			$("#add_table tbody tr").eq(selected_index).css("color", "#FFFFFF");
		}
	});

	changeView("comparison");
	$(".mainView").css("max-height", ($(window).height() - 138) + "px");

  asdf = $.parseJSON("[{\"name\":\"aggrading tropical non-forest\",\"S_CO2\":4.56891931874291,\"S_CH4\":0.0587650836752113,\"S_N2O\":0.0181995344292526,\"F_CO2\":-223.961767496771,\"F_CH4\":-3.7982437401118,\"F_N2O\":6.6163375257073,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"aggrading boreal forest\",\"S_CO2\":4.56309041699992,\"S_CH4\":0.0587650836752113,\"S_N2O\":0.0181995344292526,\"F_CO2\":-262.729609260597,\"F_CH4\":-4.53044980599371,\"F_N2O\":13.8697519920716,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"switchgrass\",\"S_CO2\":51.50879518436,\"S_CH4\":0,\"S_N2O\":0,\"F_CO2\":24.81059436629,\"F_CH4\":-2.51698342701926,\"F_N2O\":24.3963309937809,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"temperate grassland\",\"S_CO2\":163.269213543001,\"S_CH4\":0.374980551700073,\"S_N2O\":0.40898449700934,\"F_CO2\":-58.9763006004584,\"F_CH4\":-2.97456206709505,\"F_N2O\":6.48278293459747,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"aggrading tropical forest\",\"S_CO2\":4.56309041699992,\"S_CH4\":0.0587650836752113,\"S_N2O\":0.0181995344292526,\"F_CO2\":-463.068959358755,\"F_CH4\":-4.53053004775435,\"F_N2O\":29.7798338969974,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"scrub/woodland\",\"S_CO2\":271.104915549568,\"S_CH4\":2.34182957152679,\"S_N2O\":2.55419110417906,\"F_CO2\":-247.868281691267,\"F_CH4\":-3.7982437401118,\"F_N2O\":6.74989211681713,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"tropical savanna\",\"S_CO2\":269.449724925106,\"S_CH4\":1.62796892414889,\"S_N2O\":1.66918180225197,\"F_CO2\":-145.537158913679,\"F_CH4\":-3.7983189667624,\"F_N2O\":15.7649670336409,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"desert\",\"S_CO2\":112.345727330007,\"S_CH4\":0.31560727990541,\"S_N2O\":0.344227144686273,\"F_CO2\":-18.7575807337944,\"F_CH4\":-3.7982437401118,\"F_N2O\":2.88488687328781,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"tundra\",\"S_CO2\":418.77056256146,\"S_CH4\":3.83171499448908,\"S_N2O\":4.17918215384597,\"F_CO2\":-45.6761753997656,\"F_CH4\":-3.7982437401118,\"F_N2O\":6.48278293459747,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0}]");

//  asdf2 = $.parseJSON("{\"ecosystem_0_data\":[{\"name\":\"Tropical Forest\",\"S_CO2\":715.481930448906,\"S_CH4\":18.5897095138668,\"S_N2O\":11.2808552885403,\"F_CO2\":-264.088404311696,\"F_CH4\":-4.53053004775435,\"F_N2O\":43.9477537844218,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"Misty Mountain Top\",\"S_CO2\":183.54445481929,\"S_CH4\":140.39500394662,\"S_N2O\":446.523494486041,\"F_CO2\":-264.088404311696,\"F_CH4\":-4.53053004775435,\"F_N2O\":43.9477537844218,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0}],\"ecosystem_1_data\":[{\"name\":\"Temperate Forest\",\"S_CO2\":715.481930448906,\"S_CH4\":18.5897095138668,\"S_N2O\":11.2808552885403,\"F_CO2\":-264.088404311696,\"F_CH4\":-4.53053004775435,\"F_N2O\":43.9477537844218,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0},{\"name\":\"Misty Mountain Hop\",\"S_CO2\":183.54445481929,\"S_CH4\":140.39500394662,\"S_N2O\":446.523494486041,\"F_CO2\":-264.088404311696,\"F_CH4\":-4.53053004775435,\"F_N2O\":43.9477537844218,\"D_CO2\":0,\"D_CH4\":0,\"D_N2O\":0}]}");

// Example output from
asdf2 = $.parseJSON('{"site_0_data":[{"name":"Tropical Forest","S_CO2":3077.19440798194,"S_CH4":8.71414987655346,"S_N2O":221.440495767305,"F_CO2":-777.589630035838,"F_CH4":198.153276609512,"F_N2O":9.21042004738499,"D_CO2":0,"D_CH4":0,"D_N2O":0},{"name":"Misty Mountain Top","S_CO2":715.481930448906,"S_CH4":18.5897095138668,"S_N2O":11.2808552885403,"F_CO2":-264.088404311696,"F_CH4":-4.53053004775435,"F_N2O":43.9477537844218,"D_CO2":0,"D_CH4":0,"D_N2O":0}],"site_1_data":[{"name":"Temperate Forest","S_CO2":4.56309041699992,"S_CH4":0.0587650836752113,"S_N2O":0.0181995344292526,"F_CO2":-463.068959358755,"F_CH4":-4.53053004775435,"F_N2O":29.7798338969974,"D_CO2":0,"D_CH4":0,"D_N2O":0},{"name":"Misty Mountain Hop","S_CO2":271.104915549568,"S_CH4":2.34182957152679,"S_N2O":2.55419110417906,"F_CO2":-247.868281691267,"F_CH4":-3.7982437401118,"F_N2O":6.74989211681713,"D_CO2":0,"D_CH4":0,"D_N2O":0}]}');


//  // Here we iterate through the ghgvcR output data ( Arrays of Hashes, key-indexed by their location: ecosystem_X_data )
//  $.each(asdf2, function(k,v){
//    console.log("key: "+k+" .. and value:");
//    console.log(v);
//    var location_num = k.split('_')[1]
//    create_results_table(v ,location_num );
//  });

//  create_results_table(asdf,0);
//  create_results_table(asdf,1);
});
