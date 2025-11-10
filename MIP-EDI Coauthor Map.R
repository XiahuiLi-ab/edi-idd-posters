
### World Map of Coauthor Institutions

library(ggplot2)
library(maps)
library(ggrepel)
library(scales)

# Define coauthors and institution information
coauthors <- data.frame(
  institution = c(
    "University of St Andrews (UK)",
    "Linköping University (SE)",
    "National University of Singapore (SG)",
    "University of Warwick (UK)",
    "University of Oxford (UK)",
    "University of Hong Kong (CN)",
    "Heriot-Watt University (UK)",
    "Mahidol University (TH)",
    "Fred Hutchinson Cancer Center (USA)",
    "University of Sheffield (UK)",
    "Georgetown University (USA)"
  ),
  city = c(
    "St Andrews",
    "Linköping",
    "Singapore",
    "Coventry",
    "Oxford",
    "Hong Kong",
    "Edinburgh",
    "Bangkok",
    "Seattle",
    "Sheffield",
    "Washington DC"
  ),
  country = c("UK", "Sweden", "Singapore", "UK", "UK", "China", 
              "UK", "Thailand", "USA", "UK", "USA"),
  lon = c(-2.7967, 15.6214, 103.8198, -1.5609, -1.2577, 114.1694,
          -3.1883, 100.4975, -122.3321, -1.4701, -77.0369),
  lat = c(56.3398, 58.4108, 1.3521, 52.3825, 51.7520, 22.2783,
          55.9533, 13.7944, 47.6062, 53.3811, 38.9072),
  stringsAsFactors = FALSE
)

# Get world map data
world_map <- map_data("world")


map_color <- "#E8E8E8"           # Light gray for continents
border_color <- "#FFFFFF"        # White borders
point_color <- "#D62728"         # Strong red for points
point_border <- "#8B1A1F"        # Dark red border
label_bg <- "#FFFFFF"            # White background for labels
label_border <- "#CCCCCC"        # Light gray border for labels
segment_color <- "#666666"       # Medium gray for label lines

# Create the map
p <- ggplot() +
  
  geom_polygon(data = world_map, 
               aes(x = long, y = lat, group = group),
               fill = map_color, 
               color = border_color, 
               linewidth = 0.2) +
  
  # Add points for institutions
  geom_point(data = coauthors, 
             aes(x = lon, y = lat),
             color = point_border,
             size = 5,
             alpha = 1,
             shape = 21,
             fill = point_color,
             stroke = 1.2) +
  
  # Add labels for institutions
  geom_text_repel(data = coauthors,
                  aes(x = lon, y = lat, label = institution),
                  size = 3,
                  fontface = "bold",
                  box.padding = 1.0,
                  point.padding = 0.6,
                  segment.color = segment_color,
                  segment.size = 0.4,
                  segment.alpha = 0.8,
                  bg.color = label_bg,
                  bg.r = 0.15,
                  max.overlaps = 30,
                  min.segment.length = 0,
                  force = 3,
                  force_pull = 1) +
  
  
  coord_map("mercator", xlim = c(-180, 180), ylim = c(-60, 85)) +
  
  theme_void() +
  theme(
    
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    
    plot.title = element_text(
      hjust = 0.5, 
      size = 16, 
      face = "bold",
      family = "sans",
      margin = margin(b = 5)
    ),
    
    plot.subtitle = element_text(
      hjust = 0.5, 
      size = 11,
      family = "sans",
      color = "#666666",
      margin = margin(b = 15)
    ),
    
    plot.caption = element_text(
      hjust = 0.5,
      size = 9,
      family = "sans",
      color = "#999999",
      margin = margin(t = 10)
    ),
    
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
  ) +
  
  labs(
    title = "MIP-EDI Global Collaboration Network",
    subtitle = "Institutional Affiliations of Coauthors",
    caption = paste0(nrow(coauthors), " institutions across ", 
                     length(unique(coauthors$country)), " countries")
  )


print(p)

ggsave("coauthor_map.png", 
       plot = p, 
       width = 10, 
       height = 6, 
       dpi = 600,
       bg = "white",
       units = "in")

