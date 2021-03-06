library(sf)
library(dplyr)
library(viridis)
library(ggplot2)

can <- read_sf('data/can_census_divisions_shp/gcd_000b11a_e.shp')

qu <- unique(can$PRNAME)[6]

can<- can %>%
  filter(PRNAME == qu) %>%
  mutate(CDUID = as.integer(CDUID))

nhs_data <- read.csv('data/canada_economic_metrics/censusdivisions_econmetrics.csv', stringsAsFactors = F)

nhs_data <- nhs_data %>%
  select(-Prov_Name, -CD_Name, -Geo_Type, -GNR) %>%
  rename(CDUID = Geo_Code)

can <- can %>%
  left_join(nhs_data, by = 'CDUID')

# add toy variables
can <- can %>%
  mutate(nbobs = sample(x = c(50:100), size = nrow(can), replace = T), 
         nbind = sample(x = c(1:49), size = nrow(can), replace = T))

# stats to plot

can <- can %>%
  mutate(nbobs_per_pop = nbobs/Total_pop, 
         nbind_per_pop = nbind/Total_pop,
         nbobs_per_ind = nbobs/nbind)


# Make maps of summary stats from toy stats
# Use viridis for color blind friendly colors.

can_short <- can[1:10, ]

obspercap_plot <- ggplot(data = can_short) +
  geom_sf(aes(fill = nbobs_per_pop)) +
  scale_fill_viridis() +
  ggtitle('Observations per capita')

indpercap_plot <- ggplot(data = can_short) +
  geom_sf(aes(fill = nbind_per_pop)) +
  scale_fill_viridis() +
  ggtitle('Observers per capita')

obsperind_plot <-  ggplot(data = can_short) +
  geom_sf(aes(fill = nbobs_per_ind)) +
  scale_fill_viridis() +
  ggtitle('Observations per observer')


