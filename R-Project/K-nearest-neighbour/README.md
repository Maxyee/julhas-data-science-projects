# Mobile Price Prediction Using KNN

```r
mobile_data <- read.csv('./data/mobile-data.csv')
names(mobile_data)
head(mobile_data)
tail(mobile_data) 
summary(mobile_data)
str(mobile_data)
```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/K-nearest-neighbour/screenshots/1.png)

![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/K-nearest-neighbour/screenshots/2.png)

![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/K-nearest-neighbour/screenshots/3.png)

```r
#number of data rows in the data frame can be determined by the nrow() function. 
nrow(mobile_data) 

#number of columns in the data frame can be determined by the ncol() function. 
ncol(mobile_data)

dim(mobile_data)
```

```r
#checking is there any null value..
mobile_data_check_null <- mobile_data[c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21)]
mobile_data_check_null
is.null(mobile_data_check_null)
```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/K-nearest-neighbour/screenshots/4.png)

```r
#selecting the train variable to find out the mobile phone price range
mobile_data_f <- mobile_data[,c(1,3,4,7,14,21)]
mobile_data_f

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/K-nearest-neighbour/screenshots/5.png)

```r
#converting the data for euclidean distance measure
mobile_data_f$euclidean_distance
mobile_data_f
```


```r
#assigning the independent variable called the mobile feature categories
bat_power<- 1536 
clo_sped<- 2.6
duel_sim<- 0
internal_memory <- 30
ram_power<- 2600

```


```r
length <- nrow(mobile_data_f) # get number of rows

# Calculating the Euclidean distances
for(i in 1:length) 
{ 
  mobile_data_f$euclidean_distance[i] = sqrt( 
    (mobile_data_f$battery_power[i]-bat_power)^2+ 
      (mobile_data_f$clock_speed[i]-clo_sped)^2+ 
      (mobile_data_f$dual_sim[i]-duel_sim)^2+
      (mobile_data_f$int_memory[i]-internal_memory)^2+
      (mobile_data_f$ram[i]-ram_power)^2
  ) 
} 

```

![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/K-nearest-neighbour/screenshots/6.png)

```r
#output data set after doing the euclidean distance
mobile_data_f <- mobile_data_f[order(mobile_data_f$euclidean_distance),] 
mobile_data_f 

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/K-nearest-neighbour/screenshots/7.png)

```r

# k nearest neighbor 5 values
k <- 5

mobile_data_f[1:k,]

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/K-nearest-neighbour/screenshots/8.png)

```r
Class1 <- sum(mobile_data_f$price_range[1:k]==1)
Class2 <- sum(mobile_data_f$price_range[1:k]==2)
Class3 <- sum(mobile_data_f$price_range[1:k]==3)
if (Class1 > k/2) 
{ 
  print("The query point belongs to Medium Cost") 
} else if(Class2 > k/2) 
{ 
  print("The query point belongs to High Cost") 
}else if (Class3 > k/2){
  print("The query point belongs to Very High Cost") 
} else {
  print("The query point belongs to Low Cost") 
}

```

![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/K-nearest-neighbour/screenshots/9.png)
