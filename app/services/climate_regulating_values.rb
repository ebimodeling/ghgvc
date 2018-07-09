require "rserve"

class ClimateRegulatingValues
  class << self
    def calculate(hash_data)
      # These get passed by the form and are unnecessary for R
      hash_data.delete(:controller)
      hash_data.delete(:action)

      connection = Rserve::Connection.new(hostname: ENV.fetch("CALC_HOST", "127.0.0.1"))

      connection.assign("data", hash_data.to_json)

      connection.eval("ghgvcr::calc_ghgv(data)").to_ruby
    end
  end
end
