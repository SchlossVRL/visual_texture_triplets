# Clear environment ---------- 
rm(list=ls())

# Load the necessary package
library(magick)

# Set the folder where your images are located
image_folder <- "materials/"

# Set the folder where the resized images will be saved
output_folder <- "materials/imgs/"

# Set the desired dimensions for resizing
new_width <- 300   # Width in pixels
new_height <- 300  # Height in pixels

# Get the list of images from the folder
image_files <- list.files(image_folder, pattern = "\\.png$", full.names = TRUE)

# Loop through each image and resize
for (image_path in image_files) {
  # Load the image
  img <- image_read(image_path)
  
  # Resize the image
  img_resized <- image_resize(img, geometry = paste0(new_width, "x", new_height))
  
  # Save the resized image in the output folder
  output_path <- file.path(output_folder, basename(image_path))
  image_write(img_resized, path = output_path)
  
  print(paste("Resized and saved:", output_path))
}
