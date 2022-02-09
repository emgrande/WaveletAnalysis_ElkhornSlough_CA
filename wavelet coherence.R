
#Codes to replicate the continuous wavelet transform and the global wavelet
#analysis shown in Grande et al., 2022. Tidal frequencies and quasiperiodic subsurface water level variations dominate redox dynamics in a salt marsh system

#the following function takes two df [n,2] where x = time step and y = values; calculates and plots
#the wavelet coherence between the two signals
wavelet_coherence <- function(wl, Eh){
  #Eh data
  
  Eh$DateTime <- lubridate::mdy_hm(Eh$DateTime)
  
  #wl data
  
  wl$DateTime <- lubridate::mdy_hm(wl$DateTime)
  
  wav_coherence <- biwavelet::wtc(wl, Eh)
  
  #plot the data
  col <- c("azure", "gray","springgreen3", "dodgerblue")
  
  par(oma = c(0, 0, 0, 1), mar = c(2, 4, 2, 5) + 0.1)
  par(mfrow = c(2,1))
  
  plot(wav_coherence, plot.phase = TRUE, lty.coi = 1, col.coi = "grey40", lwd.coi = 1, 
       lwd.sig = 0.5, ylab = "Period [h]", xlab = "", xaxt = "n",  
       plot.cb = TRUE, fill.cols = col)
  t <- wl$DateTime
  xaxis <- seq(min(t), max(t), length.out = 12)
  xaxis <- lubridate::round_date(xaxis, unit = "day")
  xaxis1 <- lubridate::month(xaxis, label = T, abbr = T)
  axis(1, at = xaxis, labels = paste0(xaxis1))
  
  mtext("Power", side = 3,  adj = 0)
  
  col <- c("azure","gray","dodgerblue","grey","azure")
  plot(wav_coherence, plot.phase = TRUE, lty.coi = 1, col.coi = "grey40", lwd.coi = 1, 
       lwd.sig = 0.5, arrow.lwd = 0.03, arrow.len = 0.05, ylab = "Period [h]", xlab = "", xaxt = "n",  
       plot.cb = TRUE, fill.cols = col, type = "phase")
  axis(1, at = xaxis, labels = paste0(xaxis1))
  
  mtext("Phase", side = 3, adj = 0)
  
}


#this example runs the wavelet coherence shown in Grande et al., 2022
#between subsurface water level and Eh at 30 cm depth
#Notice that it is computationally intensive

#Call your datasets
Eh <- read.csv("data.csv")
wl <- read.csv("data_wl.csv")

wavelet_coherence(wl, Eh)

