# Video game analysis on the basis of their sale using clustering.


```r
# loading the csv file
video_game_data <- read.csv("vgsales.csv", header= TRUE)
```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/2.png)

```r
# selecting 50-80 rows as new data set.
video_game_df <- video_game_data[50:80,]

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/4.png)

```r
# data set details finding 
names(video_game_df)
head(video_game_df)
tail(video_game_df)
summary(video_game_df)
str(video_game_df)

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/6.png)
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/7.png)
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/8.png)

```r
# number of rows into the data set
nrow(video_game_df)

#number of column into the data set
ncol(video_game_df)

#finding both row and column
dim(video_game_df)

```

```r
# installing the package called clustering
install.packages("cluster")
library(cluster)

```


```r
#ploting with Global and National sales
plot(Global_Sales~ NA_Sales, data = video_game_df)
with(video_game_df,text(Global_Sales ~ NA_Sales, labels= Name, pos=4,cex=.6))

#ploting with Global and EU sales
plot(Global_Sales~ EU_Sales, data = video_game_df)
with(video_game_df,text(Global_Sales ~ EU_Sales, labels= Name,pos=4,cex=.6))

#ploting with Global and Japanese Sales
plot(Global_Sales~ JP_Sales, data = video_game_df)
with(video_game_df,text(Global_Sales ~ JP_Sales, labels= Name,pos=4,cex=.6))

#ploting with Global and Other Sales
plot(Global_Sales~ Other_Sales, data = video_game_df)
with(video_game_df,text(Global_Sales ~ Other_Sales, labels= Name,pos=4,cex=.6))

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/12.png)
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/13.png)
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/14.png)
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/15.png)

```r
# normalize function
normalise <- function(df)
{
  return(((df- min(df)) /(max(df)-min(df))*(1-0))+0)
}

head(video_game_df)

```


```r
#Normalize the data set using above normalize function 
rank<-video_game_df[,1]
game_name<-video_game_df[,2]
platform<-video_game_df[,3]
year<-video_game_df[,4]
genre<-video_game_df[,5]
publisher<-video_game_df[,6]
#remove rank, game_name, platform, year, genre, publisher column before normalize 
video_game_df_n<-video_game_df[,7:11]
video_game_df_n<-as.data.frame(lapply(video_game_df_n,normalise))
#add rank column after normalize
video_game_df_n$Rank<-rank 
#add game_name column after normalize
video_game_df_n$Game_name<-game_name 
#add platform column after normalize
video_game_df_n$Platform<-platform 
#add year column after normalize
video_game_df_n$Year<-year 
#add genre column after normalize
video_game_df_n$Genre<-genre 
#add publisher column after normalize
video_game_df_n$Publisher<-publisher 

```


```r

#rearrange the columns in the data set after normalizing 
video_game_df_n<-video_game_df_n[,c(11,1,2,3,4,5,6,7,8,9,10)]
head(video_game_df_n)

#choose distance method and create distance matrix
distance <- dist(video_game_df_eucli,method = "euclidean",)

# In this matrix, the value represents the distance between games.
print(distance)

#Round the distance figures to 3 decimals. 
print(distance,digits=3)

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/19.png)
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/20.png)
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/21.png)


```r
install.packages("factoextra") # install "factoextra" package
library(factoextra) # activate "factoextra" package

fviz_dist(distance)


```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/23.png)

```r
#perform Hierarchical clustering using hclust() function
video_game_df.hclust <- hclust(distance) 
video_game_df.hclust

plot(video_game_df.hclust) # plot the results
plot(video_game_df.hclust,hang=-1)

plot(video_game_df.hclust,labels=video_game_df$Name)

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/25.png)

```r

# draw 3 clusters 
plot(video_game_df.hclust,labels=video_game_df$Name)
rect.hclust(video_game_df.hclust, 3)

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/27.png)

```r
# draw 4 clusters 
plot(video_game_df.hclust,labels=video_game_df$Name)
rect.hclust(video_game_df.hclust, 4)
```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/29.png)

```r
# Cluster using average linkage
hclust.average <- hclust(distance, method = "average") 
plot(hclust.average,labels=video_game_df$Name)
rect.hclust(hclust.average, 4)

# Cluster using single linkage
hclust.single <- hclust(distance, method = "single") 
plot(hclust.single,labels=video_game_df$Name)
rect.hclust(hclust.single, 4)

# Cluster using centroid linkage
hclust.centroid<- hclust(distance, method = "centroid") 
plot(hclust.centroid,labels=video_game_df$Name)
rect.hclust(hclust.centroid, 4)

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/31.png)
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/32.png)
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/33.png)

```r
#cutree function() cuts a dendrogram tree into several groups by specifying the desired number of clusters.
member.centroid <- cutree(hclust.centroid,4) 
member.centroid
member.complete <- cutree(hclust.complete,4) 
member.complete
table(member.centroid,member.complete)

```
![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/35.png)

```r
#kmeans function perform k-means clustering on a data matrix.
video_game_df_numeric<-video_game_df[,7:11]
kc<-kmeans(video_game_df_numeric[,-1],5) #k=5
kc

clusplot(video_game_df_numeric, kc$cluster, color=TRUE, shade=TRUE, lines=0)


```

![alt text](https://github.com/Maxyee/julhas-data-science-projects/blob/master/R-Project/clustering/screenshots/37.png)
