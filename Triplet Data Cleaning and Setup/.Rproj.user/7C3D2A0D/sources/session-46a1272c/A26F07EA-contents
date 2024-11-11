# Clear environment ---------- 
rm(list=ls())

# Load necessary libraries
library(readxl)
library(dplyr)
library(openxlsx)

# Read the Excel file
validation_set <- read_excel("validation_comparisons.xlsx", sheet = "Sample Set", col_names = TRUE)

# Ensure the column name is correct
validation_set <- validation_set$img

# Function to create unique combinations
create_combinations <- function(validation_set) {
  sets <- list()
  for( i in seq_along(validation_set)) {
    remaining_imgs <- validation_set[-i]
    shuffled_imgs <- sample(remaining_imgs)
    set <- c(validation_set[i], shuffled_imgs[1:2])
    #create data frame
    sets[[i]] <- as.data.frame(t(set), stringAsFactors = FALSE)
    names(sets[[i]]) <- c("head", "choice_1", "choice_2")
      #setNames(set, c("head", "choice_1", "choice_2"))
  }
  return(sets)
}

# Shuffle and create combinations
combinations <- create_combinations(validation_set)

# Convert to a data frame
combinations_df <- do.call(rbind, lapply(combinations, as.data.frame))

# Load the existing Excel file
wb <- loadWorkbook("validation_comparisons.xlsx")

# Add a new sheet with the combinations
addWorksheet(wb, "Randomized Sets")
writeData(wb, sheet = "Randomized Sets", combinations_df)

# Save the workbook
saveWorkbook(wb, "validation_comparisons.xlsx", overwrite = TRUE)
