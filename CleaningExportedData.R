# Install and load necessary packages
# install.packages("dplyr")
# install.packages("stringr")
library(dplyr)
library(stringr)

# Read the CSV file
data <- read.csv("your_file.csv")

# Function to select an object from the array based on a variable
select_object <- function(array_string, variable_value) {
  # Remove brackets and split into individual file paths
  array_items <- str_replace_all(array_string, "\\[|\\]|\"", "") %>%
    str_split(",") %>%
    unlist()
  
  # Select object based on the value of another variable (example logic)
  # You can customize the selection logic based on your conditions
  if (variable_value == "condition1") {
    selected_object <- array_items[1]  # Pick the first object for "condition1"
  } else {
    selected_object <- array_items[2]  # Pick the second object for other conditions
  }
  
  return(selected_object)
}

# Apply the function to each row and create a new column with the selected object
data <- data %>%
  mutate(SelectedObject = mapply(select_object, YourArrayColumn, YourVariableColumn))

# Save the updated dataset to a new CSV file
write.csv(data, "updated_file.csv", row.names = FALSE)