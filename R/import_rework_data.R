# Importation et remaniement des données concernant les abeilles sauvages en
# Belgique. Ne modifiez pas ce code mais essayez de la comprendre et
# inspirez-vous en...
# Comme les données brutes sont trop volumineuses, elles ne sont pas stockées
# dans le dépôt GitHub (data/raw/ est ajouté dans le fichier .gitignore)
# Par contre, les données brutes sont téléchargeables depuis un serveur sur le
# Cloud afin de rendre l'analyse reproductible (il faut que toutes les étapes
# de votre analyses puissent être reproduites à partir du clonage de votre dépôt
# Github).

# Packages ----
SciViews::R
library(sf)
library(tmap)
# Egalement nécessaires, mais non chargés directement
#library(mapview)
#library(pryr)

# Get Raw Data from the Cloud ----
# Note: sous-dossier raw compressés avec tar -a -cf bees_belgium.tar.xz
# à partir du dossier data (11Mb) et uploadé sur p-Cloud
# Si le sous-dossier data/raw n'existe pas, nous récupérons les données
if (!file.exists("data/raw")) {
  # Téléchargement du fichier compressé
  data_url <- "https://go.sciviews.org/bees_belgium"
  data_tar_xz <- "data/bees_belgium.tar.xz"
  download.file(url = data_url, destfile = data_tar_xz)
  # Décompression dans le dossier data
  untar(data_tar_xz, exdir = "data")
  # Elimination du fichier compressé temporaire
  unlink(data_tar_xz)
}

# Wild bees of Belgium -----
# Les données proviennent initialement de <https://doi.org/10.15468/dl.465vwp>
# Le site GBiF necessite un login et le téléchargement direct des données n'est
# pas possible depuis ce site. Par conséquent, les données brutes sont fournies
# à partir de "https://go.sciviews.org/bees_belgium" (voir plus haut)
bee_data <- "data/raw/wild_belgian_bees.csv"
bee <- read$tsv(bee_data)
table(bee$year)

# On se concentre sur les observations de 2016
bee_2016 <- filter(bee, year == "2016")
str(bee_2016)
class(bee_2016)
nrow(bees2016)

# Transformation en objet sf
bee_2016_sf <- st_as_sf(bee_2016,
  coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)
# Visualisation interactive
mapview::mapview(bee_2016_sf) # série de point pour chaque observation
class(bee_2016_sf)

# Sauvegarde des données réduites et sous forme compressée dans le dépôt GitHub
# Note: cette instruction est mise en commentaire pour éviter d'écraser par
# mégarde le fichier de départ!
#write$rds(bee_2016_sf, "data/wild_bees_belgium.rds", compress = "xz")

# Map of Belgium ----
# Les données proviennent de
# https://www.geo.be/catalog/details/fb1e2993-2020-428c-9188-eb5f75e284b9?l=fr
# Elles sont aussi stockées sous une forme directement téléchargeable dans R
# depuis "https://go.sciviews.org/bees_belgium" (voir plus haut)
map_data <- "data/raw/map_belgium/AD_2_Municipality.shp"
belgium <- st_read(map_data)
pryr::object_size(belgium)
# Données trop volumineuses (va prendre trop de temps pour réaliser une carte
# sur les ordinateurs les plus lents)

# Simplification des données
be <- st_simplify(belgium, dTolerance = 0.001)
pryr::object_size(be)

# Vérification
mapview::mapview(be)

# Sauvegarde des données simplifiées dans le dépôt GitHub
# Note: cette instruction est commentée pour éviter de les écraser par mégarde
#write_sf(obj = be, dsn = "data/map_belgium/belgium.shp")

# Check final ---
bee <- st_as_sf(read("data/wild_bees_belgium.rds"))
mapview::mapview(bee)

be <- read_sf("data/map_belgium/belgium.shp")
mapview::mapview(be)
