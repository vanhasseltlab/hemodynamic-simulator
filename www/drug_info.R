info2 <- switch(input$drugname,
                
                "Amiloride" = "<b>Amiloride<br><br>
                <img src='Amiloride.png' width = '200'><br><br>
                PK model:</b><br> Two-compartmental model with liver compartment<br>
                ka = 0.086 h<sup>-1</sup> <br> klc = 0.491 h<sup>-1</sup> <br> kcl = 0.563 h<sup>-1</sup> <br> kcp = 0.290 h<sup>-1</sup> <br> 
                kpc = 0.017 h<sup>-1</sup> <br> kle = 7.069 h<sup>-1</sup> <br> kce = 0.042 h<sup>-1</sup> <br> V1 = 0.202 L/kg <br> F1 = 0.9887<br>
                <br><b> PD model: </b> <br> Diuretic with effect on SV <br>
                Emax model with Emax fixed to 1<br>
                EC50 = 245 ng/ml <br>",
                
                "Amlodipine" = "<b>Amlodipine <br> <br>
                <img src='Amlodipine.png' width = '200'><br><br>
                PK model:</b><br> One-compartmental model<br>
                ka = 0.4 h<sup>-1</sup> <br> V1 = 32 L/kg <br> k10 = 0.23 h<sup>-1</sup> <br>
                <br><b> PD model: </b> <br> Calcium channel blocker with effect on TPR <br>
                Emax model with Emax fixed to 1<br>
                EC50 = 82.8 ng/ml",
                
                "Atropine" = "<b>Atropine <br> <br>
                <img src='Atropine.png' width = '200'><br><br>
                PK model:</b><br> Two-compartmental model<br>
                V1 = 10.79 L/kg <br> k10 = 2.58 h<sup>-1</sup> <br> k12 = 9.24 h<sup>-1</sup><br> k21 = 4.92 h<sup>-1</sup><br>
                <br><b> PD model: </b> <br> M2 receptor antagonist with effect on HR <br>
                linear model <br>
                SL = 0.00149 (ng/ml)<sup>-1</sup>",
                
                "Enalapril" = "<b>Enalapril <br> <br> 
                 <img src='Enalapril.png' width = '200'><br><br>
                 PK model:</b> <br> Two-compartmental model with Michaelis-Menten elimination <br>
                 VM = 767 ug/(ml*h)<br> V1 = 0.346 L/kg <br> k12 = 1.56 h<sup>-1</sup><br> k21 = 2.94 h<sup>-1</sup><br>
                 KM = 150 ug/ml <br> ka = 1.75 h<sup>-1</sup> <br> F1 = 0.376 h<sup>-1</sup> <br>
                 <br><b> PD model: </b> <br> Angiotensin-converting enzyme (ACE) inhibitor with effect on both TPR and SV <br>
                 Emax model with Emax fixed to 1<br>
                 EC50 = 1200 ng/ml",
                
                 "Fasudil" = "<b>Fasudil<br><br>
                 <img src='Fasudil.png' width = '200'><br><br>
                 PK model:</b><br> One-compartmental model <br>
                 V1 = 22.92 L/kg, k10 = 4.62 h<sup>-1</sup> <br>
                 <br><b> PD model: </b> <br> Rho-kinase inhibitor with effect on TPR <br>
                 Emax model with Emax fixed to 1<br>
                 EC50 = 0.172 ng/ml",
                
                 "Hydrochlorothiazide(HCTZ)" = "<b>Hydrochlorothiazide(HCTZ)<br><br>
                 <img src='HCTZ.png' width = '200'><br><br>
                 PK model:</b><br> One-compartmental model <br>
                 V1 = 0.0168 L/kg <br> k10 = 0.079 h<sup>-1</sup> <br> ka = 0.563 h<sup>-1</sup> <br> F1 = 0.007 <br>
                 <br><b> PD model: </b><br> Diuretic with effect on SV <br>
                 Emax model with Emax fixed to 1<br>
                 EC50 = 28900 ng/ml",
                
                 "Prazosin" = "<b>Prazosin<br><br> 
                 <img src='Prazosin.png' width = '200'><br><br>
                 PK model:</b><br> One-compartmental model <br>
                 V1 = 39.2 L/kg <br> k10 = 0.694 h<sup>-1</sup> <br>
                 <br><b> PD model: </b><br> Selective &alpha;<sub>1</sub> adrenergic receptor blocker with effect on TPR <br>
                 Power model<br>
                 SL = 0.328 (ng/ml)<sup>-1</sup> <br>
                 POW = 0.091"
)       