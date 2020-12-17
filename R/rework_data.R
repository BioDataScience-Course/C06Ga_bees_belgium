# Ce script retravailles les données sur les abeilles sauvages.
# Ne modifiez pas ce code. Il est cependant intéressant d'essayer de la comprendre

# Packages ----
SciViews::R
library(sf)

# Wild bees of Belgium -----
## Importation des données bees provenant <<https://doi.org/10.15468/dl.465vwp>
bee <- read_tsv("data/raw/wild_belgian_bees.csv")
table(bee$year)
bee_2016 <- filter(bee, year == "2016") # on se concentre sur les observations de 2016

str(bee_2016)
class(bee_2016) 

bee_2016_sf <- st_as_sf(bee_2016, coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)
mapview::mapview(bee_2016_sf) # notre objet comprend donc une série de point pour chaque observation
class(bee_2016_sf)

write(bee_2016_sf, "data/wild_bees_belgium.rds", type = "rds", compress = "xz")

# Map of belgium ----
belgium <- st_read("data/raw/adminvectorwgs/AD_2_Municipality.shp")
pryr::object_size(belgium) # le fichier est trop volumineux et va prendre trop de temps pour réaliser une carte

be <- st_simplify(belgium, dTolerance = 0.001)
pryr::object_size(be)

qtm(be)
write_sf(obj = be, dsn ="data/map_belgium/belgium.shp")

# check final ---
bee <- st_as_sf(read("data/wild_bees_belgium.rds"))
class(bee)
qtm(bee)

be <- read_sf("data/map_belgium/belgium.shp")
qtm(be)
