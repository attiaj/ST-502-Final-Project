
library(tidyverse)

# la demographics from census https://www.census.gov/quickfacts/fact/table/losangelescitycalifornia/PST045224
la_demog=data.frame(cbind(Descent=c("A+C+F+K","B","H","O","W"),p=c(0.121,0.084,0.472,0.189,0.334)))

demogp=c(0.121,0.084,0.272,0.189,0.334)

Crime_Data_Clean<-na.omit(Crime_Data)
Crime_Data_Clean$DBRO<-Crime_Data_Clean$`Days Between Report and Occurrence`
Crime_Data_Clean<-Crime_Data_Clean[,-6]
N=nrow(Crime_Data_Clean)

# is the age of murder different for men and women? 
# -> NO, p=0.5002
onlysex=lm(VictAge~VictSex,data=Crime_Data_Clean)
nullmodel=lm(VictAge~1,data=Crime_Data_Clean)
anova(onlysex,nullmodel)

# is the age of murder different between descents? 
# -> YES, p=2.2e-16
onlydescent=lm(VictAge~VictDescent,data=Crime_Data_Clean)
anova(nullmodel,onlydescent)

# is the age of murder different between areas? 
# -> YES, p=0.00169
onlyarea=lm(VictAge~AreaCode,data=Crime_Data_Clean)
anova(nullmodel,onlyarea)

# is the age of murder vary across DBRO?
# -> NO, p=0.613
onlydbro=lm(VictAge~DBRO,data=Crime_Data_Clean)
anova(nullmodel,onlydbro)

# is the number of DBRO different for men and women?
# -> YES, p-0.01949
dbrosex=lm(DBRO~VictSex,data=Crime_Data_Clean)
nullmodel=lm(DBRO~1,data=Crime_Data_Clean)
anova(dbrosex,nullmodel)

# is the number of DBRO different between areas?
# -> NO, p=0.8168
dbroarea=lm(DBRO~AreaCode,data=Crime_Data_Clean)
anova(dbroarea,nullmodel)

# is the number of DBRO different between descents?
# -> NO, p=0.3106
dbrodescent=lm(DBRO~VictDescent,data=Crime_Data_Clean)
anova(dbrodescent,nullmodel)

# is the probability of a murder victim being a women the same as for a man?
# -> NO, p=2.2e-16
phat=Count_Sex$n[1]/N
p=0.5
se=sqrt(0.25/N)
zobs=(phat-p)/se
p_val=2*pnorm(zobs)

# is the probability of being a murder victim the same for all descents?
# -> NO, p=2.2e-16
Count_Descent=count(Crime_Data_Clean,VictDescent)
Count_Descent$n[1]=Count_Descent$n[1]+Count_Descent$n[3]+Count_Descent$n[4]+Count_Descent$n[6]
Count_Descent$n[7]=Count_Descent$n[7]+Count_Descent$n[8]
Count_Descent=Count_Descent[-c(3,4,6,8),]
chisq.test(x=Count_Descent$n,p=demogp)

sat_model<-lm(VictAge~1+VictSex+VictDescent+AreaCode,data=Crime_Data_Clean)