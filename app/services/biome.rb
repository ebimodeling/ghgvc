require "json"
require "rserve"

class Biome
  def self.list(latitude, longitude)
    connection = Rserve::Connection.new(hostname: ENV.fetch("CALC_HOST", "127.0.0.1"))

    connection.assign("latitude", latitude.to_f)
    connection.assign("longitude", longitude.to_f)

    response = connection.eval("ghgvcr::get_biome(latitude, longitude)")

    JSON.parse(response.to_ruby)
  end
end
