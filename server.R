#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# Load libraries
library(shiny)
library(tidyverse)

# Load dataset
salaries <- readRDS("pnf_salaries.RDS")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    pay_data <- reactive({
        filtered_by_year <- salaries %>%
            filter(Year %in% input$years) %>%
            mutate(Benefits = as.numeric(Benefits))
        
        
        # Find which pay_types the user selected
        pay_index <- which(colnames(filtered_by_year) %in% input$pay_type)
        
        # Pull out only the pay columns we're interested in.
        pay_matrix <- filtered_by_year %>%
            select(pay_index)
        
        
        # Set all the NA's to zero
        pay_matrix[is.na(pay_matrix)] <- 0
        
        # Calculate th  +=987543Q    total pay based on user selections
        calced_pay <- data.frame(totalPay = rowSums(pay_matrix))
        
        # Bind the column to the original data frame
        pay_total <- cbind(category = filtered_by_year$category, calced_pay)
        
        # Create final df with a filter to remove records outside the salary range.
        filtered_pay_range <- pay_total %>%
            filter(calced_pay >= input$income[1], calced_pay <= input$income[2])
        
        return(filtered_pay_range)
    })
    
    output$selected_years <- renderText({input$years})
    output$pay_type <- renderText({input$pay_type})
    output$income_range <- renderText({input$income})
    output$violin_plot <- renderPlot({
        ggplot(data=pay_data(), aes(x=category, y=totalPay)) +
            geom_violin() +
            scale_y_continuous("Pay in USD($)",
                               breaks = seq(from=input$income[1],
                                            to=input$income[2],
                                            length.out = 10))
    })
})
