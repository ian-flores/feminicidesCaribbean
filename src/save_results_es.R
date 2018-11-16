library(XML)
library(httr)
library(xml2)
library(tidyverse)
library(purrr)
library(forcats)
library(feather)

save_results_es <- function(.countries, .region, .file_save_name, indicator_resp){
    
    result <- map_df(.countries, ~ get_data(indicator_resp, .x))
    
    bar_plot <- result %>%
        ggplot(aes(x = year, y = value, fill = fct_reorder(country, value, .desc = TRUE)),
               environment = environment()) +
        geom_bar(stat = 'identity') +
        coord_flip() +
        ylim(0, NA) +
        labs(title = paste0('Número de feminicidios en ',  .region, ' por Año'),
             x = 'Año', 
             y = 'Número de feminicidios', 
             fill = 'País')
    
    line_plot <- result %>%
        ggplot(aes(x = year, y = value),
               environment = environment()) +        
        geom_line(aes(group = country, colour = fct_reorder(country, value, .desc = TRUE))) +
        ylim(0, NA) +
        labs(title = paste0('Número de feminicidios en ',  .region, ' por Año'),
             x = 'Año', 
             y = 'Número de feminicidios', 
             colour = 'País')
    
    write_feather(result, paste0('data/', .file_save_name, '.feather'))
    write_csv(result, paste0('data/', .file_save_name, '.csv'))
    
    ggplot2::ggsave(paste0('results/es_bar_', .file_save_name, '.svg'), plot = bar_plot)
    ggplot2::ggsave(paste0('results/es_line_', .file_save_name, '.svg'), plot = line_plot)
}