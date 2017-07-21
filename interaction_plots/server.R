library(shiny)
library(scales)
library(ggplot2)


# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  result_directory="~/Exploration/traffic_count/result/"

  get_prefix <- reactive({paste0(input$Site,"_",input$Page_Type,"_",input$Period,"_",input$Device_Type,".txt")})
  get_data_input <- reactive({read.csv(file=paste0("./data/",get_prefix()),,header = FALSE, sep = "|")})  
    
  output$summary <- renderPrint({
    dataset=get_data_input()
    colnames(dataset) <- c("time","count")
  summary(dataset$count)
  #paste0("starting time: ",dataset$time[1])
  #paste0("ending time: ",dataset$time[nrow(dataset)])
  })
  
  output$plot_ts <- renderPlot({
    dataset=get_data_input()
    dataset$time=as.POSIXct(dataset$V1,format="%Y-%m-%d  %H:%M:%S")
    ggplot(data=dataset,aes(x=time,y=V2))+
    geom_line(data=dataset,aes(x=time,y=V2))+
      ylab("Pageview Count")+
      xlab("Time")+
      ggtitle(paste0("Pageview Count Time Series View for ",get_prefix()))+
      theme(plot.title = element_text(size = 20, face = "bold",hjust=0.5),
            axis.text = element_text(size=12),
            axis.title = element_text(size=16))+
      scale_y_continuous(labels = comma)+
      scale_x_datetime(breaks = date_breaks("1 weeks"),labels=date_format("%b-%d"))
  })
  
#  output$text1 <- renderText({paste0("starting time: ",dataset$time[1])})

})