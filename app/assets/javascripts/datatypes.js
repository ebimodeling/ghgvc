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
