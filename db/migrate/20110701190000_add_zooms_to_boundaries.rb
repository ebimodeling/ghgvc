class AddZoomsToBoundaries < ActiveRecord::Migration
  def self.up
    add_column :county_boundaries, :zoom0x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom0y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom0skip, :bool
    add_column :county_boundaries, :zoom1x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom1y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom1skip, :bool
    add_column :county_boundaries, :zoom2x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom2y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom3x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom3y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom4x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom4y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom5x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom5y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom6x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom6y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom7x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom7y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom8x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom8y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom9x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom9y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom10x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom10y, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom11x, :decimal, :precision => 20, :scale => 10
    add_column :county_boundaries, :zoom11y, :decimal, :precision => 20, :scale => 10
    add_index :county_boundaries, [:zoom0x,:zoom0y,:zoom0skip]
    add_index :county_boundaries, [:zoom1x,:zoom1y,:zoom1skip]
    add_index :county_boundaries, [:zoom2x,:zoom2y]
    add_index :county_boundaries, [:zoom3x,:zoom3y]
    add_index :county_boundaries, [:zoom4x,:zoom4y]
    add_index :county_boundaries, [:zoom5x,:zoom5y]
    add_index :county_boundaries, [:zoom6x,:zoom6y]
    add_index :county_boundaries, [:zoom7x,:zoom7y]
    add_index :county_boundaries, [:zoom8x,:zoom8y]
    add_index :county_boundaries, [:zoom9x,:zoom9y]
    add_index :county_boundaries, [:zoom10x,:zoom10y]
    add_index :county_boundaries, [:zoom11x,:zoom11y]
  end

  def self.down
    remove_column :county_boundaries, :zoom0x
    remove_column :county_boundaries, :zoom0y
    remove_column :county_boundaries, :zoom0skip
    remove_column :county_boundaries, :zoom1x
    remove_column :county_boundaries, :zoom1y
    remove_column :county_boundaries, :zoom1skip
    remove_column :county_boundaries, :zoom2x
    remove_column :county_boundaries, :zoom2y
    remove_column :county_boundaries, :zoom3x
    remove_column :county_boundaries, :zoom3y
    remove_column :county_boundaries, :zoom4x
    remove_column :county_boundaries, :zoom4y
    remove_column :county_boundaries, :zoom5x
    remove_column :county_boundaries, :zoom5y
    remove_column :county_boundaries, :zoom6x
    remove_column :county_boundaries, :zoom6y
    remove_column :county_boundaries, :zoom7x
    remove_column :county_boundaries, :zoom7y
    remove_column :county_boundaries, :zoom8x
    remove_column :county_boundaries, :zoom8y
    remove_column :county_boundaries, :zoom9x
    remove_column :county_boundaries, :zoom9y
    remove_column :county_boundaries, :zoom10x
    remove_column :county_boundaries, :zoom10y
    remove_column :county_boundaries, :zoom11x
    remove_column :county_boundaries, :zoom11y
    remove_index :county_boundaries, [:zoom0x,:zoom0y,:zoom0skip]
    remove_index :county_boundaries, [:zoom1x,:zoom1y,:zoom1skip]
    remove_index :county_boundaries, [:zoom2x,:zoom2y]
    remove_index :county_boundaries, [:zoom3x,:zoom3y]
    remove_index :county_boundaries, [:zoom4x,:zoom4y]
    remove_index :county_boundaries, [:zoom5x,:zoom5y]
    remove_index :county_boundaries, [:zoom6x,:zoom6y]
    remove_index :county_boundaries, [:zoom7x,:zoom7y]
    remove_index :county_boundaries, [:zoom8x,:zoom8y]
    remove_index :county_boundaries, [:zoom9x,:zoom9y]
    remove_index :county_boundaries, [:zoom10x,:zoom10y]
    remove_index :county_boundaries, [:zoom11x,:zoom11y]
  end
end
