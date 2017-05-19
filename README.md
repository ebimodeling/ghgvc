> This is a shallow clone of the Ecosystem Climate Regulation Services Calculator
> found at https://github.com/ebimodeling/ghgvc used for Ruby for Good

# Ecosystem Climate Regulation Services Calculator

This is the source code repository for the Ecosystem Climate Regulation
Services Calculator. Contributions, comments, bug reports, and
feature requests are welcome!

# Setup & Installation

This is a first-pass at a standalone installation of all dependencies which will
allow development on macOS.


## Dependencies

### MacOS

* Install [homebrew for MacOS](https://brew.sh/)

The following brew packages are required:
* `mysql`
* `node`
* `homebrew/science/netcdf`
* `homebrew/science/r`
* `git` (optional if you already have git installed or prefer not to upgrade your version)

Example homebrew install command:

```
brew install mysql node homebrew/science/netcdf homebrew/science/r git
```

**NOTE:** zsh users may have problems running the `r` command. `disable r` or
`command r` to run it, or start with `/usr/bin/env r`

* Start the MySQL database service:

```
brew services start mysql
```

* Give the MySQL root user a password

```
mysql -uroot
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'somesupersecretpassword'
```

### Ubuntu Linux

The following Ubuntu packages are needed:

* mysql-server
* nodejs
* libnetcdf-dev
* r-base
* libmysqlclient-dev
* libxml2-dev

Example install command:

```
sudo apt-get -y install mysql-server nodejs libnetcdf-dev r-base libmysqlclient-dev libxml2-dev
```

* Give the MySQL root user a password

```
mysql -uroot
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'somesupersecretpassword'
```

## Download the project

* Clone the repo:

```
git clone git@github.com:rubyforgood/ghgvc.git && cd ghgvc
```

* Install ruby 2.4.1. If you don't have a plugin manager, try https://github.com/asdf-vm/asdf.

* Optional but recommended:

```
gem update --system
```

* Install bundler:

```
gem install bundler
```

* Install project library dependencies:

```
bundle install
```

* Set `MYSQL_USER` and `MYSQL_PASSWORD` environment variables to the username and
password with database create privileges in MySQL.

* Setup the database:

```
bundle exec rake db:create db:schema:load
```

## Retrieve the data files

(TODO: Issue #1)

* Download the netcdf files from here: https://uofi.box.com/v/ghgvc-inputs
* Move the following 5 files in `netcdf/GCS/Maps/` folder
    * `gez_2010_wgs84.nc`
    * `Hurtt_SYNMAP_Global_HD_2010.nc`
    * `hwsd.nc`
    * `koppen_geiger.nc`
    * `vegtype.nc`
* Move the remaining files to `netcdf` folder

## Install R packages

( TODO: cd into a diff directory? We definitely don't want this in the repo

  TODO: Move this into a separate service? Might make Rails app dev easier)

```  
> cd tmp
> git clone https://github.com/ebimodeling/ghgvcR
> r

R version 3.4.0 (2017-04-21) -- "You Stupid Darkness"
...
> install.packages(c("devtools", "roxygen2", "rjson", "reshape", "XML", "ggplot2", "gridExtra", "Hmisc", "scales", "tidyr", "ncdf4"), repos = "http://cran.us.r-project.org")
> install.packages("/full/path/to/ghgvcR", repos=NULL, type="source")
> quit()
```

If you need to remove the package later run `R CMD REMOVE ghgvcr` from command line

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

## Applications

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
