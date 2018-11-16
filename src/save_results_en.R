library(XML)
library(httr)
library(xml2)
library(tidyverse)
library(purrr)
library(forcats)
library(feather)

save_results_en <- function(.countries, .region, .file_save_name, indicator_resp){
    
    result <- map_df(.countries, ~ get_data(indicator_resp, .x))
    
    bar_plot <- result %>%
        ggplot(aes(x = year, y = value, fill = fct_reorder(country, value, .desc = TRUE)),
               environment = environment()) +
        geom_bar(stat = 'identity') +
        coord_flip() +
        ylim(0, NA) +
        labs(title = paste0('Number of Feminicides in ',  .region, ' per Year'),
             x = 'Year', 
             y = 'Number of Feminicides', 
             fill = 'Country')
    
    line_plot <- result %>%
        ggplot(aes(x = year, y = value),
               environment = environment()) +        
        geom_line(aes(group = country, colour = fct_reorder(country, value, .desc = TRUE))) +
        ylim(0, NA) +
        labs(title = paste0('Number of Feminicides in ',  .region, ' per Year'),
             x = 'Year', 
             y = 'Number of Feminicides', 
             colour = 'Country')
    
    write_feather(result, paste0('data/', .file_save_name, '.feather'))
    write_csv(result, paste0('data/', .file_save_name, '.csv'))
    
    ggplot2::ggsave(paste0('results/bar_', .file_save_name, '.svg'), plot = bar_plot)
    ggplot2::ggsave(paste0('results/line_', .file_save_name, '.svg'), plot = line_plot)
}
