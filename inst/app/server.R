shinyServer(

  function(input, output) {

    if (file.exists("data/data.RData")){
      # load information sent through "launch_application"
      load("data/data.RData")
    }

    if (isTRUE(getOption("shiny.testmode"))) {
      # Load static/dummy data if this is a test run
      healthatlas_data <- shinymap::testdata
    }

    if (!exists("language")|| is.null(language)){
      # Define language to Norwegian, if not defined
      language <- "no"
    }

    if (language == "no"){
      lang = 1
    } else if (language == "en"){
      lang = 2
    } else { # default language value
      lang = 1
    }

    if (!exists("webpage_title") || is.null(webpage_title)){
      # Define the atlas title, if not defined
      webpage_title <- c("Helseatlas","The Norwegian healthcare atlas")[lang]
    }

    level1 <- c(levels(factor(healthatlas_data$level1)))

    level2 <- eventReactive(input$level1,{
      tmpdata <- dplyr::filter(healthatlas_data, level1 == input$level1)
      level2 <- c(levels(factor(tmpdata$level2)))
      return(level2)
    })

    level3 <- eventReactive(c(input$level1, input$level2), {
      if(is.null(input$level2)){return()}
      tmpdata1 <- dplyr::filter(healthatlas_data, level1 == input$level1)
      tmpdata2 <- dplyr::filter(tmpdata1, level2 == input$level2)
      level3 <- c(levels(factor(tmpdata2$level3)))
      return(level3)
    })

    output$pickLevel1 <- renderUI({
      selectInput(inputId = "level1",
                  label = c("Velg et tema:", "Pick a subject")[lang],
                  choices = level1,
                  selected = level1[1])
    })

    output$pickLevel2 <- renderUI({
      if ("level2" %in% colnames(healthatlas_data)){
        selectInput(inputId = "level2",
                    label = c("Velg et tema:", "Pick a subject")[lang],
                    choices = level2(),
                    selected = level2()[1])

      }
    })

    output$pickLevel3 <- renderUI({
      if ("level3" %in% colnames(healthatlas_data)){
        selectInput(inputId = "level3",
                    label = c("Velg et tema:", "Pick a subject")[lang],
                    choices = level3(),
                    selected = level3()[1])
      }
    })


    output$makeTable <- renderUI({
      tableOutput("tabell")
    })

    kartlagInput <- reactive({
      datasett <- shinymap::filterOut(healthatlas_data, filter1 = input$level1, filter2 = input$level2, filter3 = input$level3)
      return(datasett)
    })

    pickedData <- reactive({
      new_tab <- data.frame(kartlagInput()$area)
      colnames(new_tab) <- c(c("Opptaksomr", "Area")[lang])
      new_tab[c("Rate", "Rate")[lang]] <- kartlagInput()$rate
      new_tab[c("Antall", "Num")[lang]] <- kartlagInput()$numerater
      new_tab[c("Innbyggere", "Inhab")[lang]] <- kartlagInput()$denominator
      return(new_tab)
    })

    output$tabell<-renderTable({
      pickedData()
    })

    output$title <- renderUI({
      return(HTML(paste0("<h1>", webpage_title, "</h1>")))
    })

    output$titleTable <- renderUI({
      return(c("Tabell","Table")[lang])
    })

    output$titleMap <- renderUI({
      return(c("Kart", "Map")[lang])
    })

    output$titleHist <- renderUI({
      return(c("Histogram", "Histogram")[lang])
    })

    output$pickMap <- renderUI({
      selectInput(inputId = "maptype",
                  label = c("Velg karttype", "Choose map type")[lang],
                  choices = c("leaflet","simple"),
                  selected = "leaflet")
      # Make a leaflet map
#      leaflet::leafletOutput("leafletmap")
    })
    output$plotMap <- renderUI({
      # Make a leaflet map
      type <- input$maptype
      if (is.null(type)){return(NULL)}
      switch(type,
             leaflet = {leaflet::leafletOutput("leafletmap")},
             simple = {shiny::plotOutput(outputId = "simplemap")}
      )
    })
    
    output$plotHistogram <- renderUI({
      # Make a histogram plot
      shiny::plotOutput(outputId = "histogram")
    })

    output$simplemap <- renderPlot({
      shinymap::makeMap(type = "simple", map = healthatlas_map)
    })
    
    output$histogram <- renderPlot({
      shinymap::plotVariation(inputData = kartlagInput(), xlab = c("Opptaksomr\u00E5de", "Area")[lang], ylab = input$level1)
    })

    output$leafletmap <- leaflet::renderLeaflet({
      shinymap::makeMap(type = "leaflet", map = healthatlas_map)
    })

  }

)
