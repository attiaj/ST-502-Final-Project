g <- Crime_Data$VictSex
g <- g[-c(1158, 1241)]
g <- g[g != "X"] # Remove entries with unknown gender
g <- as.character(g)
g <- replace(g, g=="M", 0)
g <- replace(g, g=="F", 1)
g <- as.integer(g)

n <- length(g)
m <- 2 # Number of bins

p <- mean(g)
p

h <- hist(g, breaks = 2,
          col = "lightgray", xlab = "M/F", main = "Sex Histogram and Bernoulli Fit")
xfit <- c(0,1)
bernfit <- c(1-p,p)
bernfit <- bernfit * length(g)

h$counts
bernfit

chisq.test(h$counts,p=c(1-p,p))