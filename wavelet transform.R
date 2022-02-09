#Codes to replicate the continuous wavelet transform and the global wavelet
#analysis shown in Grande et al., 2022. Tidal frequencies and quasiperiodic subsurface water level variations dominate redox dynamics in a salt marsh system

#notice that all the data used by Grande el al., 2022 is publically available through the ESS-Drive repository (link in the paper)
#here I have added only one file to use as an example

#call your data
data <- read.csv("data.csv")
head(data)


#DateTime --> contains date and time (at 1h intervals) m/d/y h:m
#mV.30 --> contains the Eh for the 30cm depth (In this case, for a low marsh position)

#The function below calculates the cwt using the biwavelet package,
#the global wavelet, the 0.95 significance level and plots both results
#df is a data frame [n,2] where x = timestep and y = values
wavelets <- function(df){
  #Load the required libraries
  #install.package('biwavelet')
  #install.package('lubridate')
  
  library(biwavelet)
  library(lubridate)
  
  data <- df
  #convert to date
  data$DateTime <- mdy_hm(data$DateTime) #you might have to check your date time format if you get an error. ?lubridate
  
  #the data has already been cleaned by the author,
  #we can just run the continuous wavelet transform
  cwt <- wt(data, dt = 1)
  
  #Calculate the global wavelet transform
  global_wt <- cwt$sigma2 * (rowSums(cwt$signif)/length(data))
  
  
  #calculate the 95% significance level of the global wavelet
  #because the scales in the above-calculated cwt are in date time format,
  #I prefere to recalculate the values as numeric for the significance level
  data1 <- data.frame(x = as.numeric(data$DateTime), y = data$mV.30)
  cwt1 <- wt(data1, dt = 1)
  sig_95 <- wt.sig(data1, sig.level = 0.95, scale = cwt1$scale, dt = 1, sigma2 = cwt1$sigma2)
  
  
  
  #Plot the data for visualization 
  #this is the color scale used by Grande et al., 2020
  col <- c("azure", "gray","springgreen3", "dodgerblue")
  
  layout(mat = matrix(c(1,1,1,1,2,2), nrow = 2))
  par(mar = c(7,4,2,1))
  #plot the cwt
  plot(cwt, xaxt = "n", xlab = "", ylab = "Period [hours]", lwd.sig = 0.3, col.coi = "grey40",# plot.cb = TRUE, legend.horiz = TRUE
       fill.cols = col, alpha.coi = 1)
  t <- data$DateTime
  xaxis <- seq(min(t), max(t), length.out = 12)
  xaxis <- round_date(xaxis, unit = "day")
  xaxis1 <- month(xaxis, label = T, abbr = T)
  axis(1, at = xaxis, labels = paste0(xaxis1))
  
  mtext("Wavelet Power Spectrum", side = 3, line = 0.5)
  
  
  #plot the global wavelet
  period <- cwt$period
  plot(global_wt, period, type = "l", log = "y", ylab = "", 
       ylim = rev(range(period)), yaxt = "n",
       xlab = expression("Power (mV"^2*")"))
  lines(sig_95$fft.theor, period, lty = 2, col = "red")
  mtext("Global Wavelet", side = 3, line = 0.5)
  
}

#run the function
wavelets(df = data)
