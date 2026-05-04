g <- Crime_Data$`Days Between Report and Occurrence`
g <- replace(g, g==0, 0.5)
glogg <- g*log(g)

minTime <- min(g)
maxTime <- max(g)

n <- length(g)
m <- 1217 # number of bins
breaks <- seq(from = minTime+(maxTime-minTime)/m, to = maxTime, by = (maxTime-minTime)/m)

theta <- (n*sum(glogg)-sum(g)*sum(log(g)))/n^2
alpha <- mean(g)/theta

h <- hist(g, breaks = append(breaks, 0, after = 0), density = 10,
          col = "lightgray", xlab = "Time", main = "Age Histogram")
xfit <- seq(min(g), max(g), length = 1217) 
gamfit <- dgamma(xfit, alpha, scale = theta)
gamfit <- gamfit * diff(h$mids[1:2]) * length(g)
lines(xfit, gamfit, col = "black", lwd = 2)

breakshifts <- breaks
breakshifts[1] <- 0
i <- 2
while (i <= m){
  breakshifts[i] <- breaks[i - 1]
  i <- i + 1
}

fbins <- pgamma(breaks, alpha, scale = theta)-pgamma(breakshifts, alpha, scale = theta)

chi2 <- sum((h$counts-(n*fbins))^2/(n*fbins))
df <- m+1

fbins

p <- pchisq(chi2, df, lower.tail = FALSE)

chisq.test(append(h$counts, c(0, 0)),p=append(fbins, tails))
chi2
df
p