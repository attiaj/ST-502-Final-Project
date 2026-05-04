g <- Crime_Data$VictAge
g <- replace(g, g==0, 0.5) # Age 0 messes up log: replace with 0.5, as the average age of infants between 0 and 1
glogg <- g*log(g)

minAge <- min(g)
maxAge <- max(g)

n <- length(g)
m <- 10 # Number of bins
breaks <- seq(from = minAge+(maxAge-minAge)/m, to = maxAge, by = (maxAge-minAge)/m)

theta <- (n*sum(glogg)-sum(g)*sum(log(g)))/n^2
alpha <- mean(g)/theta

h <- hist(g, breaks = append(breaks, 0.5, after = 0), density = 10,
          col = "lightgray", xlab = "Age", main = "Age Histogram and Normal/Gamma Fits")
xfit <- seq(min(g), max(g), length = 40) 
gamfit <- dgamma(xfit, alpha, scale = theta)
gamfit <- gamfit * diff(h$mids[1:2]) * length(g)
normfit <- dnorm(xfit, mean = mean(g), sd = sd(g))
normfit <- normfit * diff(h$mids[1:2]) * length(g)
lines(xfit, normfit, col = "black", lwd = 2)
lines(xfit, gamfit, col = "blue", lwd = 2)

breakshifts <- breaks
breakshifts[1] <- 0.5
i <- 2
while (i <= m){
  breakshifts[i] <- breaks[i - 1]
  i <- i + 1
}

fbins <- pgamma(breaks, alpha, scale = theta)-pgamma(breakshifts, alpha, scale = theta)
tails <- c(pgamma(breakshifts[1], alpha, scale = theta), 1-pgamma(breaks[m], alpha, scale = theta))

chi2 <- sum((append(h$counts, c(0, 0))-(n*append(fbins, tails)))^2/(n*append(fbins, tails)))
df <- m+1

p <- pchisq(chi2, df, lower.tail = FALSE)

chisq.test(append(h$counts, c(0, 0)),p=append(fbins, tails))
chi2
df
p