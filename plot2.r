library(DescTools)
library(tidyverse)
library(gganimate)

#read in data files
co2_df <- read.csv("owid-co2-data.csv",header = TRUE)
elec_df <- read.csv("elec_pct.csv",header = TRUE)

#calculate GDP per capita
co2_df$gdp_per_cap = co2_df$gdp / co2_df$population
fil_df <- filter((co2_df), year != "")

#filter out every country except USA and CHN
elec_df <- filter((elec_df), a3 == "CHN" | a3 == "USA")

#gather World Bank data by country and year
wide_elec_df <- gather(elec_df,key='Country', value='Elec_Coal', X1961:X2015)
colnames(wide_elec_df)[1] <- "Elec_Prod_Coal"
colnames(wide_elec_df)[6] <- "year"
wide_elec_df <- wide_elec_df[!is.na(wide_elec_df$Elec_Coal),]
wide_elec_df <- wide_elec_df[c('a3','Elec_Coal','year')]
wide_elec_df$year <- as.integer(gsub('X', '', wide_elec_df$year))

#left join tables
joined_df <- left_join(x=wide_elec_df, y= fil_df, by=NULL, copy=FALSE)
joined_df <- joined_df[!is.na(joined_df$Elec_Coal),]

#create scatterplot
p <- ggplot(joined_df, aes(x=gdp_per_cap, y=Elec_Coal, size = co2, colour=country)) +
     geom_point(alpha=0.7) + 
     ylim(0,100) + 
     scale_x_log10(name ="GDP per Capita, USD") + 
     ylab("Percentage of Electricity Production from Coal")

#animation
anim <- p +
        transition_time(year) + 
        shadow_mark() + 
        labs(title = "Year: {frame_time}")


