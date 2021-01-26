library(DescTools)
library(tidyverse)
library(gganimate)

#read in data files
co2_df <- read.csv("owid-co2-data.csv",header = TRUE)
data("d.countries")

#calculate GDP per capita
co2_df$gdp_per_cap = co2_df$gdp / co2_df$population

#fil_df <-filter((co2_df), year == 1975)
#fil_df <- filter((fil_df), year != "")
fil_df <- filter((co2_df), year != "")

#left join tables
joined_df <- left_join(x=fil_df, y= d.countries, by=NULL, copy=FALSE)
joined_df <- joined_df[!is.na(joined_df$region),]

#create scatterplot
p <- ggplot(joined_df, aes(x=gdp_per_cap, y=co2_per_capita, size = co2, colour=region)) +
     geom_point(alpha=0.7) + 
     ylim(0,80) + 
     scale_x_log10(name ="GDP per Capita, USD") + 
     ylab("CO2 per capita, metric tonnes")

#animation
anim <- p +
        transition_time(year) + 
        labs(title = "Year: {frame_time}")