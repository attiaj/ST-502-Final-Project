data <- Crime_Data
time <- data$`Days Between Report and Occurrence`
descent <- data$VictDescent
descentList <- c('A', 'B', 'F', 'H', 'O', 'W', 'X')

#A - Other Asian, B - Black, F - Filipino, H - Hispanic/Latin/Mexican,
  #O - Other, W - White, X - Unknown
# No victims for D - Cambodian, G - Guamanian
  #I - American Indian/Alaskan Native, J - Japanese, L - Laotian,
  #P - Pacific Islander, S - Samoan, U - Hawaiian, V - Vietnamese,
  #Z - Asian Indian

countFast <- c(0,0,0,0,0,0,0)
countSlow <- c(0,0,0,0,0,0,0)

i <- 1
while (i <= length(descentList)){
  countFast[i] <- dim(subset(subset(data, VictDescent == descentList[i]), `Days Between Report and Occurrence` == 0))[1]
  countSlow[i] <- dim(subset(subset(data, VictDescent == descentList[i]), `Days Between Report and Occurrence` > 0))[1]
  if (descentList[i] == 'A'){
    countFast[i] <- countFast[i] + dim(subset(subset(data, VictDescent == 'C'), `Days Between Report and Occurrence` == 0))[1] + dim(subset(subset(data, VictDescent == 'K'), `Days Between Report and Occurrence` == 0))[1]
    countSlow[i] <- countFast[i] + dim(subset(subset(data, VictDescent == 'C'), `Days Between Report and Occurrence` > 0))[1] + dim(subset(subset(data, VictDescent == 'K'), `Days Between Report and Occurrence` > 0))[1]
  }
  i <- i + 1
}

# Slides say need at least 5 entries for each category: not fulfilled for
  #C - Chinese, K - Korean: folded into A - Other Asian

table <- data.frame(
  #descent = descentList,
  fast = countFast,
  slow = countSlow
)

chisq.test(table)