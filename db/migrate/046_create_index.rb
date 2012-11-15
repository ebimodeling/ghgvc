class CreateIndex < ActiveRecord::Migration
  def self.up
    add_index :cultivars, :specie_id
    add_index :covariates, [:trait_id, :variable_id]
    add_index :managements, :citation_id
    add_index :priors, :citation_id
    add_index :priors, :variable_id
    add_index :traits, :specie_id
    add_index :traits, :site_id
    add_index :traits, :citation_id
    add_index :traits, :cultivar_id
    add_index :traits, :treatment_id
    add_index :traits, :variable_id
    add_index :yields, :citation_id
    add_index :yields, :site_id
    add_index :yields, :specie_id
    add_index :yields, :treatment_id
    add_index :yields, :cultivar_id
  end

  def self.down
    remove_index :cultivars, :specie_id
    remove_index :cultivars, :specie_id
    remove_index :covariates, [:trait_id, :variable_id]
    remove_index :managements, :citation_id
    remove_index :priors, :citation_id
    remove_index :priors, :variable_id
    remove_index :traits, :specie_id
    remove_index :traits, :site_id
    remove_index :traits, :citation_id
    remove_index :traits, :cultivar_id
    remove_index :traits, :treatment_id
    remove_index :traits, :variable_id
    remove_index :yields, :citation_id
    remove_index :yields, :site_id
    remove_index :yields, :specie_id
    remove_index :yields, :treatment_id
    remove_index :yields, :cultivar_id
  end
end
