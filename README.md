

# Ecosystem Climate Regulation Services Calculator

This is the source code repository for the Ecosystem Climate Regulation
Services Calculator. Contributions, comments, bug reports, and
feature requests are welcome!

# Setup & Installation

This project uses Docker to manage dependencies.

1. Install [Docker Community Edition](https://store.docker.com/search?offering=community&type=edition) for your OS

2. Clone the rails application:

    git clone git@github.com:rubyforgood/ghgvc.git --depth 1 && cd ghgvc

# Building & running the application

Ensure Docker is running, the ghgvc app is cloned, and you've navigated to your ghgvc repo.

1. Build Docker:

    docker-compose build

2. Download the required netcdf files

    docker-compose run --rm ghgvcr ./download-netcdf.sh

    > This stores the netcdf data in a volume that will persist across containers

3. Bundle install:

    docker-compose run --rm app bundle

    > This stores the downloaded gems in a volume that will persist across containers

4. Run the application:

    docker-compose up app

5. Navigate to http://localhost:3000/ in your web browser.

  *  If clicking on the map does not return ecosystems, ensure that data was downloaded:

  ```
docker-compose run --rm ghgvcr bash
cd data
ls
```
  * This should show a file `name_indexed_ecosystems.json`, and two directories: `maps` and `netcdf`. If it is empty, try:
  ```
  docker-compose down # stop everything
  docker-compose up get_data # should re-download & un-zip the data
  ```
  * If there is still an issue, try:
  ```
  docker-compose down # stop everything
  docker-compose volume rm ghgvc_netcdf-data # removes the volume
  docker-compose up get_data # should re-download & un-zip the data
  ```
  * `ghgvc_netcdf-data` name should be the name of the volume. If that command fails, try `docker volume ls` and look for one that matches on the netcdf-data
   * If all of the above fails (if you can't force it to stop with docker-compose or docker commands), try restarting either docker or your machine (sometimes both; it usually means the container was put into a state that it shouldn't be).

# Development & Test

* Enter the Rails console:
```
docker-compose run --rm app bin/rails c
```
* Run all tests:
```
docker-compose run --rm app rspec
```
* Run a singular test:
```
docker-compose run --rm app rspec spec/<test file path>
```

# About the Ecosystem Climate Regulation Services Calculator

Ecosystems regulate climate through both greenhouse-gas exchange with
the atmosphere (biogeochemical mechanisms) and regulation of land
surface energy and water balances (biophysical mechanisms). The exchange
of carbon dioxide (CO~2~) and other greenhouse gases (N~2~O, CH~4~)
between ecosystems and the atmosphere influences climate. For example,
forests remove CO~2~ from the atmosphere as they grow, croplands release
the potent greenhouse gas N~2~O as a byproduct of fertilization, and
deforestation releases large amounts of CO~2~ and other greenhouse
gasses to the atmosphere. Beyond this, ecosystems also influence climate
through absorption of incoming solar radiation (dependent upon their
reflectivity, or *albedo*) and the transfer of heat by evaporation
(latent heat flux-a process analogous to sweating). Efforts aimed at
climate change mitigation through land management quantify greenhouse
gas exchange, but do not account for the biophysical exchanges, which in
some cases can be quite significant.

Recently, researchers proposed an integrated index of the climate
regulation value (CRV) of terrestrial ecosystems (Anderson-Teixeira *et
al.*, 2012a; Hungate & Hampton, 2012), which combines a previous metric
of the greenhouse gas value of ecosystems (GHGV; Anderson-Teixeira &
DeLucia, 2011) with biophysical climate regulation services to show the
climate regulation services of ecosystems in CO~2~ equivalents - a
common currency for carbon accounting. This is the most comprehensive
existing metric of ecosystem climate regulation services, and it sets
the stage for thorough accounting of climate regulation services in
initiatives aimed at climate protection through land management
(Anderson-Teixeira *et al.*, 2011; Hungate & Hampton, 2012).

The CRV calculator is a publically available web-based tool for
estimating *CRV* (or *GHGV*) for ecosystems globally. It uses global
maps of climatically significant ecosystem properties (for example,
biomass, soil carbon, biophysical services) to provide location-specific
CRV estimates.

# Applications

The Ecosystem Climate Regulation Services Calculator has potential
applications in a variety of fields. Below are some examples.

## Conservation

This calculator can be used to determine which areas of potential
conservation interest are the most beneficial in terms of their net
effect on the climate. This information can then be used to help make
land conservation decisions and inform the general public about the
climate benefits of conserving lands.

## Sustainability Science

The calculator can be used to evaluate the climate consequences of
various land use decisions. For instance, the calculator can be used to
evaluate the impacts of various bioenergy production strategies
(Anderson-Teixeira *et al.*, 2012b; Buckeridge *et al.*, 2012). It could
also be used in determining the value of land when designing
infrastructure projects, such as dams or highways.

## Education

The calculator can be used to educate students or the general public
about the climate regulation services of ecosystems around the globe.
For example, by using the calculator to research ecosystems in areas
where land use change is occurring, students will gain a greater
understanding of the issues surrounding land use and conservation
decisions. They can also use the calculator to learn more about the
local ecosystems with which they are familiar.

## Business

Increasing public interest in sustainable business practices creates a
need for conscientious businesses to evaluate the climate impact of
business decisions, including those that affect land use patterns. For
example, the calculator might be used to evaluate the climate impacts of
land use change related to bioenergy production.

## Policy

Policy decisions regarding the conservation of domestic lands or those
affecting international land use patterns can benefit from the most
complete information possible regarding the impact of those decisions on
climate. Policies aimed at climate protection through land management,
including REDD+ and bioenergy sustainability standards, account for
greenhouse gasses but not for biophysical processes that can sometimes
outweigh greenhouse gas effects (Anderson-Teixeira *et al.*, 2011,
2012a). This calculator incorporates both greenhouse gases and
biophysical climate regulation services, thereby providing a better
understanding of the climate impacts of various policies.

## Further Reading

Anderson-Teixeira KJ, Snyder PK, DeLucia EH (2011) Do biofuels life
cycle analyses accurately quantify the climate impacts of
biofuels-related land use change? *Illinois Law Review*, 2011, 589-622.

Anderson-Teixeira KJ, Snyder PK, Twine TE, Cuadra SV, Costa MH, DeLucia
EH (2012a) Climate-regulation services of natural and agricultural
ecoregions of the Americas. *Nature Climate Change*, 2, 177-181.

Anderson-Teixeira KJ, Duval BD, Long SP, DeLucia EH (2012b) Biofuels on
the landscape: Is land sharing? preferable to land sparing? *Ecological
Applications*, 22, 2035-2048.

Anderson-Teixeira KJ, DeLucia EH (2011) The greenhouse gas value of
ecosystems. *Global Change Biology*, 17, 425-438.

Buckeridge MS, Souza AP, Arundale RA, Anderson-Teixeira KJ, DeLucia E
(2012) Ethanol from sugarcane in Brazil: a "midway"? strategy for
increasing ethanol production while maximizing environmental benefits.
*GCB Bioenergy*, 4, 119-126.

Hungate BA, Hampton HM (2012) Ecosystem services: Valuing ecosystems for
climate. *Nature Climate Change*, 2, 151-152.
