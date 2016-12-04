###################################################
## Cleaning data set on ethnicities of UK pupils ##
###################################################

## Load libraries

library(dplyr)
install.packages("xlsx")
library(xlsx)

## Download and read in UK govt data set on ethnicities of students by Local Authority 
## (LA) code for 2013.

dataURL <- "https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/
                207733/Local_authority_and_regional_tables_-_SFR_21_2013.xls"
download.file(dataURL, destfile = "LAandRegtab.xls", mode = "wb")
ethnicity <- read.xlsx("LAandRegtab.xls", 14)

## Clean data set: select only columns on LA Codes, number White British pupils, and 
## number of All Pupils. 

ethnicity <- slice(ethnicity, 7:194)
ethnicity <- slice(ethnicity, 1:175)
ethnicity <- select(ethnicity, c(2, 6, 30))
colnames(ethnicity) <- c("Area Code", "White British", "All Pupils")
ethnicity <- slice(ethnicity, 3:175)
ethnicity <- slice(ethnicity, 4:173)

## Remove rows without data on specific LA.

ethnicity <- ethnicity[!is.na(ethnicity$`Area Code`), ]

## Change class on numbers of pupils from factor to numeric.

ethnicity$`White British` <- as.numeric(as.character(ethnicity$`White British`))
ethnicity$`All Pupils` <- as.numeric(as.character(ethnicity$`All Pupils`))

