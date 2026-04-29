g <- Crime_Data$`Days Between Report and Occurrence`

minTime <- min(g)
maxTime <- max(g)

n <- length(g)
m <- 1217 # number of bins
breaks <- seq(from = minTime+(maxTime-minTime)/m, to = maxTime, by = (maxTime-minTime)/m)

rate <- (n-2)/sum(g)

h <- hist(g, breaks = append(breaks, 0, after = 0), density = 10,
          col = "lightgray", xlab = "Age", main = "Age Histogram")
xfit <- seq(min(g), max(g), length = 1217) 
expfit <- dexp(xfit, rate = rate)
expfit <- expfit * diff(h$mids[1:2]) * length(g)
lines(xfit, expfit, col = "black", lwd = 2)

breakshifts <- breaks
breakshifts[1] <- 0
i <- 2
while (i <= m){
  breakshifts[i] <- breaks[i - 1]
  i <- i + 1
}

fbins <- pexp(breaks, rate = rate)-pexp(breakshifts, rate = rate)

fbins

chi2 <- sum((h$counts-n*fbins)^2/(n*fbins))
df <- m-1
p <- pchisq(chi2, df, lower.tail = FALSE)

chisq.test(h$counts,p=fbins)
chi2
df
p