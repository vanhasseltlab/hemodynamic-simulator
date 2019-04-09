#--------------------------------------------------------------------------------------------------------------
#   This application was developed based on Snelder's cardiovascular model.
#
#   Yu Fu
#   March 6th, 2019
#--------------------------------------------------------------------------------------------------------------

library(shiny)
library(shinydashboard)
library(shinyalert)
library(shinyWidgets)
library(shinyjs)
library(V8)

# javascript code to collapse box
jscode <- "shinyjs.collapse = function(boxid) {
           $('#' + boxid).closest('.box').find('[data-widget=collapse]').click();
          }"

body <- dashboardBody(
                      # Including Javascript
                      useShinyjs(),
                      extendShinyjs(text = jscode),
                      
                      fluidRow(setSliderColor(rep("#001158",1000), 1:1000),
                               # set shadow for boxes
                               setShadow("box"),
                               
                               tags$head(tags$style(HTML(".skin-blue .main-header > .logo { background-color: #001158;
                                                                                            font-weight: bold;
                                                                                            font-size: 28px}
                                                          .skin-blue .main-header .logo:hover {background-color: #001158;}

                                                          .skin-blue .main-header .navbar { background-color: #001158;} 

                                                         .box-primary .box-header>.logo{
                                                          font-weight: bold;}
            
                                                         .nav-tabs-custom .nav-tabs li.active {
                                                            border-top-color: #001158;
                                                          }
                                                         .box.box-solid.box-primary>.box-header {
                                                              color: #fff;
                                                              background: #001158;}
                                                          
                                                         .box.box-solid.box-primary{
                                                              border-bottom-color: #ccc;
                                                              border-left-color: #ccc;
                                                              border-right-color: #ccc;
                                                              border-top-color: #ccc;
                                                              
                                                          }
                                                          .box.box-solid.box-success>.box-header {background: #f46e32}
                                                          .box.box-solid.box-success{
                                                               border-bottom-color: #ccc;
                                                               border-left-color: #ccc;
                                                               border-right-color: #ccc;
                                                               border-top-color: #ccc;
                                                          
                                                          }
                                                         #titleID0{background-color:#001158}
                                                         #titleID1{background-color:#001158}
                                                         #titleID2{background-color:#001158}
                                                         #titleID3{background-color:#001158}
                                                         #titleID4{background-color:#001158}
                                                         #titleID5{background-color:#001158}
                                                         #titleID6{background-color:#001158}
                                                         #titleID7{background-color:#001158}
                                                         #titleID8{background-color:#001158}
             "))),
                               
                               column(width = 4,
                                      
                                      #-------------------------------------- Species -------------------------------------------
                                      box(width = NULL,
                                          id = "box0",
                                          collapsible = TRUE,collapsed = TRUE,
                                          status = "primary",
                                          solidHeader = TRUE,
                                          title = actionLink("titleID0",span(icon("paw"),span("STEP 1: Select Species for Simulation",style = "font-weight:bold;font-size:18px"))),
                                          awesomeRadio("specie","Select a Specie for Simulation:",choices = c("Rat","Dog"), selected = "Rat", inline = TRUE),
                                          conditionalPanel(
                                            condition = "input.specie == 'Rat'",
                                            awesomeRadio("rattype","Select rat strain:",choices = c("spontaneously hypertensive rats (SHR)","normotensive Wistar-Kyoto rats (WKY)"),
                                                                                                    selected = "spontaneously hypertensive rats (SHR)", inline = TRUE)
                                          ),
                                          actionButton("info1","Species-specific model parameters",icon = icon("info-circle"))),
                                      
                                      #--------------------------------------- Reference Drug (Optional) ---------------------------
                                      box(width = NULL,
                                          id = "box1",
                                          title = actionLink("titleID1",span(icon("book"),span("STEP 2: Simulate Reference Drug (Optional)",style = "font-weight:bold"))),
                                          collapsible = TRUE,collapsed = TRUE,
                                          status = "primary",
                                          solidHeader = TRUE,
                                          conditionalPanel(
                                            condition = "input.specie == 'Rat'",
                                            pickerInput("drugname", "Drug:",
                                                        choices = c("Amiloride",
                                                                    "Amlodipine",
                                                                    "Atropine",
                                                                    "Enalapril",
                                                                    "Fasudil",
                                                                    "Hydrochlorothiazide(HCTZ)",
                                                                    "Prazosin"),
                                                        options = list(title = "Select a reference drug"))
                                          ),
                                          
                                          conditionalPanel(
                                            condition = "input.specie == 'Dog'",
                                            pickerInput("drugname2","Drug:",
                                                        choices = "No reference drug available.",
                                                        options = list (title = "No reference drug available"))
                                          ),
                                          
                                          conditionalPanel(
                                            condition = "input.drugname != '' ",
                                            
                                            actionButton("info2","Drug-specific model parameters",icon = icon("info-circle")),
                                            h5(),
                                            materialSwitch("plotswitch",span("Show plot:",style="font-weight:bold"),value = TRUE, status="primary"),
                                            hr(),
                                            fluidRow(align ="center",span("Dose Regimen",style = "font-weight:bold;font-style:italic;font-size:18px;color:grey;")),
                                            pickerInput("nodoselvl2", "Number of dose levels:",choices = 1:5),
                                            
                                            awesomeRadio("amountunit2","Amount Unit:",choices = c("mg/kg","ug/kg","ng/kg"), selected = "mg/kg", inline = TRUE),
                                            conditionalPanel(
                                              condition = "input.nodoselvl2 > 1",
                                              sliderInput("ii2", "Interdose interval (h):", value = 24, min = 12, max = 7*24, step = 12)
                                            ),
                                            sliderInput("amt2_1","Amount 1:",min = 0, max = 10, value = 1,step = 0.1),
                                            
                                            conditionalPanel(
                                              condition = "input.nodoselvl2 >= 2",
                                              sliderInput("amt2_2","Amount 2:",min = 0, max = 10, value = 1,step = 0.1)
                                            ),
                                            conditionalPanel(
                                              condition = "input.nodoselvl2 >= 3",
                                              sliderInput("amt2_3","Amount 3:",min = 0, max = 10, value = 1,step = 0.1)
                                            ),
                                            conditionalPanel(
                                              condition = "input.nodoselvl2 >= 4",
                                              sliderInput("amt2_4","Amount 4:",min = 0, max = 10, value = 1,step = 0.1)
                                            ),
                                            conditionalPanel(
                                              condition = "input.nodoselvl2 == 5",
                                              sliderInput("amt2_5","Amount 5:",min = 0, max = 10, value = 1,step = 0.1)
                                            )
                                            )
                                          ),
                                      
                                      #------------------------------------------- Investigational Drug -------------------------------------------------
                                      box(width = NULL,
                                          id = "box2",
                                          title = actionLink("titleID2",span(icon("search"),span("STEP 3: Simulate Investigational Drug",style = "font-weight:bold"))),
                                          collapsible = TRUE,collapsed = TRUE,
                                          status = "primary",
                                          solidHeader = TRUE,
                                          
                                          textInput("IDname","Drug name (optional):",placeholder = "Enter drug name here"),
                                          pickerInput("cmt", "Select PK model:",
                                                       choices = c("one-compartmental", "two-compartmental", "three-compartmental"),
                                                       options = list(title = "Select one, two or three compartmental model")),
                                          
                                          conditionalPanel(
                                            condition = "input.cmt =='one-compartmental'| input.cmt == 'two-compartmental'| input.cmt =='three-compartmental'" ,
                                            hr(),
                                            fluidRow(align="center",span("Dose Regimen",style = "font-weight:bold;font-style:italic;font-size:18px;color:grey;")),
                                            
                                            pickerInput("nodoselvl1", "Number of dose levels:",choices = 1:5),
                                            awesomeRadio("amountunit","Amount Unit:",choices = c("mg/kg","ug/kg","ng/kg"), selected = "mg/kg", inline = TRUE),
                                            conditionalPanel(
                                              condition = "input.nodoselvl1 > 1",
                                              sliderInput("ii1", "Interdose interval (h):", value = 24, min = 12, max = 7*24, step = 12)
                                            ),
                                            sliderInput("amt1_1","Amount 1:",min = 0, max = 10, value = 1,step = 0.1),
                                            
                                            conditionalPanel(
                                              condition = "input.nodoselvl1 >= 2",
                                              sliderInput("amt1_2","Amount 2:",min = 0, max = 10, value = 1,step = 0.1)
                                            ),
                                            conditionalPanel(
                                              condition = "input.nodoselvl1 >= 3",
                                              sliderInput("amt1_3","Amount 3:",min = 0, max = 10, value = 1,step = 0.1)
                                            ),
                                            conditionalPanel(
                                              condition = "input.nodoselvl1 >= 4",
                                              sliderInput("amt1_4","Amount 4:",min = 0, max = 10, value = 1,step = 0.1)
                                            ),
                                            conditionalPanel(
                                              condition = "input.nodoselvl1 == 5",
                                              sliderInput("amt1_5","Amount 5:",min = 0, max = 10, value = 1,step = 0.1)
                                            ),
                                            
                                            
                                            hr(),
                                            fluidRow(align="center",span("PK Parameters",style = "font-weight:bold;font-style:italic;font-size:18px;color:grey;")),
                                            sliderInput("V1","V1 (L/kg):",value = 10, min = 0, max = 100, step = 0.1),
                                            sliderInput("k10",HTML("k10 (h<sup>-1</sup>):"),value = 0.1, min = 0.1, max = 10, step = 0.1)
                                          ),
                                          
                                          conditionalPanel(
                                            condition = "input.cmt =='two-compartmental'|input.cmt =='three-compartmental'",
                                            sliderInput("k12",HTML("k12 (h<sup>-1</sup>):"),value = 0.1, min = 0.1, max = 10, step = 0.1),
                                            sliderInput("k21",HTML("k21 (h<sup>-1</sup>):"),value = 0.1, min = 0.1, max = 10, step = 0.1)
                                          ),
                                          
                                          conditionalPanel(
                                            condition = "input.cmt =='three-compartmental'",
                                            sliderInput("k13",HTML("k13 (h<sup>-1</sup>):"),value = 0.1, min = 0.1, max = 10, step = 0.1),
                                            sliderInput("k31",HTML("k31 (h<sup>-1</sup>):"),value = 0.1, min = 0.1, max = 10, step = 0.1)
                                          ),
                                          conditionalPanel(
                                            condition = "input.cmt =='one-compartmental'| input.cmt == 'two-compartmental'| input.cmt =='three-compartmental'" ,
                                            hr(),
                                            fluidRow(align ="center",span("PD Parameters",style = "font-weight:bold;font-style:italic;font-size:18px;color:grey;")),
                                            awesomeRadio("mode","Mode of Action:",
                                                       choices = c("Heart Rate","Stroke Volume","Total Peripheral Resistance"),
                                                       selected = "Heart Rate", inline = TRUE),
                                        
                                            materialSwitch("cr",span("Circadian Rhythm Switch:",style = "font-weight:bold"),value = FALSE, status="primary"),
                                            sliderInput("emax","Emax:",min = 0, max = 2, value = 1, step = 0.01),
                                            sliderInput("ec50","EC50 (ng/ml):", min = 1, max = 1000, value = 100, step = 10))),
                                      
                                      #---------------------------------------------- Input your data (Optional) ------------------------------------------------ 
                                      box(width = NULL,
                                          id = "box3",
                                          title = actionLink("titleID3",span(icon("upload"),span("STEP 4: Input your data (Optional)",style = "font-weight:bold"))),
                                          collapsible = TRUE,collapsed = TRUE,
                                          status = "primary",
                                          solidHeader = TRUE,
                                          
                                          textInput("inputname","Drug name (optional):",placeholder = "Enter drug name here"),
                                          fileInput("file1","Input your dataset (.xls, .xlsx, .csv):",
                                                    accept = c(".xls",
                                                               ".csv",
                                                               ".xlsx")),
                                          actionButton("template","Dataset Template",icon = icon("table"))
                                         )
                               ),
                                column(width = 4,
                                       
                                       #------------------------------- PK -------------------------------------
                                       box(width = NULL, 
                                           id = "box5", collapsible = TRUE, 
                                           plotOutput("PK",height="400px"), 
                                           title = actionLink("titleID5",span(icon("prescription-bottle-alt"),span("PK - Pharmacokinetics",style = "font-weight:bold"))), 
                                           status = "primary", solidHeader = TRUE),
                                       
                                       #------------------------------- CO --------------------------------------
                                       box(width = NULL, 
                                           id = "box6", collapsible = TRUE, 
                                           plotOutput("CO",height="400px"),
                                           title = actionLink("titleID6",span(icon("tint"),span("CO - Cardiac Output",style = "font-weight:bold"))), 
                                           status = "primary", solidHeader = TRUE)
                                       ),
                                column(width = 4,
                                       
                                       #------------------------------- HR --------------------------------------
                                       box(width = NULL, 
                                           id = "box7", collapsible = TRUE, 
                                           plotOutput("HR",height="400px"),
                                           title = actionLink("titleID7",span(icon("heartbeat"),span("HR - Heart Rate",style = "font-weight:bold"))), 
                                           status = "primary", solidHeader = TRUE),
                                       
                                       #------------------------------- MAP --------------------------------------
                                       box(width = NULL, 
                                           id = "box8", collapsible = TRUE, 
                                           plotOutput("MAP",height="400px"), 
                                           title = actionLink("titleID8",span(icon("bolt"),span("MAP - Mean Arterial Pressure", style = "font-weight:bold"))), 
                                           status = "primary", solidHeader = TRUE)
                                       ),
                               conditionalPanel(
                                 condition = "input.drugname !='' | input.cmt !=''",
                                 column(width = 8,
                                        box(width = NULL,
                                            id = "box4",
                                            title = actionLink("titleID4",span(icon("list"),span("Parameters",style = "font-weight:bold"))),
                                            collapsible = TRUE, collapsed = TRUE,
                                            status = "primary",
                                            solidHeader = TRUE,
                                            column(width = 6,
                                              conditionalPanel(condition = "input.drugname !=''",
                                                               fluidRow(align = "center",span("Parameters for Reference Drug",style = "font-weight:bold;font-style:italic;font-size:18px;color:grey;")),
                                                               uiOutput("parameters2"))
                                                               ),
                                            column(width = 6, 
                                                   conditionalPanel(condition = "input.cmt != ''",
                                                             fluidRow(align = "center",span("Parameters for Investigational Drug",style = "font-weight:bold;font-style:italic;font-size:18px;color:grey;")),
                                                             uiOutput("parameters1"))
                                                             ))))
                               ),
                      
                      #--------------------------------------------- The Bottom ------------------------------------------
                      fluidRow(align = "center",
                               span(tags$a(href = "https://github.com/vanhasseltlab/hemodynamic-simulator","Version 1.0.4",target = "_blank"),
                                    ", Made by",
                                    tags$a(href="mailto:y.fu@lacdr.leidenuniv.nl", "Yu Fu"),
                                    ", ",
                                    tags$a(href="https://www.universiteitleiden.nl/en/staffmembers/coen-van-hasselt#tab-1",target="_blank", "J.G.C. van Hasselt"),
                                    style = "font-size:18px;font-style: italic"),
                               HTML("<br><b>DISCLAIMER:</b><br>
                                      The use of any result generated by the Hemodynamic Simulator is in any case the sole risk and responsibility of the user.<br>
                                      Although we have carefully validated this application, there is no guarantee for the accuracy of the provided results.
                               ")),
                      fluidRow(align = "center",
                               img(src = "LU_logo.png", height = 120),
                               img(src = "LACDR_logo.png",height = 80),
                               img(src = "imi_logo.png",height = 80),
                               img(src = "transQST_logo.png",height = 100))
)

ui <- dashboardPage(skin="blue",
      dashboardHeader(title = "Hemodynamic simulator",
                      tags$li(class = "dropdown",
                              actionBttn("modelinfo",
                                         icon = icon("info-circle"),
                                         style = "bordered",size = "sm"),
                              style = "padding-top:8px; padding-bottom:8px;padding-right:8px"),
                      tags$li(class = "dropdown",
                              dropdown(icon = icon("cog"),
                                       style = "bordered",size = "sm",
                                       tooltip = tooltipOptions(placement = "bottom",title = "Click here to change units!"),
                                   awesomeRadio("timeunit","Time Unit:",choices = c("hour","day","week"), selected = "hour", inline = TRUE),
                                   awesomeRadio("concunit","Conc. Unit:",choices = c("mg/ml","ug/ml","ng/ml"), selected = "ng/ml", inline = TRUE)
                                   ),
                              style = "padding-top:8px; padding-bottom:8px;padding-right:8px"),
                      tags$li(class = "dropdown", downloadBttn("report", 
                                                               span("Generate Report",style = "font-weight:bold;color:#fff"),
                                                               size = "sm",style = "bordered"),
                              style = "padding-top:8px; padding-bottom:8px;padding-right:10px"),
                              
                      titleWidth = "500px"),
      dashboardSidebar(disable = TRUE),
      body
)

