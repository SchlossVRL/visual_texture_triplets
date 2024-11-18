########### Raw Data Exploration Tutorial
########### Author: Ivette Colón
# This is a tutorial script to show:
# 1) How to read in datafiles
# 2) How to do some basic cleaning of the datafiles
# 3) Some general tools & tips for working in R!
############ START HERE
# Hashtags (#) denote a "comment". A comment is text that is not run as code.
# We use comments to give more info about what we're doing. (Very helpful for sharing or re-reading code!)
# The comments in this tutorial will guide you through the process of cleaning.
# Our general steps are:
# 1) Install and load required packages
# 2) Set working directory and read in files
# 3) Basic inspection of datafiles
# 4) Selecting the things we care about for cleaning
# 5) Manipulating strings and actually cleaning
# 6) Saving out files!
### Step 1: Install and load required packages
# If you don't already have these packages installed, uncomment the lines below (delete the hashtag)
# install.packages("tidyverse")
# install.packages("data.table")
#clear environment
rm(list = ls())
# Next we have to tell R that we want to use the tools in the tidyverse package!
library(tidyverse) # This loads some packages we need from tidyverse
library(data.table) # This loads some packages we need from data.table
### Step 2: Set working directory and read in files
#setwd("/Users/annachinni/Dropbox/TextureSemantics/Embeddings/TextureEmbeddings/VisualTextureTileDataFullSet/InPersonData") # setting working directory to where data files are stored
temp <- list.files(path = "data", full.names = TRUE) # getting file name of everything in directory
#d_full <- lapply(temp, read_csv, show_col_types = FALSE) # applying read function to all CSVs in list of file names
#add ids
d_full <- lapply(temp, function(df) {
  data <- read_csv(df, show_col_types = FALSE)  # read each file
  data$id <- data$response[1]  # add a new column with the first value of the response column
  return(data)  # return the modified dataset
})
d_full <- rbindlist(d_full, fill = TRUE)  # binding them together into one big dataframe
### Step 3: Basic inspection of datafiles
# This is a good time to inspect d_full, and make sure that it looks how you'd expect! You can either click on it's name in your "Environment" tab, or run the line below:
view(d_full)
# We really care about what's in the Stimulus, Response, and Choices columns
# You can see that there are many "useless" rows and columns (e.g., lines were the stimulus is just "+" aka the fixation screen). We need to select just the rows and columns we care about!
d <- d_full %>% filter(trial_type == "image-keyboard-response") %>% # getting trials with that trial type
  filter(!trial_index == 3) %>% # getting rid of the consent form
  select(subject_id, rt, stimulus, response, choices, speedy, sampleAlg)
d$choices_full <- d$choices # making a copy just in case before we manipulate the column
d$choices <- gsub('\\[|\\]', replacement = "", x = d$choices) # removing brackets from file names in choices
d$choices <- gsub('"', replacement = "", x = d$choices) # removing quotation marks from file names in choices
d$subject_id <- gsub("[\\{\\}\":]", "", d$subject_id) #removing {}, :, and ""
d <- d %>% dplyr::rename(target = "stimulus") # renaming the column, stimulus -> target
d <- d %>% dplyr::rename(validation = "sampleAlg") # renaming the column, sampleAlg -> validation
x <- d$choices %>% str_split_fixed(pattern = ",", n = 2) # splitting choices into two columns for left and right image




winner <- list() # list to hold the winners
loser <- list() # list to hold the losers
for (i in 1:nrow(d)){ # for every row "i", where i is 1-the number of rows ...
  if(d[i, response] == "arrowleft"){ # if response = 0, the winner is the image on the left, save that for row i
    winner[i] <- x[i, 1]
    loser[i] <- x[i, 2]
  }
  else{# if response does not = 0, winner is the image on the right, save that for row i
    winner[i] <- x[i, 2]
    loser[i] <- x[i, 1]
  }
}
d$winner <- winner %>% unlist() # make the list a vector so we can add it to dataframe
d$loser <- loser %>% unlist()

d$center <- d$target # add some columns
d$left <- x[,1]
d$right <- x[,2]

d_levels <- as.character(d$target) %>% c() %>% unique() %>%  sort() # get the unique number label for each item

# save this as another file somewhere^
# Save d_levels as a CSV file
write.csv(d_levels, file = "EmbeddingData/d_levels.csv", row.names = FALSE)

# making a new, fresh dataframe that save the target, winner, and loser in numeric form, assigned my their ordering in d_levels
d_cleaned <- data.frame(head = as.numeric(factor(d$target, levels = d_levels)),
                        winner = as.numeric(factor(d$winner, levels = d_levels)),
                        loser = as.numeric(factor(d$loser, levels = d_levels)))
d_cleaned$subject_id <- d$subject_id
d_cleaned$center <- d$center
d_cleaned$left <- d$left
d_cleaned$right <- d$right
d_cleaned$validation <- d$validation


write_csv(x = d_cleaned, file = "EmbeddingData/FullSet_cleaned.csv") # writing the output out
# Let's remove those rows!
