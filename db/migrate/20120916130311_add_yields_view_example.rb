class AddYieldsViewExample < ActiveRecord::Migration
  def self.up
    execute <<-SQL
     create view yieldsview as select yields.id as yield_id, yields.citation_id, yields.site_id, sites.sitename as site, sites.lat as lat, sites.lon as lon, species.scientificname as sp, citations.author as author, citations.year as cityear, treatments.name as trt, date, month(date) as month, year(date) as year, mean, n, statname, stat, yields.notes, users.name as user, yields.checked as checked, yields.access_level as access_level, yields.user_id as user_id from yields join sites on yields.site_id = sites.id join species on yields.specie_id = species.id join citations on yields.citation_id = citations.id join treatments on yields.treatment_id = treatments.id join users on yields.user_id = users.id;
    SQL
  end

  def self.down
   execute <<-SQL
     drop view yieldsview;
   SQL
  end
end
