class AddXyZoomsToCb < ActiveRecord::Migration
  def self.up
#    execute "ALTER TABLE county_boundaries, add index `index_countyboundaries_on_zoom0x` (`zoom0x`), add index `index_countyboundaries_on_zoom1x` (`zoom1x`), add index `index_countyboundaries_on_zoom2x` (`zoom2x`), add index `index_countyboundaries_on_zoom3x` (`zoom3x`), add index `index_countyboundaries_on_zoom4x` (`zoom4x`), add index `index_countyboundaries_on_zoom5x` (`zoom5x`), add index `index_countyboundaries_on_zoom6x` (`zoom6x`), add index `index_countyboundaries_on_zoom7x` (`zoom7x`), add index `index_countyboundaries_on_zoom8x` (`zoom8x`), add index `index_countyboundaries_on_zoom9x` (`zoom9x`), add index `index_countyboundaries_on_zoom10x` (`zoom10x`), add index `index_countyboundaries_on_zoom11x` (`zoom11x`), add index `index_countyboundaries_on_zoom0y` (`zoom0y`), add index `index_countyboundaries_on_zoom1y` (`zoom1y`), add index `index_countyboundaries_on_zoom2y` (`zoom2y`), add index `index_countyboundaries_on_zoom3y` (`zoom3y`), add index `index_countyboundaries_on_zoom4y` (`zoom4y`), add index `index_countyboundaries_on_zoom5y` (`zoom5y`), add index `index_countyboundaries_on_zoom6y` (`zoom6y`), add index `index_countyboundaries_on_zoom7y` (`zoom7y`), add index `index_countyboundaries_on_zoom8y` (`zoom8y`), add index `index_countyboundaries_on_zoom9y` (`zoom9y`), add index `index_countyboundaries_on_zoom10y` (`zoom10y`), add index `index_countyboundaries_on_zoom11y` (`zoom11y`);"
#    add_index :county_boundaries, :zoom0x
#    add_index :county_boundaries, :zoom1x
#    add_index :county_boundaries, :zoom2x
#    add_index :county_boundaries, :zoom3x
#    add_index :county_boundaries, :zoom4x
#    add_index :county_boundaries, :zoom5x
#    add_index :county_boundaries, :zoom6x
#    add_index :county_boundaries, :zoom7x
#    add_index :county_boundaries, :zoom8x
#    add_index :county_boundaries, :zoom9x
#    add_index :county_boundaries, :zoom10x
#    add_index :county_boundaries, :zoom11x
#    add_index :county_boundaries, :zoom0y
#    add_index :county_boundaries, :zoom1y
#    add_index :county_boundaries, :zoom2y
#    add_index :county_boundaries, :zoom3y
#    add_index :county_boundaries, :zoom4y
#    add_index :county_boundaries, :zoom5y
#    add_index :county_boundaries, :zoom6y
#    add_index :county_boundaries, :zoom7y
#    add_index :county_boundaries, :zoom8y
#    add_index :county_boundaries, :zoom9y
#    add_index :county_boundaries, :zoom10y
#    add_index :county_boundaries, :zoom11y

  end

  def self.down
    remove_index :county_boundaries, :zoom0x
    remove_index :county_boundaries, :zoom1x
    remove_index :county_boundaries, :zoom2x
    remove_index :county_boundaries, :zoom3x
    remove_index :county_boundaries, :zoom4x
    remove_index :county_boundaries, :zoom5x
    remove_index :county_boundaries, :zoom6x
    remove_index :county_boundaries, :zoom7x
    remove_index :county_boundaries, :zoom8x
    remove_index :county_boundaries, :zoom9x
    remove_index :county_boundaries, :zoom10x
    remove_index :county_boundaries, :zoom11x
    remove_index :county_boundaries, :zoom0y
    remove_index :county_boundaries, :zoom1y
    remove_index :county_boundaries, :zoom2y
    remove_index :county_boundaries, :zoom3y
    remove_index :county_boundaries, :zoom4y
    remove_index :county_boundaries, :zoom5y
    remove_index :county_boundaries, :zoom6y
    remove_index :county_boundaries, :zoom7y
    remove_index :county_boundaries, :zoom8y
    remove_index :county_boundaries, :zoom9y
    remove_index :county_boundaries, :zoom10y
  end
end
