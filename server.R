#--------------------------------------------------------------------------------------------------------------
#   This application was developed based on Snelder's cardiovascular model.
#
#   Yu Fu
#   March 6th, 2019
#--------------------------------------------------------------------------------------------------------------

library(shiny)
library(shinydashboard)
library(RxODE)
library(ggplot2)
library(rmarkdown)
library(gdata)
library(tools)


server <- function(input, output){
  #-------- collapse box header ----------
  source("www/collapse_box.R", local = TRUE)

  r <- reactive({
    
    #------- Plotting Progress Bar-------
    withProgress(message = 'Plotting in progress',
                 detail = 'This may take a while...', value = 0, {
                   
    theta1 <- NULL
    theta2 <- NULL
    info1 <- NULL
    info2 <- NULL
    
    pd <- "
    C = A/V1;
    CR_HR = amp_HR*cos(pi*(time+hor_HR)/12)*CR;
    CR_TPR = amp_TPR*cos(pi*(time+hor_TPR)/12)*CR;
    EFF1 = EMAX_1*C/(EC50_1+C);
    EFF2 = EMAX_2*C/(EC50_2+C);
    EFF3 = EMAX_3*C/(EC50_3+C);
    d/dt(HR) = KIN_HR*(1-FB*HR*SV1*(1-HR_SV*log(HR/BSL_HR))*TPR)*(1+CR_HR)*(1+EFF1)-KOUT_HR*HR;
    d/dt(SV1) = KIN_SV*(1-FB*HR*SV1*(1-HR_SV*log(HR/BSL_HR))*TPR)*(1+EFF2)-KOUT_SV*SV1;
    d/dt(TPR) = KIN_TPR*(1-FB*HR*SV1*(1-HR_SV*log(HR/BSL_HR))*TPR)*(1+CR_TPR)*(1+EFF3)-KOUT_TPR*TPR;
    CO = HR*SV1*(1-HR_SV*log(HR/BSL_HR));
    MAP = HR*SV1*(1-HR_SV*log(HR/BSL_HR))*TPR;"
    
    SLpd <-"
    C = A/V1;
    CR_HR = amp_HR*cos(pi*(time+hor_HR)/12)*CR;
    CR_TPR = amp_TPR*cos(pi*(time+hor_TPR)/12)*CR;
    SLOPE1 = SL1*C**POW;
    SLOPE2 = SL2*C**POW;
    SLOPE3 = SL3*C**POW;
    d/dt(HR) = KIN_HR*(1-FB*HR*SV1*(1-HR_SV*log(HR/BSL_HR))*TPR)*(1+CR_HR)*(1+SLOPE1)-KOUT_HR*HR;
    d/dt(SV1) = KIN_SV*(1-FB*HR*SV1*(1-HR_SV*log(HR/BSL_HR))*TPR)*(1+SLOPE2)-KOUT_SV*SV1;
    d/dt(TPR) = KIN_TPR*(1-FB*HR*SV1*(1-HR_SV*log(HR/BSL_HR))*TPR)*(1+CR_TPR)*(1+SLOPE3)-KOUT_TPR*TPR;
    CO = HR*SV1*(1-HR_SV*log(HR/BSL_HR));
    MAP = HR*SV1*(1-HR_SV*log(HR/BSL_HR))*TPR;"
    
    #--------------------- initial values ----------------------------------
    
    inits1 <- c(C = 0,
               HR  = 310, # bpm
               SV1  = 69/310, # mL / beat
               TPR = 155/69 # mmHg/mL *min
    )
    inits2 <- c(C = 0,
                HR  = 323, # bpm
                SV1  = 129/323, # mL / beat
                TPR = 102/129 # mmHg/mL *min
    )
    if (input$specie == "Rat") {
      inits <- switch(input$rattype, "spontaneously hypertensive rats (SHR)" = inits1, "normotensive Wistar-Kyoto rats (WKY)" = inits2)
    } else {
      inits <- c(C = 0,
                 HR = 79.7,
                 SV1 = 1450/79.7,
                 TPR = 110/1450)
    }
    #-------------- Mode of Action ----------------------
    
    EMAX_1 = 0
    EMAX_2 = 0
    EMAX_3 = 0
    
    if (input$mode == "Heart Rate") {EMAX_1 = input$emax}
    if (input$mode == "Stroke Volume") {EMAX_2 = input$emax}
    if (input$mode == "Total Peripheral Resistance"){EMAX_3 = input$emax}
    
    #----------------- Circadian Rhythm Switch ----------------------------
    
    CR <- 0
    
    if (input$cr){
      CR <- 1
    }
    
    #------------------ Other Parameters ----------------------------------
    if (input$specie == "Rat"){
    kin1 <- c(BSL_HR = 310,
              KIN_HR = 11.6*310/(1-0.0029*155),
              KIN_SV = 0.126*69/310/(1-0.0029*155),
              KIN_TPR = 3.58*155/69/(1-0.0029*155))
    kin2 <- c(BSL_HR = 323,
              KIN_HR = 11.6*323/(1-0.0029*102),
              KIN_SV = 0.126*129/323/(1-0.0029*102),
              KIN_TPR = 3.58*102/129/(1-0.0029*102))
    
    kin <- switch(input$rattype, "spontaneously hypertensive rats (SHR)" = kin1, "normotensive Wistar-Kyoto rats (WKY)" = kin2)
    
    others <- c(kin,c(
                      FB = 0.0029,    # 1*mmHg-1
                      KOUT_HR = 11.6,  #h-1
                      KOUT_SV = 0.126, #h-1
                      KOUT_TPR = 3.58, #h-1
                      HR_SV = 0.312,
                      hor_HR = 8.73,  #h
                      amp_HR = 0.0918,
                      hor_TPR = 19.3, #h
                      amp_TPR = 0.0918,
                      CR = CR))
    } else {
      others <- c(BSL_HR = 79.7,
                  KIN_HR = 10*79.7/(1-0.0029*110),
                  KIN_SV = 10*1450/79.7/(1-0.0029*110),
                  KIN_TPR = 10*110/1450/(1-0.0029*110),
                  FB = 0.0029,    # 1*mmHg-1
                  KOUT_HR = 10,  #h-1
                  KOUT_SV = 10, #h-1
                  KOUT_TPR = 10, #h-1
                  HR_SV = 0.312,
                  hor_HR = 8.73,  #h
                  amp_HR = 0.0918,
                  hor_TPR = 19.3, #h
                  amp_TPR = 0.0918,
                  CR = CR)
    }
    
    others1 <- c(others,c(EMAX_1=EMAX_1,
                          EC50_1=1000,    #ng mL-1
                          EMAX_2=EMAX_2,
                          EC50_2=1000,    #ng mL-1
                          EMAX_3=EMAX_3,
                          EC50_3=input$ec50    #ng mL-1
                          ))

    source("www/event.R",local = TRUE)
    
    
    #------------------------ Model equations --------------------------
    
    if (input$cmt !="") {
           if (input$cmt == "one-compartmental"){
             pk1 <- "d/dt(A) = -k10*A;"
             pkparams1 <- c(V1=input$V1*1000,
                            k10=input$k10)
           }
           if (input$cmt == "two-compartmental"){
             pk1 <- "d/dt(A) = -(k10 + k12)*A + k21*P1;
                     d/dt(P1) = -k21*P1 + k12*A;"
             pkparams1 <- c(V1=input$V1*1000,
                            k10=input$k10, 
                            k12=input$k12,
                            k21=input$k21)
           }
           if (input$cmt == "three-compartmental"){
             pk1 <- "d/dt(A)  = -(k10 + k12 + k13)*A + k21*P1 +k31*P2;
                     d/dt(P1) = -k21*P1 + k12*A;
                     d/dt(P2) = -k31*P1 + k13*A;"
             pkparams1 <- c(V1=input$V1*1000,
                            k10=input$k10, 
                            k12=input$k12,
                            k13=input$k13,
                            k21=input$k21,
                            k31=input$k31)
           }
      theta1 <- c(others1, pkparams1)
      pkpd1 <- paste(pk1,pd)
      m1 <- RxODE(pkpd1)
      x1 <- solve(m1,theta1,ev1,inits)}
    
    incProgress(1/3)

      #---------------- Reference Drug --------------------  
    
        #-------------------------- match drug name --------------------------------------
        if ((input$plotswitch == TRUE) & (input$drugname !="")){
          
        if (input$drugname == "Amiloride"){
          pk2 <- "d/dt(D) = -F1*ka*D;
                  d/dt(L) =  F1*ka*D -klc*L + kcl*A - kle*L;
                  d/dt(A) =           klc*L - kcl*A - kcp*A + kpc*P - kce*A;
                  d/dt(P) =                           kcp*A - kpc*P;"
          pkpd2 <- paste(pk2,pd)
          pkparams2 <- c(ka = 0.086,
                         klc = 0.491,
                         kcl = 0.563,
                         kcp = 0.290,
                         kpc = 0.017,
                         kle = 7.069,
                         kce = 0.042,
                         V1 = 0.202*1000,
                         F1 = 0.9887)
          effparams <- c(EMAX_1=0,
                         EC50_1=1000,    #ng mL-1
                         EMAX_2=-1,
                         EC50_2=245,    #ng mL-1
                         EMAX_3=0,
                         EC50_3=1000)    #ng mL-1
        }
        
        if (input$drugname == "Amlodipine"){
          pk2 <- "d/dt(D) = -ka*D;
                  d/dt(A) =  ka*D -k10*A;"
          pkpd2 <- paste(pk2,pd)
          pkparams2 <- c(ka = 0.4, V1 = 32*1000,k10 = 0.23)
          effparams <- c(EMAX_1=0,
                         EC50_1=1000,    #ng mL-1
                         EMAX_2=0,
                         EC50_2=1000,    #ng mL-1
                         EMAX_3=-1,
                         EC50_3=82.8)    #ng mL-1
        }
        
        if (input$drugname == "Atropine"){
          pk2 <- "d/dt(A) = -k12*A + k21*P - k10*A;
                  d/dt(P) =  k12*A - k21*P;"
          pkpd2 <- paste(pk2,SLpd)
          pkparams2 <- c(V1 = 3.506/0.325*1000, k10 = 0.043*60, k12 = 0.154*60, k21 = 0.082*60)
          effparams <-c(SL1 = 0.00149, SL2 = 0, SL3 = 0, POW = 1)    #(ng/ml)-1
        }
        
        if (input$drugname == "Enalapril"){
          pk2 <- "d/dt(D) = -F1*ka*D
                  d/dt(A) =  F1*ka*D - VM*A/(KM + A/V1) - k12*A + k21*P;
                  d/dt(P) =                               k12*A - k21*P;"
          pkparams2 <- c(VM = 767*1000, V1 = 0.346*1000, k12 = 1.56, k21 = 2.94, KM = 150*1000, ka = 1.75, F1 = 0.376)
          pkpd2 <- paste(pk2,pd)
          effparams <-c(EMAX_1=0,
                        EC50_1=1000,    #ng mL-1
                        EMAX_2=-1,
                        EC50_2=1200,    #ng mL-1
                        EMAX_3=-1,
                        EC50_3=1200)    #ng mL-1
        }
        
        if (input$drugname == "Fasudil"){
          pk2 <- "d/dt(A) = -k10*A;"
          pkpd2 <- paste(pk2,pd)
          pkparams2 <- c(V1 = 22.92*1000, k10 = 4.62)
          effparams <-c(EMAX_1=0,
                        EC50_1=1000,    #ng mL-1
                        EMAX_2=0,
                        EC50_2=1000,    #ng mL-1
                        EMAX_3=-1,
                        EC50_3=0.172)    #ng mL-1
        }
        
        if (input$drugname == "Hydrochlorothiazide(HCTZ)"){
          pk2 <- "d/dt(D) = -F1*ka*D;
                  d/dt(A) =  F1*ka*D - k10*A;"
          pkpd2 <- paste(pk2,pd)
          pkparams2 <- c(V1 = 0.0168*1000, k10 = 0.079, ka = 0.563, F1 = 0.007)
          effparams <-c(EMAX_1=0,
                        EC50_1=1000,    #ng mL-1
                        EMAX_2=-1,
                        EC50_2=28900,    #ng mL-1
                        EMAX_3=0,
                        EC50_3=1000)    #ng mL-1
        }
        
        if (input$drugname == "Prazosin"){
          pk2 <- "d/dt(A) = -k10*A;"
          pkpd2 <- paste(pk2,SLpd)
          pkparams2 <- c(V1 = 14*2.8*1000,k10 = (0.0927*60/14)*(0.3/2.8)**(-0.25))
          effparams <-c(SL1 = 0, SL2 = 0, SL3 = 0.328, POW = 0.0910)    #ng mL-1
        }
        
        theta2 <- c(others, pkparams2,effparams)
        m2 <- RxODE(pkpd2)
        x2 <- solve(m2,theta2,ev2,inits)
        }
    
    incProgress(1/3)
    
    #-------------------------------- time unit ---------------------------------------
    
    tu <- switch(input$timeunit, hour = 1, day = 24, week = 24*7)
    
    #----------------- plot setting ----------------------      
    pl <- ggplot()+
      theme_bw()+
      xlab(paste0("Time (",input$timeunit,")"))
    
    #-------------------------------------- plotting ---------------------------------------------
    
    File <- input$file1
    
    pklab <- paste0('Concentration (',input$concunit,')')
    
    cu <- switch(input$concunit, 'mg/ml' = 10^6, 'ug/ml' = 10^3, 'ng/ml' = 1) 
    
    pk <- pl + ylab(pklab)
    hr <- pl + ylab('Heart Rate (bpm)')
    co <- pl + ylab('Cardiac Output (ml/min)')
    p  <- pl + ylab('Mean Arterial Pressure (mmHg)')
    
    if ((input$plotswitch == FALSE | input$drugname == "") & input$cmt =="" & is.null(File) ){

      pk <- pk + xlim (0,100) + ylim (0,100)
      hr <- hr + xlim (0,100) + ylim (0,100)
      co <- co + xlim (0,100) + ylim (0,100)
      p  <- p + xlim (0,100) + ylim (0,100)
      
    } else{
      
      vc <- c("#001158","#f46e32","#00ad4f")
      names(vc) <- c("x","r","i")
      #------------------- drug name ----------------
      if (input$IDname == ""){
        idname <- "Investigational Drug"
      } else{
        idname <- input$IDname
      }
      
      if (input$inputname == ""){
        inputname <- "Input dataset"
      } else{
        inputname <- input$inputname
      }
      
      lc <- c(idname,input$drugname,inputname)
      names(lc) <- c("x","r","i")
      vdisp1 <- rep(FALSE,3)
      vdisp2 <- rep(FALSE,3)
      vdisp3 <- rep(FALSE,3)
      vdisp4 <- rep(FALSE,3)
      
      if (input$cmt != "") {
        pk <- pk + geom_line(data = x1, aes(x = time/tu, y = C/cu,color = "x"), size = 1)
        hr <- hr + geom_line(data = x1, aes(x = time/tu, y = HR,  color = "x"), size = 1)
        co <- co + geom_line(data = x1, aes(x = time/tu, y = CO,  color = "x"), size = 1)
        p  <- p  + geom_line(data = x1, aes(x = time/tu, y = MAP, color = "x"), size = 1)
        vdisp1[1] <- TRUE
        vdisp2[1] <- TRUE
        vdisp3[1] <- TRUE
        vdisp4[1] <- TRUE
      }
      if ((input$plotswitch == TRUE) & (input$drugname != "")) {
        pk <- pk + geom_line(data = x2, aes(x = time/tu, y = C/cu,color = "r"), size = 1)
        hr <- hr + geom_line(data = x2, aes(x = time/tu, y = HR,  color = "r"), size = 1)
        co <- co + geom_line(data = x2, aes(x = time/tu, y = CO,  color = "r"), size = 1)
        p  <- p  + geom_line(data = x2, aes(x = time/tu, y = MAP, color = "r"), size = 1)
        vdisp1[2] <- TRUE
        vdisp2[2] <- TRUE
        vdisp3[2] <- TRUE
        vdisp4[2] <- TRUE
      }
      if (is.null(File) == FALSE) {
        if (file_ext(File$name) %in% c("xls","xlsx")) {
          file1 <- read.xls(File$datapath)
        }
        if (file_ext(File$name) == "csv") {
          file1 <- read.csv2(File$datapath)
        }
        
        if ("PK" %in% colnames(file1)) {
          pk <- pk + geom_point(data = file1, aes(x = time,y = PK, color = "i"),size = 2) +
            geom_line(data = file1, aes(x = time,y = PK, color = "i"),size = 1)
          vdisp1[3] <- TRUE
          }
        if ("HR" %in% colnames(file1)) {
          hr <- hr + geom_point(data = file1, aes(x = time,y = HR, color = "i"),size = 2) +
            geom_line(data = file1, aes(x = time,y = HR, color = "i"),size = 1)
          vdisp2[3] <- TRUE
          }
        if ("CO" %in% colnames(file1)) {
          co <- co + geom_point(data = file1, aes(x = time, y = CO, color = "i"),size = 2) +
            geom_line(data = file1, aes(x = time,y = CO, color = "i"),size = 1)
          vdisp3[3] <- TRUE
          }
        if ("MAP" %in% colnames(file1)) {
          p  <- p  + geom_point(data = file1, aes(x = time, y = MAP, color = "i"),size = 2) +
            geom_line(data = file1, aes(x = time, y = MAP, color = "i"),size = 1)
          vdisp4[3] <- TRUE
        }
      }
      pk <- pk + scale_colour_manual(values = vc[vdisp1], labels = lc[vdisp1])
      hr <- hr + scale_colour_manual(values = vc[vdisp2], labels = lc[vdisp2])
      co <- co + scale_colour_manual(values = vc[vdisp3], labels = lc[vdisp3])
      p  <- p  + scale_colour_manual(values = vc[vdisp4], labels = lc[vdisp4])
    }
    #--------------------------------- species information --------------------------
    source("www/species_info.R",local = TRUE)
    
    #--------------------------------- drug information -----------------------------
    source("www/drug_info.R",local = TRUE)
    
    incProgress(1/3)
                 })
 
    return(list(pk = pk, hr = hr, co = co, p = p, theta1 = theta1, theta2 = theta2,info1 = info1, info2 = info2))
  })
  
  #---------------------------- plot setting ----------------------------------
  
  axisset1 <- theme(axis.title.x=element_text(face='bold',size=15),
                   axis.title.y=element_text(face='bold',size=15),
                   axis.text.x=element_text(face='bold',size=10,color='black'),
                   axis.text.y=element_text(face='bold',size=10,color='black'))+
              theme(legend.justification=c(1,1), legend.position=c(0.9,0.9), legend.title=element_blank())
  
  #--------------------------------------- Plots -------------------------------
  
  output$PK <- renderPlot({
    if(is.null(r()$pk)){
      return(NULL)
    }else{
      r()$pk + axisset1
    }
    })

  output$HR<- renderPlot({
    if(is.null(r()$hr)){
      return(NULL)
    }else{
      r()$hr + axisset1
    }
  })
  
  output$CO <- renderPlot({
    if(is.null(r()$co)){
      return(NULL)
    }else{
      r()$co + axisset1
    }
  })

  
  output$MAP <- renderPlot({
    if(is.null(r()$p)){
      return(NULL)
    }else{
      r()$p + axisset1
    }
  })

  
  observeEvent(input$info1, {
    showModal(modalDialog(
      title = span("Species Information",style = "font-weight:bold"),
      renderUI(HTML(r()$info1))
    ))
  })
  
  observeEvent(input$info2, {
    showModal(modalDialog(
      title = span("Drug Information",style = "font-weight:bold"),
      renderUI({HTML(r()$info2)})
    ))
  })
  
  template <- data.frame(time = seq(0,120,12),
                         PK = c(0,12,6,3,1.5,0.75,0.3,0.15,0.1,0.05,0.02),
                         HR = c(310,305,307,308,309,308,308.5,309,309.4,309.3,309.7),
                         CO = c(69,72,70.5,70.4,70,69.5,69.4,69.5,69.2,69,69.1),
                         MAP = c(155,158,157,156.5,156.4,156,156.1,155.5,155.3,155,155.1))
  
  observeEvent(input$template, {
    showModal(modalDialog(
      title = span("Please follow this template.",style = "font-weight:bold"),
      renderTable(template),
      downloadButton("dtemplate","Download this template")
    ))})
  
  output$dtemplate <- downloadHandler(
    filename = "data_template.csv",
    content = function(file) {
      write.csv2(template, file, row.names = FALSE)
    }
  )
  observeEvent(input$modelinfo,{
    showModal(modalDialog(
      title = span("Model information",style = "font-weight:bold"),
      tags$img(src = "model.png",style = "display:block;max-width:80%;max-height:80%;width:auto;height:auto;
                                                                        margin-left:auto;margin-right:auto;margin-bottom:auto;margin-top:auto"),
      # open link in a new window :add argument target = "_blank" 
      span(tags$a(href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4253457/",target="_blank", 
                  "[1] Snelder, N. et al. Br J Pharmacol (2014)."),
           style = "font-size:16px;font-style: italic;") 
    ))
  })
  output$parameters1 <- renderUI({
    HTML(r()$info1,paste("<br>Emax =",input$emax,"<br>"),paste("EC50 =",input$ec50," ng/ml"))
  })
  
  output$parameters2 <- renderUI({
    HTML(r()$info2)
  })
  
  output$report <- downloadHandler(
    filename = "hemodynamic_simulator_report.pdf",
    content = function(file) {
      
      #------------ Generating Report Progress bar -------------
      withProgress(message = 'Generating Report',
                   detail = 'This may take a while...',
                   value = 0, {
      
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      incProgress(1/3)
      
      # Set up parameters to pass to Rmd document
      params <- list(theta1 = r()$theta1,
                     theta2 = r()$theta2,
                     pk = r()$pk,
                     hr = r()$hr,
                     co = r()$co,
                     p = r()$p)
      incProgress(1/3)
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
      incProgress(1/3)
      
      })
    }
  )

}
