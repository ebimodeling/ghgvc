# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121117210155) do

  create_table "citations", :force => true do |t|
    t.string   "author"
    t.integer  "year"
    t.string   "title"
    t.string   "journal"
    t.integer  "vol"
    t.string   "pg"
    t.string   "url",        :limit => 512
    t.string   "pdf"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "doi"
    t.integer  "user_id"
  end

  create_table "citations_sites", :id => false, :force => true do |t|
    t.integer  "citation_id"
    t.integer  "site_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "citations_sites", ["citation_id", "site_id"], :name => "index_citations_sites_on_citation_id_and_site_id", :unique => true

  create_table "citations_treatments", :id => false, :force => true do |t|
    t.integer  "citation_id"
    t.integer  "treatment_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "citations_treatments", ["citation_id", "treatment_id"], :name => "index_citations_treatments_on_citation_id_and_treatment_id", :unique => true

  create_table "containers_files", :id => false, :force => true do |t|
    t.integer "container_id"
    t.string  "container_type"
    t.integer "file_id"
  end

  add_index "containers_files", ["container_id"], :name => "index_containers_files_on_container_id", :unique => true
  add_index "containers_files", ["container_type"], :name => "index_containers_files_on_container_type", :unique => true
  add_index "containers_files", ["file_id"], :name => "index_containers_files_on_file_id", :unique => true

  create_table "counties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "state"
    t.integer  "state_fips"
    t.integer  "county_fips"
  end

  create_table "county_boundaries", :force => true do |t|
    t.integer  "county_id"
    t.decimal  "lat",        :precision => 20, :scale => 15
    t.decimal  "lng",        :precision => 20, :scale => 15
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.decimal  "zoom0x",     :precision => 20, :scale => 10
    t.decimal  "zoom0y",     :precision => 20, :scale => 10
    t.boolean  "zoom0skip"
    t.decimal  "zoom1x",     :precision => 20, :scale => 10
    t.decimal  "zoom1y",     :precision => 20, :scale => 10
    t.boolean  "zoom1skip"
    t.decimal  "zoom2x",     :precision => 20, :scale => 10
    t.decimal  "zoom2y",     :precision => 20, :scale => 10
    t.decimal  "zoom3x",     :precision => 20, :scale => 10
    t.decimal  "zoom3y",     :precision => 20, :scale => 10
    t.decimal  "zoom4x",     :precision => 20, :scale => 10
    t.decimal  "zoom4y",     :precision => 20, :scale => 10
    t.decimal  "zoom5x",     :precision => 20, :scale => 10
    t.decimal  "zoom5y",     :precision => 20, :scale => 10
    t.decimal  "zoom6x",     :precision => 20, :scale => 10
    t.decimal  "zoom6y",     :precision => 20, :scale => 10
    t.decimal  "zoom7x",     :precision => 20, :scale => 10
    t.decimal  "zoom7y",     :precision => 20, :scale => 10
    t.decimal  "zoom8x",     :precision => 20, :scale => 10
    t.decimal  "zoom8y",     :precision => 20, :scale => 10
    t.decimal  "zoom9x",     :precision => 20, :scale => 10
    t.decimal  "zoom9y",     :precision => 20, :scale => 10
    t.decimal  "zoom10x",    :precision => 20, :scale => 10
    t.decimal  "zoom10y",    :precision => 20, :scale => 10
    t.decimal  "zoom11x",    :precision => 20, :scale => 10
    t.decimal  "zoom11y",    :precision => 20, :scale => 10
  end

  add_index "county_boundaries", ["county_id"], :name => "index_county_boundaries_on_county_id"
  add_index "county_boundaries", ["zoom0x", "zoom0y", "zoom0skip"], :name => "index_county_boundaries_on_zoom0x_and_zoom0y_and_zoom0skip"
  add_index "county_boundaries", ["zoom10x", "zoom10y"], :name => "index_county_boundaries_on_zoom10x_and_zoom10y"
  add_index "county_boundaries", ["zoom11x", "zoom11y"], :name => "index_county_boundaries_on_zoom11x_and_zoom11y"
  add_index "county_boundaries", ["zoom1x", "zoom1y", "zoom1skip"], :name => "index_county_boundaries_on_zoom1x_and_zoom1y_and_zoom1skip"
  add_index "county_boundaries", ["zoom2x", "zoom2y"], :name => "index_county_boundaries_on_zoom2x_and_zoom2y"
  add_index "county_boundaries", ["zoom3x", "zoom3y"], :name => "index_county_boundaries_on_zoom3x_and_zoom3y"
  add_index "county_boundaries", ["zoom4x", "zoom4y"], :name => "index_county_boundaries_on_zoom4x_and_zoom4y"
  add_index "county_boundaries", ["zoom5x", "zoom5y"], :name => "index_county_boundaries_on_zoom5x_and_zoom5y"
  add_index "county_boundaries", ["zoom6x", "zoom6y"], :name => "index_county_boundaries_on_zoom6x_and_zoom6y"
  add_index "county_boundaries", ["zoom7x", "zoom7y"], :name => "index_county_boundaries_on_zoom7x_and_zoom7y"
  add_index "county_boundaries", ["zoom8x", "zoom8y"], :name => "index_county_boundaries_on_zoom8x_and_zoom8y"
  add_index "county_boundaries", ["zoom9x", "zoom9y"], :name => "index_county_boundaries_on_zoom9x_and_zoom9y"

  create_table "county_paths", :force => true do |t|
    t.integer  "county_id"
    t.integer  "zoom"
    t.text     "path"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "county_paths", ["county_id", "zoom"], :name => "index_county_paths_on_county_id_and_zoom"
  add_index "county_paths", ["county_id"], :name => "index_county_paths_on_county_id"

  create_table "covariates", :force => true do |t|
    t.integer  "trait_id"
    t.integer  "variable_id"
    t.decimal  "level",       :precision => 16, :scale => 4
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "n"
    t.string   "statname"
    t.decimal  "stat",        :precision => 16, :scale => 4
  end

  add_index "covariates", ["trait_id", "variable_id"], :name => "index_covariates_on_trait_id_and_variable_id"

  create_table "cultivars", :force => true do |t|
    t.integer  "specie_id"
    t.string   "name"
    t.string   "ecotype"
    t.text     "notes"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "previous_id"
  end

  add_index "cultivars", ["specie_id"], :name => "index_cultivars_on_specie_id"

  create_table "dbfiles", :force => true do |t|
    t.integer "created_user_id"
    t.integer "updated_user_id"
    t.integer "machine_id"
    t.integer "container_type"
    t.integer "file_id"
  end

  add_index "dbfiles", ["container_type"], :name => "index_dbfiles_on_container_type"
  add_index "dbfiles", ["created_user_id"], :name => "index_dbfiles_on_created_user_id"
  add_index "dbfiles", ["machine_id"], :name => "index_dbfiles_on_machine_id"
  add_index "dbfiles", ["updated_user_id"], :name => "index_dbfiles_on_updated_user_id"

  create_table "ensembles", :force => true do |t|
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "runtype"
  end

  create_table "entities", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "entities", ["parent_id"], :name => "index_entities_on_parent_id"

  create_table "files", :force => true do |t|
    t.string  "file_name"
    t.string  "file_path"
    t.string  "md5"
    t.integer "created_user_id"
    t.integer "updated_user_id"
    t.integer "machine_id"
    t.integer "format_id"
  end

  create_table "formats", :force => true do |t|
    t.string   "mime_type"
    t.text     "dataformat"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.string   "header"
    t.string   "skip"
  end

  add_index "formats", ["mime_type"], :name => "index_formats_on_mime_type"

  create_table "formats_variables", :force => true do |t|
    t.integer  "format_id"
    t.integer  "variable_id"
    t.string   "name"
    t.string   "unit"
    t.string   "storage_type"
    t.integer  "column_number"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "formats_variables", ["format_id", "variable_id"], :name => "index_formats_variables_on_format_id_and_variable_id"

  create_table "input_files", :force => true do |t|
    t.integer  "file_id"
    t.integer  "format_id"
    t.string   "file_name"
    t.string   "file_path"
    t.integer  "machine_id"
    t.string   "md5"
    t.integer  "created_user_id"
    t.integer  "updated_user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "inputs", :force => true do |t|
    t.integer  "site_id"
    t.text     "notes"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "user_id"
    t.integer  "access_level"
    t.boolean  "raw"
    t.integer  "format_id"
    t.integer  "file_id"
  end

  add_index "inputs", ["format_id"], :name => "index_inputs_on_format_id"
  add_index "inputs", ["parent_id"], :name => "index_inputs_on_parent_id"
  add_index "inputs", ["site_id"], :name => "index_inputs_on_site_id"
  add_index "inputs", ["user_id"], :name => "index_inputs_on_user_id"

  create_table "inputs_runs", :id => false, :force => true do |t|
    t.integer  "input_id"
    t.integer  "run_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "inputs_runs", ["input_id", "run_id"], :name => "index_inputs_runs_on_input_id_and_run_id", :unique => true

  create_table "inputs_variables", :id => false, :force => true do |t|
    t.integer  "input_id"
    t.integer  "variable_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "inputs_variables", ["input_id", "variable_id"], :name => "index_inputs_variables_on_input_id_and_variable_id", :unique => true

  create_table "likelihoods", :force => true do |t|
    t.integer  "run_id"
    t.integer  "variable_id"
    t.integer  "input_id"
    t.decimal  "loglikelihood", :precision => 10, :scale => 0
    t.decimal  "n_eff",         :precision => 10, :scale => 0
    t.decimal  "weight",        :precision => 10, :scale => 0
    t.decimal  "residual",      :precision => 10, :scale => 0
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "likelihoods", ["input_id"], :name => "index_likelihoods_on_input_id"
  add_index "likelihoods", ["run_id"], :name => "index_likelihoods_on_run_id"
  add_index "likelihoods", ["variable_id"], :name => "index_likelihoods_on_variable_id"

  create_table "location_yields", :force => true do |t|
    t.decimal  "yield",      :precision => 20, :scale => 15
    t.string   "species"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "county_id"
  end

  add_index "location_yields", ["county_id"], :name => "index_location_yields_on_county_id"
  add_index "location_yields", ["species", "county_id"], :name => "index_location_yields_on_species_and_county_id"
  add_index "location_yields", ["species"], :name => "index_location_yields_on_location_and_species"
  add_index "location_yields", ["yield"], :name => "index_location_yields_on_yield"

  create_table "machines", :force => true do |t|
    t.string   "hostname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "machines", ["hostname"], :name => "index_machines_on_hostname"

  create_table "managements", :force => true do |t|
    t.integer  "citation_id"
    t.date     "date"
    t.decimal  "dateloc",     :precision => 4,  :scale => 2
    t.string   "mgmttype"
    t.decimal  "level",       :precision => 16, :scale => 4
    t.string   "units"
    t.text     "notes"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "user_id"
  end

  add_index "managements", ["citation_id"], :name => "index_managements_on_citation_id"
  add_index "managements", ["user_id"], :name => "index_managements_on_user_id"

  create_table "managements_treatments", :id => false, :force => true do |t|
    t.integer  "treatment_id"
    t.integer  "management_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "managements_treatments", ["management_id", "treatment_id"], :name => "index_managements_treatments_on_management_id_and_treatment_id", :unique => true

  create_table "methods", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "citation_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "methods", ["citation_id"], :name => "index_methods_on_citation_id"

  create_table "mimetypes", :force => true do |t|
    t.string "type_string"
  end

  create_table "pfts", :force => true do |t|
    t.text     "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.integer  "parent_id"
  end

  create_table "pfts_priors", :id => false, :force => true do |t|
    t.integer  "pft_id"
    t.integer  "prior_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pfts_priors", ["pft_id", "prior_id"], :name => "index_pfts_priors_on_pft_id_and_prior_id", :unique => true

  create_table "pfts_species", :id => false, :force => true do |t|
    t.integer  "pft_id"
    t.integer  "specie_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pfts_species", ["pft_id", "specie_id"], :name => "index_pfts_species_on_pft_id_and_specie_id", :unique => true

  create_table "plants", :force => true do |t|
    t.string   "AcceptedSymbol"
    t.string   "SynonymSymbol"
    t.string   "ScientificName"
    t.string   "Symbol"
    t.string   "CommonName"
    t.text     "PLANTS_Floristic_Area"
    t.text     "State"
    t.string   "Category"
    t.string   "Genus"
    t.string   "Family"
    t.string   "FamilySymbol"
    t.string   "FamilyCommonName"
    t.string   "xOrder"
    t.string   "SubClass"
    t.string   "Class"
    t.string   "SubDivision"
    t.string   "Division"
    t.string   "SuperDivision"
    t.string   "SubKingdom"
    t.string   "Kingdom"
    t.integer  "ITIS_TSN"
    t.string   "Duration"
    t.string   "GrowthHabit"
    t.string   "NativeStatus"
    t.string   "FederalNoxiousStatus"
    t.string   "FederalNoxiousCommonName"
    t.text     "StateNoxiousStatus"
    t.text     "StateNoxiousCommonName"
    t.string   "Invasive"
    t.string   "Federal_TE_Status"
    t.string   "State_TE_Status"
    t.text     "State_TE_Common_Name"
    t.string   "NationalWetlandIndicatorStatus"
    t.string   "RegionalWetlandIndicatorStatus"
    t.string   "ActiveGrowthPeriod"
    t.string   "AfterHarvestRegrowthRate"
    t.string   "Bloat"
    t.string   "C2N_Ratio"
    t.string   "CoppicePotential"
    t.string   "FallConspicuous"
    t.string   "FireResistance"
    t.string   "FlowerColor"
    t.string   "FlowerConspicuous"
    t.string   "FoliageColor"
    t.string   "FoliagePorositySummer"
    t.string   "FoliagePorosityWinter"
    t.string   "FoliageTexture"
    t.string   "FruitColor"
    t.string   "FruitConspicuous"
    t.string   "GrowthForm"
    t.string   "GrowthRate"
    t.integer  "MaxHeight20Yrs"
    t.integer  "MatureHeight"
    t.string   "KnownAllelopath"
    t.string   "LeafRetention"
    t.string   "Lifespan"
    t.string   "LowGrowingGrass"
    t.string   "NitrogenFixation"
    t.string   "ResproutAbility"
    t.string   "Shape_and_Orientation"
    t.string   "Toxicity"
    t.string   "AdaptedCoarseSoils"
    t.string   "AdaptedMediumSoils"
    t.string   "AdaptedFineSoils"
    t.string   "AnaerobicTolerance"
    t.string   "CaCO3Tolerance"
    t.string   "ColdStratification"
    t.string   "DroughtTolerance"
    t.string   "FertilityRequirement"
    t.string   "FireTolerance"
    t.integer  "MinFrostFreeDays"
    t.string   "HedgeTolerance"
    t.string   "MoistureUse"
    t.decimal  "pH_Minimum",                     :precision => 5, :scale => 2
    t.decimal  "pH_Maximum",                     :precision => 5, :scale => 2
    t.integer  "Min_PlantingDensity"
    t.integer  "Max_PlantingDensity"
    t.integer  "Precipitation_Minimum"
    t.integer  "Precipitation_Maximum"
    t.integer  "RootDepthMinimum"
    t.string   "SalinityTolerance"
    t.string   "ShadeTolerance"
    t.integer  "TemperatureMinimum"
    t.string   "BloomPeriod"
    t.string   "CommercialAvailability"
    t.string   "FruitSeedAbundance"
    t.string   "FruitSeedPeriodBegin"
    t.string   "FruitSeedPeriodEnd"
    t.string   "FruitSeedPersistence"
    t.string   "Propogated_by_BareRoot"
    t.string   "Propogated_by_Bulbs"
    t.string   "Propogated_by_Container"
    t.string   "Propogated_by_Corms"
    t.string   "Propogated_by_Cuttings"
    t.string   "Propogated_by_Seed"
    t.string   "Propogated_by_Sod"
    t.string   "Propogated_by_Sprigs"
    t.string   "Propogated_by_Tubers"
    t.integer  "Seeds_per_Pound"
    t.string   "SeedSpreadRate"
    t.string   "SeedlingVigor"
    t.string   "SmallGrain"
    t.string   "VegetativeSpreadRate"
    t.string   "Berry_Nut_Seed_Product"
    t.string   "ChristmasTreeProduct"
    t.string   "FodderProduct"
    t.string   "FuelwoodProduct"
    t.string   "LumberProduct"
    t.string   "NavalStoreProduct"
    t.string   "NurseryStockProduct"
    t.string   "PalatableBrowseAnimal"
    t.string   "PalatableGrazeAnimal"
    t.string   "PalatableHuman"
    t.string   "PostProduct"
    t.string   "ProteinPotential"
    t.string   "PulpwoodProduct"
    t.string   "VeneerProduct"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  create_table "posteriors", :force => true do |t|
    t.integer  "pft_id"
    t.string   "filename"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "posteriors", ["parent_id"], :name => "index_posteriors_on_parent_id"
  add_index "posteriors", ["pft_id"], :name => "index_posteriors_on_pft_id"

  create_table "posteriors_runs", :id => false, :force => true do |t|
    t.integer  "posterior_id"
    t.integer  "run_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "posteriors_runs", ["posterior_id", "run_id"], :name => "index_posteriors_runs_on_posterior_id_and_run_id", :unique => true

  create_table "priors", :force => true do |t|
    t.integer  "citation_id"
    t.string   "variable_id"
    t.string   "phylogeny"
    t.string   "distn"
    t.decimal  "parama",      :precision => 16, :scale => 4
    t.decimal  "paramb",      :precision => 16, :scale => 4
    t.decimal  "paramc",      :precision => 16, :scale => 4
    t.integer  "n"
    t.text     "notes"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "priors", ["citation_id"], :name => "index_priors_on_citation_id"
  add_index "priors", ["variable_id"], :name => "index_priors_on_variable_id"

  create_table "runs", :force => true do |t|
    t.integer  "model_id"
    t.integer  "site_id"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.string   "outdir"
    t.string   "outprefix"
    t.string   "setting"
    t.text     "parameter_list"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "ensemble_id"
    t.string   "start_date"
    t.string   "end_date"
  end

  add_index "runs", ["ensemble_id"], :name => "index_runs_on_ensemble_id"
  add_index "runs", ["model_id"], :name => "index_runs_on_model_id"
  add_index "runs", ["site_id"], :name => "index_runs_on_site_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simulationmodels", :force => true do |t|
    t.string   "model_name"
    t.string   "model_path"
    t.decimal  "revision",   :precision => 10, :scale => 0
    t.integer  "parent_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "model_type"
    t.integer  "site_id"
    t.integer  "model_id"
    t.string   "hostname"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "params"
  end

  add_index "simulationmodels", ["parent_id"], :name => "index_models_on_parent_id"

  create_table "sites", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.decimal  "lat",        :precision => 9, :scale => 6
    t.decimal  "lon",        :precision => 9, :scale => 6
    t.integer  "mat"
    t.integer  "map"
    t.integer  "masl"
    t.string   "soil"
    t.decimal  "som",        :precision => 4, :scale => 2
    t.text     "notes"
    t.text     "soilnotes"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "sitename"
    t.boolean  "greenhouse"
    t.integer  "user_id"
    t.integer  "local_time"
    t.decimal  "sand_pct",   :precision => 9, :scale => 5
    t.decimal  "clay_pct",   :precision => 9, :scale => 5
    t.string   "espg"
  end

  add_index "sites", ["user_id"], :name => "index_sites_on_user_id"

  create_table "species", :force => true do |t|
    t.integer  "spcd"
    t.string   "genus"
    t.string   "species"
    t.string   "scientificname"
    t.string   "commonname"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.text     "notes"
    t.string   "AcceptedSymbol"
    t.string   "SynonymSymbol"
    t.string   "Symbol"
    t.text     "PLANTS_Floristic_Area"
    t.text     "State"
    t.string   "Category"
    t.string   "Family"
    t.string   "FamilySymbol"
    t.string   "FamilyCommonName"
    t.string   "xOrder"
    t.string   "SubClass"
    t.string   "Class"
    t.string   "SubDivision"
    t.string   "Division"
    t.string   "SuperDivision"
    t.string   "SubKingdom"
    t.string   "Kingdom"
    t.integer  "ITIS_TSN"
    t.string   "Duration"
    t.string   "GrowthHabit"
    t.string   "NativeStatus"
    t.string   "FederalNoxiousStatus"
    t.string   "FederalNoxiousCommonName"
    t.text     "StateNoxiousStatus"
    t.text     "StateNoxiousCommonName"
    t.string   "Invasive"
    t.string   "Federal_TE_Status"
    t.string   "State_TE_Status"
    t.text     "State_TE_Common_Name"
    t.string   "NationalWetlandIndicatorStatus"
    t.string   "RegionalWetlandIndicatorStatus"
    t.string   "ActiveGrowthPeriod"
    t.string   "AfterHarvestRegrowthRate"
    t.string   "Bloat"
    t.string   "C2N_Ratio"
    t.string   "CoppicePotential"
    t.string   "FallConspicuous"
    t.string   "FireResistance"
    t.string   "FlowerColor"
    t.string   "FlowerConspicuous"
    t.string   "FoliageColor"
    t.string   "FoliagePorositySummer"
    t.string   "FoliagePorosityWinter"
    t.string   "FoliageTexture"
    t.string   "FruitColor"
    t.string   "FruitConspicuous"
    t.string   "GrowthForm"
    t.string   "GrowthRate"
    t.integer  "MaxHeight20Yrs"
    t.integer  "MatureHeight"
    t.string   "KnownAllelopath"
    t.string   "LeafRetention"
    t.string   "Lifespan"
    t.string   "LowGrowingGrass"
    t.string   "NitrogenFixation"
    t.string   "ResproutAbility"
    t.string   "Shape_and_Orientation"
    t.string   "Toxicity"
    t.string   "AdaptedCoarseSoils"
    t.string   "AdaptedMediumSoils"
    t.string   "AdaptedFineSoils"
    t.string   "AnaerobicTolerance"
    t.string   "CaCO3Tolerance"
    t.string   "ColdStratification"
    t.string   "DroughtTolerance"
    t.string   "FertilityRequirement"
    t.string   "FireTolerance"
    t.integer  "MinFrostFreeDays"
    t.string   "HedgeTolerance"
    t.string   "MoistureUse"
    t.decimal  "pH_Minimum",                     :precision => 5, :scale => 2
    t.decimal  "pH_Maximum",                     :precision => 5, :scale => 2
    t.integer  "Min_PlantingDensity"
    t.integer  "Max_PlantingDensity"
    t.integer  "Precipitation_Minimum"
    t.integer  "Precipitation_Maximum"
    t.integer  "RootDepthMinimum"
    t.string   "SalinityTolerance"
    t.string   "ShadeTolerance"
    t.integer  "TemperatureMinimum"
    t.string   "BloomPeriod"
    t.string   "CommercialAvailability"
    t.string   "FruitSeedAbundance"
    t.string   "FruitSeedPeriodBegin"
    t.string   "FruitSeedPeriodEnd"
    t.string   "FruitSeedPersistence"
    t.string   "Propogated_by_BareRoot"
    t.string   "Propogated_by_Bulbs"
    t.string   "Propogated_by_Container"
    t.string   "Propogated_by_Corms"
    t.string   "Propogated_by_Cuttings"
    t.string   "Propogated_by_Seed"
    t.string   "Propogated_by_Sod"
    t.string   "Propogated_by_Sprigs"
    t.string   "Propogated_by_Tubers"
    t.integer  "Seeds_per_Pound"
    t.string   "SeedSpreadRate"
    t.string   "SeedlingVigor"
    t.string   "SmallGrain"
    t.string   "VegetativeSpreadRate"
    t.string   "Berry_Nut_Seed_Product"
    t.string   "ChristmasTreeProduct"
    t.string   "FodderProduct"
    t.string   "FuelwoodProduct"
    t.string   "LumberProduct"
    t.string   "NavalStoreProduct"
    t.string   "NurseryStockProduct"
    t.string   "PalatableBrowseAnimal"
    t.string   "PalatableGrazeAnimal"
    t.string   "PalatableHuman"
    t.string   "PostProduct"
    t.string   "ProteinPotential"
    t.string   "PulpwoodProduct"
    t.string   "VeneerProduct"
  end

  create_table "traits", :force => true do |t|
    t.integer  "site_id"
    t.integer  "specie_id"
    t.integer  "citation_id"
    t.integer  "cultivar_id"
    t.integer  "treatment_id"
    t.integer  "variable_id"
    t.datetime "date"
    t.decimal  "dateloc",      :precision => 4,  :scale => 2
    t.time     "time"
    t.decimal  "timeloc",      :precision => 4,  :scale => 2
    t.decimal  "mean",         :precision => 16, :scale => 4
    t.integer  "n"
    t.string   "statname"
    t.decimal  "stat",         :precision => 16, :scale => 4
    t.text     "notes"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.integer  "user_id"
    t.integer  "checked",                                     :default => 0
    t.integer  "access_level"
    t.integer  "entity_id"
    t.integer  "method_id"
    t.integer  "date_year"
    t.integer  "date_month"
    t.integer  "date_day"
    t.integer  "time_hour"
    t.integer  "time_minute"
  end

  add_index "traits", ["citation_id"], :name => "index_traits_on_citation_id"
  add_index "traits", ["cultivar_id"], :name => "index_traits_on_cultivar_id"
  add_index "traits", ["entity_id"], :name => "index_traits_on_entity_id"
  add_index "traits", ["method_id"], :name => "index_traits_on_method_id"
  add_index "traits", ["site_id"], :name => "index_traits_on_site_id"
  add_index "traits", ["specie_id"], :name => "index_traits_on_specie_id"
  add_index "traits", ["treatment_id"], :name => "index_traits_on_treatment_id"
  add_index "traits", ["user_id"], :name => "index_traits_on_user_id"
  add_index "traits", ["variable_id"], :name => "index_traits_on_variable_id"

  create_table "treatments", :force => true do |t|
    t.string   "name"
    t.string   "definition"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "control"
    t.integer  "user_id"
  end

  add_index "treatments", ["user_id"], :name => "index_treatments_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "city"
    t.string   "country"
    t.string   "field"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "access_level"
    t.integer  "page_access_level"
    t.string   "apikey"
    t.string   "state_prov"
    t.string   "postal_code"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "variables", :force => true do |t|
    t.string   "description"
    t.string   "units"
    t.text     "notes"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
    t.string   "max"
    t.string   "min"
  end

  create_table "visitors", :force => true do |t|
    t.string   "ip"
    t.text     "page"
    t.datetime "visitdate"
    t.decimal  "lat",        :precision => 16, :scale => 8
    t.decimal  "lon",        :precision => 16, :scale => 8
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "workflows", :force => true do |t|
    t.string   "folder"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "advanced_edit", :default => false
    t.integer  "site_id"
    t.integer  "model_id",                         :null => false
    t.string   "hostname"
    t.string   "params"
  end

  create_table "yields", :force => true do |t|
    t.integer  "citation_id"
    t.integer  "site_id"
    t.integer  "specie_id"
    t.integer  "treatment_id"
    t.integer  "cultivar_id"
    t.date     "date"
    t.decimal  "dateloc",      :precision => 4,  :scale => 2
    t.string   "statname"
    t.decimal  "stat",         :precision => 16, :scale => 4
    t.decimal  "mean",         :precision => 16, :scale => 4
    t.integer  "n"
    t.text     "notes"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.integer  "user_id"
    t.integer  "checked",                                     :default => 0
    t.integer  "access_level"
    t.integer  "method_id"
  end

  add_index "yields", ["citation_id"], :name => "index_yields_on_citation_id"
  add_index "yields", ["cultivar_id"], :name => "index_yields_on_cultivar_id"
  add_index "yields", ["method_id"], :name => "index_yields_on_method_id"
  add_index "yields", ["site_id"], :name => "index_yields_on_site_id"
  add_index "yields", ["specie_id"], :name => "index_yields_on_specie_id"
  add_index "yields", ["treatment_id"], :name => "index_yields_on_treatment_id"
  add_index "yields", ["user_id"], :name => "index_yields_on_user_id"

  create_table "yieldsview", :id => false, :force => true do |t|
    t.integer "yield_id",                                                   :default => 0,  :null => false
    t.integer "citation_id"
    t.integer "site_id"
    t.string  "site"
    t.decimal "lat",                         :precision => 9,  :scale => 6
    t.decimal "lon",                         :precision => 9,  :scale => 6
    t.string  "sp"
    t.string  "author"
    t.integer "cityear"
    t.string  "trt"
    t.date    "date"
    t.integer "month"
    t.integer "year"
    t.decimal "mean",                        :precision => 16, :scale => 4
    t.integer "n"
    t.string  "statname"
    t.decimal "stat",                        :precision => 16, :scale => 4
    t.text    "notes"
    t.string  "user",         :limit => 100,                                :default => ""
    t.integer "checked",                                                    :default => 0
    t.integer "access_level"
    t.integer "user_id"
  end

end
