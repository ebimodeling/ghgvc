# TODO: Do this better. This might belong in a database or maybe it can
# stay as a file. This is a quick & dirty abstraction that should allow
# for easier refactoring latera
#
# Also need to fix formatting
module DefaultEcosystems
  class << self
  def call
    JSON.parse [
     {
        "name":"tropical peat forest",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":444,
        "OM_root":108,
        "OM_wood":0,
        "OM_litter":0,
        "OM_peat":1388.889,
        "OM_SOM":88.96552,
        "fc_ag_wood_litter":0.5,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":35.909,
        "Ec_CH4":0.07,
        "Ec_N2O":0.0059,
        "k_ag_wood_litter":0.167,
        "k_root":0.04,
        "k_peat":0.02,
        "k_SOM":0.4,
        "termite":3,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0.0275,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0.013645,
        "Ed_N2O_litter":0,
        "F_CO2":-443.333,
        "F_CH4":9.877813,
        "F_N2O":0.017103,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":0.5,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.167,
        "dk_root":0.02,
        "dk_peat":0.02,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"tropical forest",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":248,
        "OM_root":51.2,
        "OM_wood":20,
        "OM_litter":10,
        "OM_peat":0,
        "OM_SOM":88.965517,
        "fc_ag_wood_litter":0.52,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":35.909,
        "Ec_CH4":0.294,
        "Ec_N2O":0.0059,
        "k_ag_wood_litter":0.167,
        "k_root":0.04,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":3,
        "Ed_CO2_ag_wood_litter":41.666667,
        "Ed_CO2_root":41.666667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0.0275,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-150.5667,
        "F_CH4":-0.225844,
        "F_N2O":0.0816074,
        "rd":0,
        "tR":23,
        "FR_CO2":-127.3521,
        "FR_CH4":-0.225844,
        "FR_N2O":0.0309627,
        "dfc_ag_wood_litter":0.36,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.167,
        "dk_root":0.04,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"northern peatland",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":100,
        "OM_root":17.6,
        "OM_wood":3.2,
        "OM_litter":0,
        "OM_peat":944.4444,
        "OM_SOM":110.6897,
        "fc_ag_wood_litter":0.5,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":35.65909,
        "Ec_CH4":0.07,
        "Ec_N2O":0.005909,
        "k_ag_wood_litter":0.04,
        "k_root":0.4,
        "k_peat":0.02,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0.013645,
        "Ed_N2O_litter":0,
        "F_CO2":-21.8333,
        "F_CH4":9.877813,
        "F_N2O":0.008551,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":0.5,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.04,
        "dk_root":0.4,
        "dk_peat":0.02,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"marsh & swamp",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":150,
        "OM_root":19.4,
        "OM_wood":0,
        "OM_litter":17.22222,
        "OM_peat":0,
        "OM_SOM":105.1724,
        "fc_ag_wood_litter":0.7,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":36.36364,
        "Ec_CH4":0.109091,
        "Ec_N2O":0.008727,
        "k_ag_wood_litter":0.59,
        "k_root":0.59,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.333333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-50.4167,
        "F_CH4":16.425,
        "F_N2O":0.065415,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":0.7,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.59,
        "dk_root":0.59,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"temperate forest",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":404,
        "OM_root":94,
        "OM_wood":102,
        "OM_litter":51.35135,
        "OM_peat":0,
        "OM_SOM":82.75862,
        "fc_ag_wood_litter":0.51,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":35.65909,
        "Ec_CH4":0.29375,
        "Ec_N2O":0.005909,
        "k_ag_wood_litter":0.036875,
        "k_root":0.02,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":3,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-168.333,
        "F_CH4":-0.22584,
        "F_N2O":0.025755,
        "rd":0,
        "tR":75,
        "FR_CO2":-40.8523,
        "FR_CH4":-0.22584,
        "FR_N2O":0.025755,
        "dfc_ag_wood_litter":0.43,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.04,
        "dk_root":0.02,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"aggrading temperate non-forest",
        "category":"aggrading",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":0,
        "OM_root":1.6,
        "OM_wood":0,
        "OM_litter":1.081081,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0.8,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.0015909,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.333333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-131.667,
        "F_CH4":-0.18934,
        "F_N2O":0.029274,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":10,
        "new_F_CO2":-9.17036,
        "new_F_CH4":-0.14828,
        "new_F_N2O":0.012038,
        "F_anth":0
     },
     {
        "name":"boreal forest",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":152,
        "OM_root":36,
        "OM_wood":5.8,
        "OM_litter":59.45946,
        "OM_peat":0,
        "OM_SOM":48.27586,
        "fc_ag_wood_litter":0.59,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":35.65909,
        "Ec_CH4":0.29375,
        "Ec_N2O":0.005909,
        "k_ag_wood_litter":0.04,
        "k_root":0.02,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-33.9333,
        "F_CH4":-0.22584,
        "F_N2O":0.025755,
        "rd":0,
        "tR":75,
        "FR_CO2":-40.8523,
        "FR_CH4":-0.22584,
        "FR_N2O":0.025755,
        "dfc_ag_wood_litter":0.43,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.04,
        "dk_root":0.02,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"aggrading tropical non-forest",
        "category":"aggrading",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":0,
        "OM_root":1.6,
        "OM_wood":0,
        "OM_litter":1.081081,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0.8,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":2.33,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-127.689,
        "F_CH4":-0.18934,
        "F_N2O":0.012286,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":75,
        "new_F_CO2":-22.6299,
        "new_F_CH4":-0.18934,
        "new_F_N2O":0.029274,
        "F_anth":0
     },
     {
        "name":"aggrading boreal forest",
        "category":"aggrading",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":0,
        "OM_root":1.6,
        "OM_wood":0,
        "OM_litter":1.081081,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0.8,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-149.792,
        "F_CH4":-0.22584,
        "F_N2O":0.025755,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":75,
        "new_F_CO2":-9.25455,
        "new_F_CH4":-0.22584,
        "new_F_N2O":0.025755,
        "F_anth":0
     },
     {
        "name":"switchgrass",
        "category":"biofuels",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":5.36,
        "OM_root":12.9,
        "OM_wood":0,
        "OM_litter":10.5,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-0.56667,
        "F_CH4":-0.12547,
        "F_N2O":0.045302,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":14.71212
     },
     {
        "name":"temperate grassland",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":2.4,
        "OM_root":14,
        "OM_wood":0,
        "OM_litter":5.405405,
        "OM_peat":0,
        "OM_SOM":60.34483,
        "fc_ag_wood_litter":0.83,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":36.65909,
        "Ec_CH4":0.14375,
        "Ec_N2O":0.004773,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-33.6246,
        "F_CH4":-0.14828,
        "F_N2O":0.012038,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":0.83,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"aggrading tropical forest",
        "category":"aggrading",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":0,
        "OM_root":1.6,
        "OM_wood":0,
        "OM_litter":1.081081,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0.8,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-466.9579,
        "F_CH4":-0.225844,
        "F_N2O":0.030963,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":2.33,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":23,
        "new_F_CO2":-41.06364,
        "new_F_CH4":-0.225844,
        "new_F_N2O":0.081607,
        "F_anth":0
     },
     {
        "name":"temperate scrub/woodland",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":48,
        "OM_root":48,
        "OM_wood":0,
        "OM_litter":5.945946,
        "OM_peat":0,
        "OM_SOM":46.55172,
        "fc_ag_wood_litter":0.75,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":36.65909,
        "Ec_CH4":0.14375,
        "Ec_N2O":0.004773,
        "k_ag_wood_litter":0.132,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-141.319,
        "F_CH4":-0.18934,
        "F_N2O":0.012534,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":0.75,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.132,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"tropical savanna",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":21.2,
        "OM_root":38,
        "OM_wood":0,
        "OM_litter":14.0540541,
        "OM_peat":0,
        "OM_SOM":68.9655172,
        "fc_ag_wood_litter":0.75,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":36.6590909,
        "Ec_CH4":0.14375,
        "Ec_N2O":0.004773,
        "k_ag_wood_litter":0.197,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":3,
        "Ed_CO2_ag_wood_litter":41.666667,
        "Ed_CO2_root":41.666667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.333333,
        "Ed_CH4_ag_wood_litter":0.0275,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-82.9761905,
        "F_CH4":-0.18934375,
        "F_N2O":0.02927426,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":0.75,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.197,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"desert",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":7,
        "OM_root":18,
        "OM_wood":0,
        "OM_litter":0.27027,
        "OM_peat":0,
        "OM_SOM":32.75862,
        "fc_ag_wood_litter":0.75,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":36.65909,
        "Ec_CH4":0.14375,
        "Ec_N2O":0.004773,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-10.6944,
        "F_CH4":-0.18934,
        "F_N2O":0.005357,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":0.75,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"tundra",
        "category":"native",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":12.4,
        "OM_root":22,
        "OM_wood":0,
        "OM_litter":120,
        "OM_peat":0,
        "OM_SOM":74.13793,
        "fc_ag_wood_litter":0.5,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":36.65909,
        "Ec_CH4":0.14375,
        "Ec_N2O":0.004773,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-26.0417,
        "F_CH4":-0.18934,
        "F_N2O":0.012038,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":0.5,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"tropical pasture",
        "category":"agroecosystem",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":3.6,
        "OM_root":15.2,
        "OM_wood":0,
        "OM_litter":0,
        "OM_peat":0,
        "OM_SOM":68.96552,
        "fc_ag_wood_litter":0.83,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":36.65909,
        "Ec_CH4":0.14375,
        "Ec_N2O":0.004773,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":3,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0.0275,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-35,
        "F_CH4":3.664219,
        "F_N2O":0.067387,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"temperate pasture",
        "category":"agroecosystem",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":2.4,
        "OM_root":14,
        "OM_wood":0,
        "OM_litter":5.405405,
        "OM_peat":0,
        "OM_SOM":60.34483,
        "fc_ag_wood_litter":0.83,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":36.65909,
        "Ec_CH4":0.14375,
        "Ec_N2O":0.004773,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":5.470516,
        "F_CH4":0.29773,
        "F_N2O":0.134268,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":0
     },
     {
        "name":"tropical cropland",
        "category":"agroecosystem",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":10,
        "OM_root":1.6,
        "OM_wood":0,
        "OM_litter":1.081081,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0.8,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.4182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":0,
        "F_CH4":-0.12547,
        "F_N2O":0.152066,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":35.68182
     },
     {
        "name":"temperate cropland",
        "category":"agroecosystem",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":10,
        "OM_root":1.6,
        "OM_wood":0,
        "OM_litter":1.081081,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0.8,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":0,
        "F_CH4":-0.12547,
        "F_N2O":0.151424,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":15
     },
     {
        "name":"wetland rice",
        "category":"agroecosystem",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":10,
        "OM_root":1.9,
        "OM_wood":0,
        "OM_litter":5.945946,
        "OM_peat":0,
        "OM_SOM":106.8966,
        "fc_ag_wood_litter":0.8,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.59,
        "k_root":0.59,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":0,
        "F_CH4":22.8125,
        "F_N2O":0.096883,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.59,
        "dk_root":0.59,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":14.09091
     },
     {
        "name":"miscanthus",
        "category":"biofuels",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":17.6,
        "OM_root":19.75,
        "OM_wood":0,
        "OM_litter":8,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-0.84167,
        "F_CH4":-0.12547,
        "F_N2O":0.008491,
        "rd":-9999,
        "tR":-9999,
        "FR_CO2":0,
        "FR_CH4":0,
        "FR_N2O":0.4,
        "dfc_ag_wood_litter":0.4,
        "dfc_root":0,
        "dfc_peat":-9999,
        "dk_ag_wood_litter":-9999,
        "dk_root":-9999,
        "dk_peat":-9999,
        "age_transition":0,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":7.143939
     },
     {
        "name":"aggrading temperate forest",
        "category":"aggrading",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":0,
        "OM_root":1.6,
        "OM_wood":0,
        "OM_litter":1.081081,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0.8,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":-199.35,
        "F_CH4":-0.225844,
        "F_N2O":0.025755,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":72,
        "new_F_CO2":-45.9091,
        "new_F_CH4":-0.22584,
        "new_F_N2O":0.025755,
        "F_anth":0
     },
     {
        "name":"US corn",
        "category":"biofuels",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":4.2,
        "OM_root":3.4,
        "OM_wood":0,
        "OM_litter":2,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":0,
        "F_CH4":-0.12547,
        "F_N2O":0.16495,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":19
     },
     {
        "name":"US soy",
        "category":"biofuels",
        "T_A":100,
        "T_E":50,
        "r":0,
        "OM_ag":1.2,
        "OM_root":2.4,
        "OM_wood":0,
        "OM_litter":2.8,
        "OM_peat":0,
        "OM_SOM":0,
        "fc_ag_wood_litter":0,
        "fc_root":0,
        "fc_peat":0,
        "fc_SOM":0,
        "Ec_CO2":34.43182,
        "Ec_CH4":0.16875,
        "Ec_N2O":0.001591,
        "k_ag_wood_litter":0.4,
        "k_root":0.4,
        "k_peat":0,
        "k_SOM":0.4,
        "termite":0,
        "Ed_CO2_ag_wood_litter":41.66667,
        "Ed_CO2_root":41.66667,
        "Ed_CO2_peat":45,
        "Ed_CO2_litter":48.33333,
        "Ed_CH4_ag_wood_litter":0,
        "Ed_CH4_root":0,
        "Ed_CH4_peat":0,
        "Ed_CH4_litter":0,
        "Ed_N2O_ag_wood_litter":0,
        "Ed_N2O_root":0,
        "Ed_N2O_peat":0,
        "Ed_N2O_litter":0,
        "F_CO2":0,
        "F_CH4":-0.12547,
        "F_N2O":0.0967,
        "rd":0,
        "tR":-9999,
        "FR_CO2":-9999,
        "FR_CH4":-9999,
        "FR_N2O":-9999,
        "dfc_ag_wood_litter":-9999,
        "dfc_root":0,
        "dfc_peat":0,
        "dk_ag_wood_litter":0.4,
        "dk_root":0.4,
        "dk_peat":0,
        "age_transition":-9999,
        "new_F_CO2":-9999,
        "new_F_CH4":-9999,
        "new_F_N2O":-9999,
        "F_anth":8.916667
        }
      ].to_json
  end
end
end