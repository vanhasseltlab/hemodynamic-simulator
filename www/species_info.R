#--------------------------------- species information --------------------------
if (input$specie == "Rat"){
  if (input$rattype == "spontaneously hypertensive rats (SHR)"){
    info1 <- "<b>spontaneously hypertensive rats (SHR)</b><br><br>
              BSL_HR_SHR = 310 beats/min <br>
              BSL_MAP_SHR = 155 mmHg <br>
              BSL_CO_SHR = 69 ml/min <br>
              k<sub>out_HR</sub> = 11.6 h<sup>-1</sup> <br>
              k<sub>out_SV</sub> = 0.126 h<sup>-1</sup> <br>
              k<sub>out_TPR</sub> = 3.58 h<sup>-1</sup> <br>
              FB = 0.0029 mmHg<sup>-1</sup> <br>
              HR_SV = 0.312 <br>
              hor<sub>HR</sub> = 8.73 h <br>
              amp<sub>HR</sub> = 0.0918 <br>
              hor<sub>TPR</sub> = 19.3 h <br>
              amp<sub>TPR</sub> = 0.0918 <br><br>
              <a href='https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4253457/' target='_blank'>[1] Snelder, N. et al. Br J Pharmacol (2014).</a>"
  }
  if (input$rattype == "normotensive Wistar-Kyoto rats (WKY)"){
    info1 <- "<b>normotensive Wistar-Kyoto rats (WKY)</b><br><br>
              BSL_HR_WKY = 323 beats/min <br>
              BSL_MAP_WKY = 102 mmHg <br>
              BSL_CO_WKY = 129 ml/min <br>
              k<sub>out_HR</sub> = 11.6 h<sup>-1</sup> <br>
              k<sub>out_SV</sub> = 0.126 h<sup>-1</sup> <br>
              k<sub>out_TPR</sub> = 3.58 h<sup>-1</sup> <br>
              FB = 0.0029 mmHg<sup>-1</sup> <br>
              HR_SV = 0.312 <br>
              hor<sub>HR</sub> = 8.73 h <br>
              amp<sub>HR</sub> = 0.0918 <br>
              hor<sub>TPR</sub> = 19.3 h <br>
              amp<sub>TPR</sub> = 0.0918<br><br>
              <a href='https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4253457/' target='_blank'>[1] Snelder, N. et al. Br J Pharmacol (2014).</a>"
  }
}else {
  info1 <- "<b>Beagle Dog</b><br><br>
            BSL_HR = 79.7 beats/min <br>
            BSL_MAP = 110 mmHg <br>
            BSL_CO = 1450 ml/min <br>
            k<sub>out_HR</sub> = 10 h<sup>-1</sup> <br>
            k<sub>out_SV</sub> = 10 h<sup>-1</sup> <br>
            k<sub>out_TPR</sub> = 10 h<sup>-1</sup> <br>
            FB = 0.0029 mmHg<sup>-1</sup> <br>
            HR_SV = 0.312 <br>
            hor<sub>HR</sub> = 8.73 h <br>
            amp<sub>HR</sub> = 0.0918 <br>
            hor<sub>TPR</sub> = 19.3 h <br>
            amp<sub>TPR</sub> = 0.0918<br><br>
            <a href='https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4253457/' target='_blank'>[1] Snelder, N. et al. Br J Pharmacol (2014).</a><br>
            <a href='https://www.page-meeting.org/?abstract=5953#' target='_blank'>[2] Venkatasubramanian, R. et al. PAGE Poster (2016).</a>"
}


