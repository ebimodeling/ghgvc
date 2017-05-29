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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20121220200223) do

  create_table "citations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "author"
    t.integer "year"
    t.string "title"
    t.string "journal"
    t.integer "vol"
    t.string "pg"
    t.string "url", limit: 512
    t.string "pdf"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "doi"
    t.integer "user_id"
    t.index ["user_id"], name: "index_citations_on_user_id"
  end

  create_table "citations_sites", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "citation_id"
    t.integer "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["citation_id", "site_id"], name: "index_citations_sites_on_citation_id_and_site_id", unique: true
  end

  create_table "citations_treatments", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "citation_id"
    t.integer "treatment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["citation_id", "treatment_id"], name: "index_citations_treatments_on_citation_id_and_treatment_id", unique: true
  end

  create_table "coppice", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "treatment_id"
    t.integer "management_id"
    t.string "mgmttype"
    t.date "date"
    t.decimal "level", precision: 16, scale: 4
    t.string "units"
  end

  create_table "counties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "state"
    t.integer "state_fips"
    t.integer "county_fips"
  end

  create_table "covariates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "trait_id"
    t.integer "variable_id"
    t.decimal "level", precision: 16, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "n"
    t.string "statname"
    t.decimal "stat", precision: 16, scale: 4
    t.index ["trait_id", "variable_id"], name: "index_covariates_on_trait_id_and_variable_id"
  end

  create_table "cultivars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "specie_id"
    t.string "name"
    t.string "ecotype"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "previous_id"
    t.index ["specie_id"], name: "index_cultivars_on_specie_id"
  end

  create_table "dbfiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "file_name"
    t.string "file_path"
    t.string "md5"
    t.integer "created_user_id"
    t.integer "updated_user_id"
    t.integer "machine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "container_type"
    t.integer "file_id"
    t.index ["container_type"], name: "index_dbfiles_on_container_id_and_container_type"
    t.index ["created_user_id"], name: "index_dbfiles_on_created_user_id"
    t.index ["machine_id"], name: "index_dbfiles_on_machine_id"
    t.index ["updated_user_id"], name: "index_dbfiles_on_updated_user_id"
  end

  create_table "ensembles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "runtype"
  end

  create_table "entities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "parent_id"
    t.string "name"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id"], name: "index_entities_on_parent_id"
  end

  create_table "formats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "mime_type"
    t.text "dataformat"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "header"
    t.string "skip"
    t.index ["mime_type"], name: "index_formats_on_mime_type"
  end

  create_table "formats_variables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "format_id"
    t.integer "variable_id"
    t.string "name"
    t.string "unit"
    t.string "storage_type"
    t.integer "column_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["format_id", "variable_id"], name: "index_formats_variables_on_format_id_and_variable_id"
  end

  create_table "inputs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "name"
    t.integer "parent_id"
    t.integer "user_id"
    t.integer "access_level"
    t.boolean "raw"
    t.integer "format_id"
    t.integer "file_id"
    t.index ["format_id"], name: "index_inputs_on_format_id"
    t.index ["parent_id"], name: "index_inputs_on_parent_id"
    t.index ["site_id"], name: "index_inputs_on_site_id"
    t.index ["user_id"], name: "index_inputs_on_user_id"
  end

  create_table "inputs_runs", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "input_id"
    t.integer "run_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["input_id", "run_id"], name: "index_inputs_runs_on_input_id_and_run_id", unique: true
  end

  create_table "inputs_variables", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "input_id"
    t.integer "variable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["input_id", "variable_id"], name: "index_inputs_variables_on_input_id_and_variable_id", unique: true
  end

  create_table "likelihoods", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "run_id"
    t.integer "variable_id"
    t.integer "input_id"
    t.decimal "loglikelihood", precision: 10
    t.decimal "n_eff", precision: 10
    t.decimal "weight", precision: 10
    t.decimal "residual", precision: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["input_id"], name: "index_likelihoods_on_input_id"
    t.index ["run_id"], name: "index_likelihoods_on_run_id"
    t.index ["variable_id"], name: "index_likelihoods_on_variable_id"
  end

  create_table "location_yields", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "yield", precision: 20, scale: 15
    t.string "species"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "county_id"
    t.index ["county_id"], name: "index_location_yields_on_county_id"
    t.index ["species", "county_id"], name: "index_location_yields_on_species_and_county_id"
    t.index ["species"], name: "index_location_yields_on_location_and_species"
    t.index ["yield"], name: "index_location_yields_on_yield"
  end

  create_table "machines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hostname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["hostname"], name: "index_machines_on_hostname"
  end

  create_table "managements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "citation_id"
    t.date "date"
    t.decimal "dateloc", precision: 4, scale: 2
    t.string "mgmttype"
    t.decimal "level", precision: 16, scale: 4
    t.string "units"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.index ["citation_id"], name: "index_managements_on_citation_id"
    t.index ["user_id"], name: "index_managements_on_user_id"
  end

  create_table "managements_treatments", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "treatment_id"
    t.integer "management_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["management_id", "treatment_id"], name: "index_managements_treatments_on_management_id_and_treatment_id", unique: true
  end

  create_table "methods", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.integer "citation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["citation_id"], name: "index_methods_on_citation_id"
  end

  create_table "mimetypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type_string"
  end

  create_table "pfts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.integer "parent_id"
  end

  create_table "pfts_priors", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "pft_id"
    t.integer "prior_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pfts_species", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "pft_id"
    t.integer "specie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["pft_id", "specie_id"], name: "index_pfts_species_on_pft_id_and_specie_id", unique: true
  end

  create_table "planting", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "treatment_id", limit: 1, null: false
    t.integer "management_id", limit: 1, null: false
    t.integer "mgmttype", limit: 1, null: false
    t.integer "date", limit: 1, null: false
    t.integer "level", limit: 1, null: false
    t.integer "units", limit: 1, null: false
  end

  create_table "posteriors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "pft_id"
    t.string "filename"
    t.integer "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id"], name: "index_posteriors_on_parent_id"
    t.index ["pft_id"], name: "index_posteriors_on_pft_id"
  end

  create_table "posteriors_runs", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "posterior_id"
    t.integer "run_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["posterior_id", "run_id"], name: "index_posteriors_runs_on_posterior_id_and_run_id", unique: true
  end

  create_table "priors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "citation_id"
    t.string "variable_id"
    t.string "phylogeny"
    t.string "distn"
    t.decimal "parama", precision: 16, scale: 4
    t.decimal "paramb", precision: 16, scale: 4
    t.decimal "paramc", precision: 16, scale: 4
    t.integer "n"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "category"
    t.integer "T_A"
    t.integer "T_E"
    t.integer "r"
    t.float "OM_ag", limit: 24
    t.float "OM_root", limit: 24
    t.float "OM_wood", limit: 24
    t.float "OM_litter", limit: 24
    t.float "OM_peat", limit: 24
    t.float "OM_SOM", limit: 24
    t.float "fc_ag_wood_litter", limit: 24
    t.float "fc_root", limit: 24
    t.float "fc_peat", limit: 24
    t.float "fc_SOM", limit: 24
    t.float "Ec_CO2", limit: 24
    t.float "Ec_CH4", limit: 24
    t.float "Ec_N2O", limit: 24
    t.float "k_ag_wood_litter", limit: 24
    t.float "k_root", limit: 24
    t.float "k_peat", limit: 24
    t.float "k_SOM", limit: 24
    t.integer "termite"
    t.float "Ed_CO2_ag_wood_litter", limit: 24
    t.float "Ed_CO2_root", limit: 24
    t.float "Ed_CO2_peat", limit: 24
    t.float "Ed_CO2_litter", limit: 24
    t.float "Ed_CH4_ag_wood_litter", limit: 24
    t.float "Ed_CH4_root", limit: 24
    t.float "Ed_CH4_peat", limit: 24
    t.float "Ed_CH4_litter", limit: 24
    t.float "Ed_N2O_ag_wood_litter", limit: 24
    t.float "Ed_N2O_root", limit: 24
    t.float "Ed_N2O_peat", limit: 24
    t.float "Ed_N2O_litter", limit: 24
    t.float "F_CO2", limit: 24
    t.float "F_CH4", limit: 24
    t.float "F_N2O", limit: 24
    t.integer "rd"
    t.integer "tR"
    t.float "FR_CO2", limit: 24
    t.float "FR_CH4", limit: 24
    t.float "FR_N2O", limit: 24
    t.float "dfc_ag_wood_litter", limit: 24
    t.float "dfc_root", limit: 24
    t.float "dfc_peat", limit: 24
    t.float "dk_ag_wood_litter", limit: 24
    t.float "dk_root", limit: 24
    t.float "dk_peat", limit: 24
    t.integer "age_transition"
    t.float "new_F_CO2", limit: 24
    t.float "new_F_CH4", limit: 24
    t.float "new_F_N2O", limit: 24
    t.float "F_anth", limit: 24
    t.index ["citation_id"], name: "index_priors_on_citation_id"
    t.index ["variable_id"], name: "index_priors_on_variable_id"
  end

  create_table "runs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "model_id"
    t.integer "site_id"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.string "outdir"
    t.string "outprefix"
    t.string "setting"
    t.text "parameter_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer "ensemble_id"
    t.string "start_date"
    t.string "end_date"
    t.index ["ensemble_id"], name: "index_runs_on_ensemble_id"
    t.index ["model_id"], name: "index_runs_on_model_id"
    t.index ["site_id"], name: "index_runs_on_site_id"
  end

  create_table "seeding", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "treatment_id", limit: 1, null: false
    t.integer "management_id", limit: 1, null: false
    t.integer "mgmttype", limit: 1, null: false
    t.integer "date", limit: 1, null: false
    t.integer "level", limit: 1, null: false
    t.integer "units", limit: 1, null: false
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "simulationmodels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "model_name"
    t.string "model_path"
    t.decimal "revision", precision: 10
    t.integer "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "model_type"
    t.integer "site_id"
    t.integer "model_id"
    t.string "hostname"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "params"
    t.index ["parent_id"], name: "index_models_on_parent_id"
  end

  create_table "sites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city"
    t.string "state"
    t.string "country"
    t.decimal "lat", precision: 9, scale: 6
    t.decimal "lon", precision: 9, scale: 6
    t.integer "mat"
    t.integer "map"
    t.integer "masl"
    t.string "soil"
    t.decimal "som", precision: 4, scale: 2
    t.text "notes"
    t.text "soilnotes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "sitename"
    t.boolean "greenhouse"
    t.integer "user_id"
    t.integer "local_time"
    t.decimal "sand_pct", precision: 9, scale: 5
    t.decimal "clay_pct", precision: 9, scale: 5
    t.string "espg"
    t.index ["user_id"], name: "index_sites_on_user_id"
  end

  create_table "species", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "spcd"
    t.string "genus"
    t.string "species"
    t.string "scientificname"
    t.string "commonname"
    t.string "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "AcceptedSymbol"
    t.string "SynonymSymbol"
    t.string "Symbol"
    t.text "PLANTS_Floristic_Area"
    t.text "State"
    t.string "Category"
    t.string "Family"
    t.string "FamilySymbol"
    t.string "FamilyCommonName"
    t.string "xOrder"
    t.string "SubClass"
    t.string "Class"
    t.string "SubDivision"
    t.string "Division"
    t.string "SuperDivision"
    t.string "SubKingdom"
    t.string "Kingdom"
    t.integer "ITIS_TSN"
    t.string "Duration"
    t.string "GrowthHabit"
    t.string "NativeStatus"
    t.string "NationalWetlandIndicatorStatus"
    t.string "RegionalWetlandIndicatorStatus"
    t.string "ActiveGrowthPeriod"
    t.string "AfterHarvestRegrowthRate"
    t.string "Bloat"
    t.string "C2N_Ratio"
    t.string "CoppicePotential"
    t.string "FallConspicuous"
    t.string "FireResistance"
    t.string "GrowthForm"
    t.string "GrowthRate"
    t.integer "MaxHeight20Yrs"
    t.integer "MatureHeight"
    t.string "KnownAllelopath"
    t.string "LeafRetention"
    t.string "Lifespan"
    t.string "LowGrowingGrass"
    t.string "NitrogenFixation"
    t.string "ResproutAbility"
    t.string "AdaptedCoarseSoils"
    t.string "AdaptedMediumSoils"
    t.string "AdaptedFineSoils"
    t.string "AnaerobicTolerance"
    t.string "CaCO3Tolerance"
    t.string "ColdStratification"
    t.string "DroughtTolerance"
    t.string "FertilityRequirement"
    t.string "FireTolerance"
    t.integer "MinFrostFreeDays"
    t.string "HedgeTolerance"
    t.string "MoistureUse"
    t.decimal "pH_Minimum", precision: 5, scale: 2
    t.decimal "pH_Maximum", precision: 5, scale: 2
    t.integer "Min_PlantingDensity"
    t.integer "Max_PlantingDensity"
    t.integer "Precipitation_Minimum"
    t.integer "Precipitation_Maximum"
    t.integer "RootDepthMinimum"
    t.string "SalinityTolerance"
    t.string "ShadeTolerance"
    t.integer "TemperatureMinimum"
    t.string "BloomPeriod"
    t.string "CommercialAvailability"
    t.string "FruitSeedPeriodBegin"
    t.string "FruitSeedPeriodEnd"
    t.string "Propogated_by_BareRoot"
    t.string "Propogated_by_Bulbs"
    t.string "Propogated_by_Container"
    t.string "Propogated_by_Corms"
    t.string "Propogated_by_Cuttings"
    t.string "Propogated_by_Seed"
    t.string "Propogated_by_Sod"
    t.string "Propogated_by_Sprigs"
    t.string "Propogated_by_Tubers"
    t.integer "Seeds_per_Pound"
    t.string "SeedSpreadRate"
    t.string "SeedlingVigor"
  end

  create_table "traits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id"
    t.integer "specie_id"
    t.integer "citation_id"
    t.integer "cultivar_id"
    t.integer "treatment_id"
    t.datetime "date"
    t.decimal "dateloc", precision: 4, scale: 2
    t.time "time"
    t.decimal "timeloc", precision: 4, scale: 2
    t.decimal "mean", precision: 16, scale: 4
    t.integer "n"
    t.string "statname"
    t.decimal "stat", precision: 16, scale: 4
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "variable_id"
    t.integer "user_id"
    t.integer "checked", default: 0
    t.integer "access_level"
    t.integer "entity_id"
    t.integer "method_id"
    t.integer "date_year"
    t.integer "date_month"
    t.integer "date_day"
    t.integer "time_hour"
    t.integer "time_minute"
    t.index ["citation_id"], name: "index_traits_on_citation_id"
    t.index ["cultivar_id"], name: "index_traits_on_cultivar_id"
    t.index ["entity_id"], name: "index_traits_on_entity_id"
    t.index ["method_id"], name: "index_traits_on_method_id"
    t.index ["site_id"], name: "index_traits_on_site_id"
    t.index ["specie_id"], name: "index_traits_on_specie_id"
    t.index ["treatment_id"], name: "index_traits_on_treatment_id"
    t.index ["user_id"], name: "index_traits_on_user_id"
    t.index ["variable_id"], name: "index_traits_on_variable_id"
  end

  create_table "treatments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "control"
    t.integer "user_id"
    t.index ["user_id"], name: "index_treatments_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "login", limit: 40
    t.string "name", limit: 100, default: ""
    t.string "email", limit: 100
    t.string "city"
    t.string "country"
    t.string "field"
    t.string "crypted_password", limit: 40
    t.string "salt", limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "remember_token", limit: 40
    t.datetime "remember_token_expires_at"
    t.integer "access_level"
    t.integer "page_access_level"
    t.string "apikey"
    t.string "state_prov"
    t.string "postal_code"
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  create_table "variables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description"
    t.string "units"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "max"
    t.string "min"
  end

  create_table "workflows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "folder"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "advanced_edit", default: false
    t.integer "site_id"
    t.integer "model_id", null: false
    t.string "hostname"
    t.string "params"
  end

  create_table "yields", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "citation_id"
    t.integer "site_id"
    t.integer "specie_id"
    t.integer "treatment_id"
    t.integer "cultivar_id"
    t.date "date"
    t.decimal "dateloc", precision: 4, scale: 2
    t.string "statname"
    t.decimal "stat", precision: 16, scale: 4
    t.decimal "mean", precision: 16, scale: 4
    t.integer "n"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.integer "checked", default: 0
    t.integer "access_level"
    t.integer "method_id"
    t.index ["citation_id"], name: "index_yields_on_citation_id"
    t.index ["cultivar_id"], name: "index_yields_on_cultivar_id"
    t.index ["method_id"], name: "index_yields_on_method_id"
    t.index ["site_id"], name: "index_yields_on_site_id"
    t.index ["specie_id"], name: "index_yields_on_specie_id"
    t.index ["treatment_id"], name: "index_yields_on_treatment_id"
    t.index ["user_id"], name: "index_yields_on_user_id"
  end

  create_table "yields_view", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "yield_id", limit: 1, null: false
    t.integer "citation_id", limit: 1, null: false
    t.integer "site_id", limit: 1, null: false
    t.integer "site", limit: 1, null: false
    t.integer "lat", limit: 1, null: false
    t.integer "lon", limit: 1, null: false
    t.integer "sp", limit: 1, null: false
    t.integer "author", limit: 1, null: false
    t.integer "cityear", limit: 1, null: false
    t.integer "trt", limit: 1, null: false
    t.integer "date", limit: 1, null: false
    t.integer "month", limit: 1, null: false
    t.integer "year", limit: 1, null: false
    t.integer "mean", limit: 1, null: false
    t.integer "n", limit: 1, null: false
    t.integer "statname", limit: 1, null: false
    t.integer "stat", limit: 1, null: false
    t.integer "notes", limit: 1, null: false
    t.integer "user", limit: 1, null: false
    t.integer "checked", limit: 1, null: false
    t.integer "access_level", limit: 1, null: false
    t.integer "user_id", limit: 1, null: false
  end

  create_table "yieldsview", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "yield_id", limit: 1, null: false
    t.integer "citation_id", limit: 1, null: false
    t.integer "site_id", limit: 1, null: false
    t.integer "site", limit: 1, null: false
    t.integer "lat", limit: 1, null: false
    t.integer "lon", limit: 1, null: false
    t.integer "sp", limit: 1, null: false
    t.integer "author", limit: 1, null: false
    t.integer "cityear", limit: 1, null: false
    t.integer "trt", limit: 1, null: false
    t.integer "date", limit: 1, null: false
    t.integer "month", limit: 1, null: false
    t.integer "year", limit: 1, null: false
    t.integer "mean", limit: 1, null: false
    t.integer "n", limit: 1, null: false
    t.integer "statname", limit: 1, null: false
    t.integer "stat", limit: 1, null: false
    t.integer "notes", limit: 1, null: false
    t.integer "user", limit: 1, null: false
    t.integer "checked", limit: 1, null: false
    t.integer "access_level", limit: 1, null: false
    t.integer "user_id", limit: 1, null: false
  end

end
