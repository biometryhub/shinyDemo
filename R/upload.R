# Upload CSV module
library(shiny)
library(shinyWidgets)
library(shinydashboardPlus)
library(shinytoastr)

csvFileUI <- function(id, label = "CSV file") {
    # Create a namespace function using the provided id
    ns <- NS(id)
    useToastr()
    tagList(
        fileInput(ns("file"), label),
        div(class = "container-fluid",
            div(class = 'row',
                div(class = 'col-md-4', id = 'header', style="float: left; vertical-align:top; width: 24%; margin-right: 2%",
                    br(),
                    prettyCheckbox(
                        NS(id, "header"),
                        label = "Header", 
                        value = TRUE,
                        status = "primary",
                        icon = icon("check"), 
                        plain = TRUE,
                        animation = "pulse",
                        outline = TRUE
                    )
                ),
                div(class = 'col-md-8', id = "sep_type", style="float: left; vertical-align:top; width: 74%;",
                    prettyRadioButtons(
                        NS(id, "sep"),
                        label = "Separator:", 
                        choices = c(Comma = ",", Semicolon = ";", Tab = "\t"),
                        selected = ",",
                        plain = TRUE,
                        fill = T,
                        inline = TRUE, 
                        shape = "square",
                        # status = "primary",
                        animation = "pulse",
                        icon = icon("check")
                    )
                )
            )
        ),
        # checkboxInput(ns("heading"), "Has heading"),
        # selectInput(ns("quote"), "Quote", c(
        #     "None" = "",
        #     "Double quote" = "\"",
        #     "Single quote" = "'"
        # ))
    )
}


# Module server function
csvFileServer <- function(input, output, session, stringsAsFactors) {
    # The selected file, if any
    observeEvent(
        input$file,
        {
            toastr_warning(title = "Please Note", message = "Testing message", position = "top-full-width")
        }
    )
    
    userFile <- reactive({
        # If no file is selected, don't do anything
        validate(need(input$file, message = FALSE))
        input$file
    })
    
    
    
    # The user's data, parsed into a data frame
    dataframe <- reactive({
        inputId = "file"
        read.csv(userFile()$datapath,
                 header = input$header,
                 # quote = input$quote,
                 sep = input$sep,
                 stringsAsFactors = stringsAsFactors)
    })
    
    # We can run observers in here if we want to
    observe({
        msg <- sprintf("File %s was uploaded", userFile()$name)
        cat(msg, "\n")
    })
    
    # Return the reactive that yields the data frame
    return(dataframe)
}