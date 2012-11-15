class AddToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :AcceptedSymbol, :string
    add_column :species, :SynonymSymbol, :string
#    add_column :species, :ScientificName, :string
    add_column :species, :Symbol, :string
#    add_column :species, :CommonName, :string
    add_column :species, :PLANTS_Floristic_Area, :text
    add_column :species, :State, :text
    add_column :species, :Category, :string
#    add_column :species, :Genus, :string
    add_column :species, :Family, :string
    add_column :species, :FamilySymbol, :string
    add_column :species, :FamilyCommonName, :string
    add_column :species, :xOrder, :string
    add_column :species, :SubClass, :string
    add_column :species, :Class, :string
    add_column :species, :SubDivision, :string
    add_column :species, :Division, :string
    add_column :species, :SuperDivision, :string
    add_column :species, :SubKingdom, :string
    add_column :species, :Kingdom, :string
    add_column :species, :ITIS_TSN, :integer
    add_column :species, :Duration, :string
    add_column :species, :GrowthHabit, :string
    add_column :species, :NativeStatus, :string
    add_column :species, :FederalNoxiousStatus, :string
    add_column :species, :FederalNoxiousCommonName, :string
    add_column :species, :StateNoxiousStatus, :text
    add_column :species, :StateNoxiousCommonName, :text
    add_column :species, :Invasive, :string
    add_column :species, :Federal_TE_Status, :string
    add_column :species, :State_TE_Status, :string
    add_column :species, :State_TE_Common_Name, :text
    add_column :species, :NationalWetlandIndicatorStatus, :string
    add_column :species, :RegionalWetlandIndicatorStatus, :string
    add_column :species, :ActiveGrowthPeriod, :string
    add_column :species, :AfterHarvestRegrowthRate, :string
    add_column :species, :Bloat, :string
    add_column :species, :C2N_Ratio, :string
    add_column :species, :CoppicePotential, :string
    add_column :species, :FallConspicuous, :string
    add_column :species, :FireResistance, :string
    add_column :species, :FlowerColor, :string
    add_column :species, :FlowerConspicuous, :string
    add_column :species, :FoliageColor, :string
    add_column :species, :FoliagePorositySummer, :string
    add_column :species, :FoliagePorosityWinter, :string
    add_column :species, :FoliageTexture, :string
    add_column :species, :FruitColor, :string
    add_column :species, :FruitConspicuous, :string
    add_column :species, :GrowthForm, :string
    add_column :species, :GrowthRate, :string
    add_column :species, :MaxHeight20Yrs, :integer
    add_column :species, :MatureHeight, :integer
    add_column :species, :KnownAllelopath, :string
    add_column :species, :LeafRetention, :string
    add_column :species, :Lifespan, :string
    add_column :species, :LowGrowingGrass, :string
    add_column :species, :NitrogenFixation, :string
    add_column :species, :ResproutAbility, :string
    add_column :species, :Shape_and_Orientation, :string
    add_column :species, :Toxicity, :string
    add_column :species, :AdaptedCoarseSoils, :string
    add_column :species, :AdaptedMediumSoils, :string
    add_column :species, :AdaptedFineSoils, :string
    add_column :species, :AnaerobicTolerance, :string
    add_column :species, :CaCO3Tolerance, :string
    add_column :species, :ColdStratification, :string
    add_column :species, :DroughtTolerance, :string
    add_column :species, :FertilityRequirement, :string
    add_column :species, :FireTolerance, :string
    add_column :species, :MinFrostFreeDays, :integer
    add_column :species, :HedgeTolerance, :string
    add_column :species, :MoistureUse, :string
    add_column :species, :pH_Minimum, :decimal
    add_column :species, :pH_Maximum, :decimal
    add_column :species, :Min_PlantingDensity, :integer
    add_column :species, :Max_PlantingDensity, :integer
    add_column :species, :Precipitation_Minimum, :integer
    add_column :species, :Precipitation_Maximum, :integer
    add_column :species, :RootDepthMinimum, :integer
    add_column :species, :SalinityTolerance, :string
    add_column :species, :ShadeTolerance, :string
    add_column :species, :TemperatureMinimum, :integer
    add_column :species, :BloomPeriod, :string
    add_column :species, :CommercialAvailability, :string
    add_column :species, :FruitSeedAbundance, :string
    add_column :species, :FruitSeedPeriodBegin, :string
    add_column :species, :FruitSeedPeriodEnd, :string
    add_column :species, :FruitSeedPersistence, :string
    add_column :species, :Propogated_by_BareRoot, :string
    add_column :species, :Propogated_by_Bulbs, :string
    add_column :species, :Propogated_by_Container, :string
    add_column :species, :Propogated_by_Corms, :string
    add_column :species, :Propogated_by_Cuttings, :string
    add_column :species, :Propogated_by_Seed, :string
    add_column :species, :Propogated_by_Sod, :string
    add_column :species, :Propogated_by_Sprigs, :string
    add_column :species, :Propogated_by_Tubers, :string
    add_column :species, :Seeds_per_Pound, :integer
    add_column :species, :SeedSpreadRate, :string
    add_column :species, :SeedlingVigor, :string
    add_column :species, :SmallGrain, :string
    add_column :species, :VegetativeSpreadRate, :string
    add_column :species, :Berry_Nut_Seed_Product, :string
    add_column :species, :ChristmasTreeProduct, :string
    add_column :species, :FodderProduct, :string
    add_column :species, :FuelwoodProduct, :string
    add_column :species, :LumberProduct, :string
    add_column :species, :NavalStoreProduct, :string
    add_column :species, :NurseryStockProduct, :string
    add_column :species, :PalatableBrowseAnimal, :string
    add_column :species, :PalatableGrazeAnimal, :string
    add_column :species, :PalatableHuman, :string
    add_column :species, :PostProduct, :string
    add_column :species, :ProteinPotential, :string
    add_column :species, :PulpwoodProduct, :string
    add_column :species, :VeneerProduct, :string
  end

  def self.down
    remove_column :species, :AcceptedSymbol
    remove_column :species, :SynonymSymbol
#    remove_column :species, :ScientificName
    remove_column :species, :Symbol
#    remove_column :species, :CommonName
    remove_column :species, :PLANTS_Floristic_Area
    remove_column :species, :State
    remove_column :species, :Category
#    remove_column :species, :Genus
    remove_column :species, :Family
    remove_column :species, :FamilySymbol
    remove_column :species, :FamilyCommonName
    remove_column :species, :xOrder
    remove_column :species, :SubClass
    remove_column :species, :Class
    remove_column :species, :SubDivision
    remove_column :species, :Division
    remove_column :species, :SuperDivision
    remove_column :species, :SubKingdom
    remove_column :species, :Kingdom
    remove_column :species, :ITIS_TSN
    remove_column :species, :Duration
    remove_column :species, :GrowthHabit
    remove_column :species, :NativeStatus
    remove_column :species, :FederalNoxiousStatus
    remove_column :species, :FederalNoxiousCommonName
    remove_column :species, :StateNoxiousStatus
    remove_column :species, :StateNoxiousCommonName
    remove_column :species, :Invasive
    remove_column :species, :Federal_TE_Status
    remove_column :species, :State_TE_Status
    remove_column :species, :State_TE_Common_Name
    remove_column :species, :NationalWetlandIndicatorStatus
    remove_column :species, :RegionalWetlandIndicatorStatus
    remove_column :species, :ActiveGrowthPeriod
    remove_column :species, :AfterHarvestRegrowthRate
    remove_column :species, :Bloat
    remove_column :species, :C2N_Ratio
    remove_column :species, :CoppicePotential
    remove_column :species, :FallConspicuous
    remove_column :species, :FireResistance
    remove_column :species, :FlowerColor
    remove_column :species, :FlowerConspicuous
    remove_column :species, :FoliageColor
    remove_column :species, :FoliagePorositySummer
    remove_column :species, :FoliagePorosityWinter
    remove_column :species, :FoliageTexture
    remove_column :species, :FruitColor
    remove_column :species, :FruitConspicuous
    remove_column :species, :GrowthForm
    remove_column :species, :GrowthRate
    remove_column :species, :MaxHeight20Yrs
    remove_column :species, :MatureHeight
    remove_column :species, :KnownAllelopath
    remove_column :species, :LeafRetention
    remove_column :species, :Lifespan
    remove_column :species, :LowGrowingGrass
    remove_column :species, :NitrogenFixation
    remove_column :species, :ResproutAbility
    remove_column :species, :Shape_and_Orientation
    remove_column :species, :Toxicity
    remove_column :species, :AdaptedCoarseSoils
    remove_column :species, :AdaptedMediumSoils
    remove_column :species, :AdaptedFineSoils
    remove_column :species, :AnaerobicTolerance
    remove_column :species, :CaCO3Tolerance
    remove_column :species, :ColdStratification
    remove_column :species, :DroughtTolerance
    remove_column :species, :FertilityRequirement
    remove_column :species, :FireTolerance
    remove_column :species, :MinFrostFreeDays
    remove_column :species, :HedgeTolerance
    remove_column :species, :MoistureUse
    remove_column :species, :pH_Minimum
    remove_column :species, :pH_Maximum
    remove_column :species, :Min_PlantingDensity
    remove_column :species, :Max_PlantingDensity
    remove_column :species, :Precipitation_Minimum
    remove_column :species, :Precipitation_Maximum
    remove_column :species, :RootDepthMinimum
    remove_column :species, :SalinityTolerance
    remove_column :species, :ShadeTolerance
    remove_column :species, :TemperatureMinimum
    remove_column :species, :BloomPeriod
    remove_column :species, :CommercialAvailability
    remove_column :species, :FruitSeedAbundance
    remove_column :species, :FruitSeedPeriodBegin
    remove_column :species, :FruitSeedPeriodEnd
    remove_column :species, :FruitSeedPersistence
    remove_column :species, :Propogated_by_BareRoot
    remove_column :species, :Propogated_by_Bulbs
    remove_column :species, :Propogated_by_Container
    remove_column :species, :Propogated_by_Corms
    remove_column :species, :Propogated_by_Cuttings
    remove_column :species, :Propogated_by_Seed
    remove_column :species, :Propogated_by_Sod
    remove_column :species, :Propogated_by_Sprigs
    remove_column :species, :Propogated_by_Tubers
    remove_column :species, :Seeds_per_Pound
    remove_column :species, :SeedSpreadRate
    remove_column :species, :SeedlingVigor
    remove_column :species, :SmallGrain
    remove_column :species, :VegetativeSpreadRate
    remove_column :species, :Berry_Nut_Seed_Product
    remove_column :species, :ChristmasTreeProduct
    remove_column :species, :FodderProduct
    remove_column :species, :FuelwoodProduct
    remove_column :species, :LumberProduct
    remove_column :species, :NavalStoreProduct
    remove_column :species, :NurseryStockProduct
    remove_column :species, :PalatableBrowseAnimal
    remove_column :species, :PalatableGrazeAnimal
    remove_column :species, :PalatableHuman
    remove_column :species, :PostProduct
    remove_column :species, :ProteinPotential
    remove_column :species, :PulpwoodProduct
    remove_column :species, :VeneerProduct
  end
end
