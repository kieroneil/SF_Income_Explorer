#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("San Francisco Public Employee Salaries: Police, Nurses, Fire"),
    #tags$em("I wanted to include teachers but apparently teachers are not city employees.")
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput("years", label = h3("Select years to include:"), 
                               choices = list("2014" = 2014, "2013" = 2013, "2012" = 2012, "2011" = 2011),
                               selected = 2014),
            checkboxGroupInput("pay_type", label = h3("Select type of income to include:"), 
                               choices = list("Base Pay" = "BasePay", 
                                              "Overtime Pay" = "OvertimePay", 
                                              "Other Pay" = "OtherPay", 
                                              "Benefits" = "Benefits"),
                               selected = c("BasePay", "OvertimePay", "OtherPay", "Benefits")),
            sliderInput("income", label = h3("Select total income range:"), min = 10000, 
                        max = 500000, value = c(10000, 500000))
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("violin_plot", width = "100%", height = "500px")
        )
    )
))