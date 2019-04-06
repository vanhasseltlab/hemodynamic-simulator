# UI for multiple doses with various dose levels
#------------------------------- dose regimen 1 ------------------------------------------
output$doselvl1 <- renderUI({
  conditionalPanel(
    condition = "input.nd > 1",
    pickerInput("nodoselvl1", "Number of dose levels:",choices = c(1,input$nd))
  )
})

output$amtui1 <- renderUI({
  if (input$nd > 1) {
    list(conditionalPanel(
           condition = "input.nodoselvl1 >= 1",
           sliderInput("ii1_1", "Interdose interval_1 (day):", value = 1, min = 0.5, max = 14, step=0.5)
         ),
         conditionalPanel(
           condition = "input.nodoselvl1 >= 2",
           sliderInput("amt1_2","Amount 2:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl1 >= 3",
           sliderInput("ii1_2", "Interdose interval_2 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt1_3","Amount 3:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl1 >= 4",
           sliderInput("ii1_3", "Interdose interval_3 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt1_4","Amount 4:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl1 >= 5",
           sliderInput("ii1_4", "Interdose interval_4 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt1_5","Amount 5:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl1 >= 6",
           sliderInput("ii1_5", "Interdose interval_5 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt1_6","Amount 6:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl1 >= 7",
           sliderInput("ii1_6", "Interdose interval_6 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt1_7","Amount 7:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl1 >= 8",
           sliderInput("ii1_7", "Interdose interval_7 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt1_8","Amount 8:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl1 >= 9",
           sliderInput("ii1_8", "Interdose interval_8 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt1_9","Amount 9:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl1 >= 10",
           sliderInput("ii1_9", "Interdose interval_9 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt1_10","Amount 10:",min = 0, max = 10, value = 1,step = 0.01)
         )
    )
  }
})
#------------------------------ dose regimen 2 ---------------------------------
output$doselvl2 <- renderUI({
  conditionalPanel(
    condition = "input.nd2 > 1",
    pickerInput("nodoselvl2", "Number of dose levels:",choices = c(1,input$nd2))
  )
})

output$amtui2 <- renderUI({
  if (input$nd2 > 1) {
    list(conditionalPanel(
           condition = "input.nodoselvl2 >= 1",
           sliderInput("ii2_1", "Interdose interval_1 (day):", value = 1, min = 0.5, max = 14, step=0.5)
         ),
         conditionalPanel(
           condition = "input.nodoselvl2 >= 2",
           sliderInput("amt2_2","Amount 2:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl2 >= 3",
           sliderInput("ii2_2", "Interdose interval_2 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt2_3","Amount 3:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl2 >= 4",
           sliderInput("ii2_3", "Interdose interval_3 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt2_4","Amount 4:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl2 >= 5",
           sliderInput("ii2_4", "Interdose interval_4 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt2_5","Amount 5:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl2 >= 6",
           sliderInput("ii2_5", "Interdose interval_5 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt2_6","Amount 6:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl2 >= 7",
           sliderInput("ii2_6", "Interdose interval_6 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt2_7","Amount 7:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl2 >= 8",
           sliderInput("ii2_7", "Interdose interval_7 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt2_8","Amount 8:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl2 >= 9",
           sliderInput("ii2_8", "Interdose interval_8 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt2_9","Amount 9:",min = 0, max = 10, value = 1,step = 0.01)
         ),
         conditionalPanel(
           condition = "input.nodoselvl2 >= 10",
           sliderInput("ii2_9", "Interdose interval_9 (day):", value = 1, min = 0.5, max = 14, step=0.5),
           sliderInput("amt2_10","Amount 10:",min = 0, max = 10, value = 1,step = 0.01)
         )
    )
  }
})
