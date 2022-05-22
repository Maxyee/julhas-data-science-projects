# Installing Packages
install.packages("arules")
install.packages("arulesViz")

# Loading package
library(arules)
library(arulesViz)

# making comma separated data set from csv file
tv_shows = read.transactions('TV_Shows.csv', sep =',', rm.duplicates = TRUE)

# details about data set
summary(tv_shows) 
str(tv_shows)
dim(tv_shows)


# Fitting model
set.seed = 220 # Setting seed

# Training Apriori rules one on the data set
associa_rules_one = apriori(data = tv_shows, 
                        parameter = list(support = 0.004, 
                                         confidence = 0.2))

# visualization for rule one
plot(associa_rules_one)
plot(associa_rules_one, method="grouped")
plot(associa_rules_one@quality)
plot(associa_rules_one, engine="plotly")


# Training Apriori rules two on the data set
associa_rules_two = apriori(data = tv_shows, 
                            parameter = list(support = 0.008, 
                                             confidence = 0.4))

# visualization for rule two
plot(associa_rules_two)
plot(associa_rules_two, method="grouped")
plot(associa_rules_two@quality)
plot(associa_rules_two, engine="plotly")

# Training Apriori rules three on the data set
associa_rules_three = apriori(data = tv_shows, 
                            parameter = list(support = 0.0016, 
                                             confidence = 0.6))

# visualization for rule three
plot(associa_rules_three)
plot(associa_rules_three, method="grouped")
plot(associa_rules_three@quality)
plot(associa_rules_three, engine="plotly")

# Plot
itemFrequencyPlot(tv_shows, topN = 10)

# installing shiny and shiny theme package
install.packages("shiny")
library(shiny)

install.packages("shinythemes")
library(shinythemes)

#loading all the rules using  shiny package explorer
ruleExplorer(associa_rules_one)
# loading all the data using shiny package explorer
ruleExplorer(tv_shows)

