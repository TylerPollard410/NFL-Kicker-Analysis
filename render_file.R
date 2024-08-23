## Script to render Rmarkdown
# Author: Tyler Pollard
# Date: 22 Aug 2024

library(rmarkdown)

render(input = "Field_Goal_Analysis.Rmd", output_format = "github_document", output_file = "README.md")
