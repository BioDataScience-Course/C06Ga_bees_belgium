# Exploration et proposition d'une carte en exemple

# Packages ----
SciViews::R
library(sf)
library(tmap)

# Importation des données
be <- st_read("data/map_belgium/belgium.shp")
class(be)

bee <- read("data/wild_bees_belgium.rds")
class(bee)

# Première carte peu concluante
tm_shape(be) +
  tm_borders() +
  tm_shape(bee) +
  tm_dots()

# Il est intéressant de voir que certains points sont dans la mer du nord ;)
# Sacré Bombus !
str(be)
st_crs(be)
str(bee)
st_crs(bee)

# Ces jeux de données n'ont pas de variables qui permettent de faire le liens
# Les localités employées dans le jeu de données bee ne correspondent pas à be
# On va donc utiliser la fonction st_intersect() qui va lier les deux tableaux
inter <- st_intersects(be, bee)
be$nbpts <- sapply(X = inter, FUN = length)

# NISCode est un code pour reconnaître chaque commune, province, région belge
names(inter) <- be$NISCode
tab <- tibble(NISCode = names(inter[2]), nrow = inter[[2]])
for (i in 3:length(inter)) {
  if (length(inter[[i]]) != 0) {
    res <- tibble(NISCode = names(inter[i]), nrow = inter[[i]])
    tab <- bind_rows(tab, res)
  }
}

bee$nrow <- 1:nrow(bee)
bee <- left_join(tab, bee, by = "nrow")

# On s'intéresse aux Megachilidae, par exemple
bee %>.%
  filter(., family ==  "Megachilidae") %>.%
  group_by(., NISCode)%>.%
  summarise(., tot = length(individualCount)) -> mega

be_mega <- left_join(be, mega, by = "NISCode")

# Cartographie des Megachilidae
mega_map <- tm_shape(be_mega) +
  tm_borders() +
  tm_compass() +
  tm_scale_bar(position = c("left", "bottom")) +
  tm_fill("tot",title = "Occurence") +
  tm_legend(position = c(0.05, 0.2))

mega_map

# Sauvegarde pour inclure la carte example dans README.md sans la recalculer
#tmap_save(mega_map, "images/mega_map.png", dpi = 100)

