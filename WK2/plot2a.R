
#Initialize variables
#sample size n 
n <- 10 
#nsim is number of samples
nsim <- 1000
#Define lotsa.medians as numeric vector of length nsim
lotsa.medians <- numeric(nsim)
#Create vector x with exponetial random size n and then create a vector lotsa.median with median of vector x
for (i in 1:nsim) {
  x <- rexp(n)
  lotsa.medians[i] <- median(x)
}
summary(lotsa.medians)
mean(lotsa.medians)
hist(lotsa.medians)

n <- 50
#nsim is number of samples
nsim <- 1000
#Define lotsa.medians as numeric vector of length nsim
lotsa.medians <- numeric(nsim)
#Create vector x with exponetial random size n and then create a vector lotsa.median with median of vector x
for (i in 1:nsim) {
  x <- rexp(n)
  lotsa.medians[i] <- median(x)
}
#summary(lotsa.medians)
#mean(lotsa.medians)
hist(lotsa.medians)




pollutantmean <- function(directory, pollutant, id=1:332){
  fnames<- list.files()
  dat <- data.frame()
  for (i in id) {
    data <- rbind(data, read.csv(fnames[i]))
  }
  data_subset <- dat[,pollutant]
  mean(dat_subset, na.rm=TRUE)
}
