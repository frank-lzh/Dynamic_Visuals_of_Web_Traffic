library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  titlePanel("Pageview Statistics from Pulse"),
  
  #
  
  sidebarPanel(
    selectInput("Site","Customer site:",
                list("Netshoes"="Netshoes",
                     "Zattini"="Zattini")),
    selectInput("Device_Type","Device type:",
                list("all devices"="all",
                   "mobile phones"="mobile",
                     "non-mobile phones"="non-mobile")),
    selectInput("Page_Type","Website Page Type:",
                list("all pages"="All",
                     "product detail pages"="PDP",
                     "home pages"="Home",
                     "shopping cart pages"="Cart")),
    selectInput("Period","calculation period:",
                list("Per Day"="day",
                     "Per Hour"="hour",
                     "Per Minute"="minute"))
  ),
  
  mainPanel(
 #   textOutput("text1"),
    verbatimTextOutput("summary"),
    plotOutput("plot_ts")
  )
))