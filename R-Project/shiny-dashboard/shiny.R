#install.packages('NLP')
#install.packages('corpus')
#install.packages('tm')
#install.packages('RColorBrewer')
#install.packages("wordcloud")
#install.packages("shiny")
#install.packages("shinydashboard")


# loading libraries and EDA ----
library(NLP)
library(corpus)
library(tm)
library(RColorBrewer)
library(wordcloud)
library(shiny)
library(shinydashboard)

# Load the positive and negative lexicon data
positive_lexicon <- read.csv("positive-lexicon.txt")
negative_lexicon <- read.csv("negative-lexicon.txt")

total_positive_review <- 0
total_negative_review <- 0

sentiment <- function(stem_corpus)
{
  #generate wordclouds
  wordcloud(stem_corpus,
            min.freq = 3,
            colors=brewer.pal(8, "Dark2"),
            random.color = TRUE,
            max.words = 100)
  #Calculating the count of total positive and negative words in each review
  
  #Create variables and vectors
  total_pos_count <- 0
  total_neg_count <- 0
  pos_count_vector <- c()
  neg_count_vector <- c()
  #Calculate the size of the corpus
  size <- length(stem_corpus)
  
  for(i in 1:size)
  {
    #All the words in current review
    corpus_words<- list(strsplit(stem_corpus[[i]]$content, split = " "))
    
    #positive words in current review
    pos_count <-length(intersect(unlist(corpus_words), unlist(positive_lexicon)))
    
    #negative words in current review
    neg_count <- length(intersect(unlist(corpus_words), unlist(negative_lexicon)))
    
    total_pos_count <- total_pos_count + pos_count ## overall positive count
    total_neg_count <- total_neg_count + neg_count ## overall negative count
    
  }
  #Calculating overall percentage of positive and negative words of all the reviews
  total_pos_count ## overall positive count
  total_neg_count ## overall negative count
  total_count <- total_pos_count + total_neg_count
  overall_positive_percentage <- (total_pos_count*100)/total_count
  overall_negative_percentage <- (total_neg_count*100)/total_count
  overall_positive_percentage ## overall positive percentage
  #Create a dataframe with all the positive and negative reviews
  total_positive_review <- total_pos_count
  print(total_positive_review)
  total_negative_review <- total_neg_count
  print(total_negative_review)
  df<-data.frame(Review_Type=c("Postive","Negitive"),
                 Count=c(total_pos_count ,total_neg_count ))
  print(df) #Print
  overall_positive_percentage<-paste(round(overall_positive_percentage,2),"%")
  return(overall_positive_percentage)
}

# 30 hotel sentiment analysis robust approach ----

Hotel_Reviews <- read.csv("tourist_accommodation_reviews.csv", header= TRUE)

corpusFun <- function(x){
  require(tm)
  require(wordcloud)
  
  # step 1: Converting the text vectors to corpus
  z1 = Corpus(VectorSource(x)) 
  # step 2: 
  z2 = tm_map(z1, removeWords, stopwords("english"))
  z3 = tm_map(z2, stripWhitespace)
  z4 = tm_map(z3, stemDocument)
  res = sentiment(z4)
  return(res)
}

hotel_list <- c("Dee Plee - Anantara Layan Phuket Resort",
                "The Tavern",
                "Oriental Spoon",
                "Baan Mai",
                "Fatty's",
                "Hakan's Bar & Restaurant'",
                "Little Tiger",
                "Bite in",
                "Savoy Patong",
                "Ship Inn Bar & Restaurant",
                "Kusuma Seafood",
                "9' Sea Breeze",
                "Mare Italian Restaurant",
                "Khaorang Breeze Restaurant",
                "Belgian Beer Cafe Graceland",
                "Ken Restaurant",
                "MK Gold Restaurant",
                "Som Restaurant",
                "Naiyang Park Restaurant",
                "Sole Mio",
                "Restaurant La Croisette",
                "The Crab House",
                "Restaurant Mama Kata (Seafood)",
                "Dino Park",
                "The Siam Mumbai",
                "Green Leaf Restaurant",
                "Top Of The Reef at Cape Panwa Hotel",
                "Divino Tapas Restaurant",
                "Bob's Restaurant & Bar",
                "Chaba"
)


ui <- dashboardPage(
  dashboardHeader(title = "Hotel dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(
        h1("Hotel Selector"),
        selectInput("select", "Hotel List", hotel_list)
      ),
      valueBoxOutput("approvalBox"),
      
    ),
    
    fluidRow(
      
      box(
        h3("Meaningful word for selected hotel"),
        plotOutput("plot2", height = 500, width = 500),
      ),
      valueBoxOutput("positiveReview")
      
    ),
    
  )
)

server <- function(input, output) {
  
  
  
  output$plot2 <- renderPlot({
    selected_hotel<-subset(Hotel_Reviews,
                    Hotel.Restaurant.name==input$select)
    review_of_hotel<-selected_hotel$Review
    corp_hotel <- corpusFun(x = review_of_hotel)
    return(corp_hotel)
  })
  
  output$approvalBox <- renderValueBox({
    valueBox(
      "30", "Total Hotel", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$positiveReview <- renderValueBox({
    selected_hotel<-subset(Hotel_Reviews,
                           Hotel.Restaurant.name==input$select)
    review_of_hotel<-selected_hotel$Review
    corp_hotel <- corpusFun(x = review_of_hotel)
    
    valueBox(
      corp_hotel, "Total Positive Review", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "green"
    )
  })
  

  
}

shinyApp(ui, server)
