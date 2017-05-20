require 'rserve'

class ClimateRegulatingValues
  def self.calculate(biomes)
    connection = Rserve::Connection.new
    connection.assign("biomes", biomes.to_json)
    response = connection.eval("ghgvcr::calc_ghgv(biomes)").to_ruby
  end
end
