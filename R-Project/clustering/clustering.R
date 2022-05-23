# loading the csv file
video_game_data <- read.csv("vgsales.csv", header= TRUE)

# selecting 50-80 rows as new data set.
video_game_df <- video_game_data[50:80,]

# data set details finding 
names(video_game_df)
head(video_game_df)
tail(video_game_df)
summary(video_game_df)
str(video_game_df)

# number of rows into the data set
nrow(video_game_df)

#number of column into the data set
ncol(video_game_df)

#finding both row and column
dim(video_game_df)

# installing the package called clustering
install.packages("cluster")
library(cluster)

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

# normalize function
normalise <- function(df)
{
  return(((df- min(df)) /(max(df)-min(df))*(1-0))+0)
}

head(video_game_df)

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

#rearrange the columns in the data set after normalizing 
video_game_df_n<-video_game_df_n[,c(11,1,2,3,4,5,6,7,8,9,10)]
head(video_game_df_n)

#choose distance method and create distance matrix
distance <- dist(video_game_df_eucli,method = "euclidean",)

# In this matrix, the value represents the distance between games.
print(distance)

#Round the distance figures to 3 decimals. 
print(distance,digits=3)

install.packages("factoextra") # install "factoextra" package
library(factoextra) # activate "factoextra" package

fviz_dist(distance)

#inspect the first few observations 
head(video_game_df_n)

#rownames() function
#Set game names as row names 
rownames(video_game_df_n)<-video_game_df_n$Game_name

#remove Game_name column from the dataset 
video_game_df_n$Game_name<-NULL

#inspect the top observations 
head(video_game_df_n)

distance <- dist(video_game_df_n,method = "euclidean") 
fviz_dist(distance)

#perform Hierarchical clustering using hclust() function
video_game_df.hclust <- hclust(distance) 
video_game_df.hclust

plot(video_game_df.hclust) # plot the results
plot(video_game_df.hclust,hang=-1)

plot(video_game_df.hclust,labels=video_game_df$Name)

# draw 3 clusters 
plot(video_game_df.hclust,labels=video_game_df$Name)
rect.hclust(video_game_df.hclust, 3)

# draw 4 clusters 
plot(video_game_df.hclust,labels=video_game_df$Name)
rect.hclust(video_game_df.hclust, 4)

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

# Cluster using complete linkage
hclust.complete <- hclust(distance, method = "complete") 
plot(hclust.complete,labels=video_game_df$Name)
rect.hclust(hclust.complete, 4)

#cutree function() cuts a dendrogram tree into several groups by specifying the desired number of clusters.
member.centroid <- cutree(hclust.centroid,4) 
member.centroid
member.complete <- cutree(hclust.complete,4) 
member.complete
table(member.centroid,member.complete)


#kmeans function perform k-means clustering on a data matrix.
video_game_df_numeric<-video_game_df[,7:11]
kc<-kmeans(video_game_df_numeric[,-1],5) #k=5
kc

clusplot(video_game_df_numeric, kc$cluster, color=TRUE, shade=TRUE, lines=0)
