pollutantmean <- function(directory, pollutant, id=1:332){
fnames<- list.files()
dat <- data.frame()
for (i in id) {
	data <- rbind(data, read.csv(fnames[i]))
}
data_subset <- dat[,pollutant]
mean(dat_subset, na.rm=TRUE)
}