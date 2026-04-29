data <- Crime_Data
time <- data$`Days Between Report and Occurrence`
sex <- data$VictSex

n <- length(time)

Mnum <- 0
Fnum <- 0
Xnum <- 0
Mfast <- 0
Ffast <- 0
Xfast <- 0
i <- 1
while (i < n){
  if(i == 1158 | i == 1241){
    i <- i + 1
  }
  if (sex[i] == 'M'){
    Mnum <- Mnum + 1
    if (time[i] == 0){
      Mfast <- Mfast + 1
    }
  }
  else if (sex[i] == 'F'){
    Fnum <- Fnum + 1
    if (time[i] == 0){
      Ffast <- Ffast + 1
    }
  }
  else {
    Xnum <- Xnum + 1
    if (time[i] == 0){
      Xfast <- Xfast + 1
    }
  }
  i <- i+1
}

Mslow <- Mnum-Mfast
Fslow <- Fnum-Ffast
Xslow <- Xnum-Xfast
fast <- Mfast + Ffast + Xfast

table <- matrix(c(Mfast,Ffast,Mfast+Ffast,Mslow,Fslow,Mslow+Fslow,Mnum,Fnum,Mnum+Fnum), ncol = 3, byrow = TRUE)
colnames(table) = c('M','F','Total')
rownames(table) = c('Fast','Slow','Total')
as.table(table)

table2 <- matrix(c(Mfast,Ffast,Mslow,Fslow), ncol = 2, byrow = TRUE)
fisher.test(table2) # p-value 0.004142, so significant evidence that homicides of females are reported more slowly than homicides of males