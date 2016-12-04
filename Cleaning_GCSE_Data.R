#####################################################
## Cleaning data set on GCSE results for UK pupils ##
#####################################################

## Load libraries

library(dplyr)
install.packages("xlsx")
library(xlsx)

## Read in csv file of GCSE results for 2015-2016 and subset the percentage of 
## students earning 5 or more A* to C results in English and Maths GCSEs.

GCSE_results_20152016 <- read.csv("2015-2016-england_ks4provisional.csv")
GCSE_1516 <- select(GCSE_results_20152016, c(2, 15))
names(GCSE_1516) <- c("Old.LA.Code", "5.or.more.A*-C.in.both.English.and.Maths.GCSEs")

## Unzip csv files with definitions for GCSE results file and read in LA and 
## Region codes.

unzip("Performancetables_174238.zip")
LA_Region_Codes <- read.csv("./2015-2016/la_and_region_codes_meta.csv")
arrange(LA_Region_Codes, LEA)
names(LA_Region_Codes)[1] <- "Old.LA.Code"

## Merge GCSE results with LA and Region Codes.

GCSE_codes_1516 <- full_join(GCSE_1516, LA_Region_Codes, by = "Old.LA.Code")

## Download and read in file mapping old LA codes to new LA codes. Merge with 
## GCSE results.

download.file("https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/219595/nlac-2011.xls", destfile = "nlac_2011.xls", mode = "wb")
regioncodes <- read.xlsx("nlac_2011.xls", 1)
GCSEs <- full_join(GCSEs_results, regioncodes, by = "Old.LA.Code")

## Prep for integration with immigration and Brexit data sets in Tableau.

names(GCSEs)[6] <- "Area Code"
write.table(GCSEs, file = "GCSEs.csv")
