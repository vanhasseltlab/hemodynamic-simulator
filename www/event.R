#-------------------------------- amount unit ------------------------------------

amtfun <- function(unit,amt){
  switch(unit,'mg/kg' = amt * 10^6, 'ug/kg' = amt * 10^3, 'ng/kg' = amt)
}

#---------------------------------- dose event ------------------------------------------------
amount1_1 <- amtfun(input$amountunit,input$amt1_1)

ev1 <- eventTable()
ev1$add.dosing(dose = amount1_1)
ev1$add.sampling(seq(0,input$ii1*5,0.1))

if (input$nodoselvl1 >= 2) {
  starttime <- input$ii1
  amount1_2 <- amtfun(input$amountunit,input$amt1_2)
  ev1$add.dosing(dose = amount1_2, start.time = starttime)
  if (input$nodoselvl1 >= 3) {
    starttime <- starttime + input$ii1
    amount1_3 <- amtfun(input$amountunit,input$amt1_3)
    ev1$add.dosing(dose = amount1_3, start.time = starttime)
    if (input$nodoselvl1 >= 4) {
      starttime <- starttime + input$ii1
      amount1_4 <- amtfun(input$amountunit,input$amt1_4)
      ev1$add.dosing(dose = amount1_4, start.time = starttime)
      if (input$nodoselvl1 == 5) {
        starttime <- starttime + input$ii1
        amount1_5 <- amtfun(input$amountunit,input$amt1_5)
        ev1$add.dosing(dose = amount1_5, start.time = starttime)
      }
    }
  }
} 

#---------------------------------- dose event 2------------------------------------------------
amount2_1 <- amtfun(input$amountunit2,input$amt2_1)

ev2 <- eventTable()
ev2$add.dosing(dose = amount2_1)
ev2$add.sampling(seq(0,input$ii2*5,0.1))

if (input$nodoselvl2 >= 2) {
  starttime <- input$ii2
  amount2_2 <- amtfun(input$amountunit2,input$amt2_2)
  ev2$add.dosing(dose = amount2_2, start.time = starttime)
  if (input$nodoselvl2 >= 3) {
    starttime <- starttime + input$ii2
    amount2_3 <- amtfun(input$amountunit2,input$amt2_3)
    ev2$add.dosing(dose = amount2_3, start.time = starttime)
    if (input$nodoselvl2 >= 4) {
      starttime <- starttime + input$ii2
      amount2_4 <- amtfun(input$amountunit2,input$amt2_4)
      ev2$add.dosing(dose = amount2_4, start.time = starttime)
      if (input$nodoselvl2 == 5) {
        starttime <- starttime + input$ii2
        amount2_5 <- amtfun(input$amountunit2,input$amt2_5)
        ev2$add.dosing(dose = amount2_5, start.time = starttime)
      }
    }
  }
} 
