#!/usr/bin/env Rscript
library(dplyr)
site_value="Zattini";page_type_value="Home";period_value="day";new_count_file="~/Exploration/traffic_count/result/new_max_count.txt"
setwd("~/Exploration/traffic_count/")

#take argument from bash
options(echo=TRUE) # if you want see commands in output file
myArgs <- commandArgs(trailingOnly = TRUE) # Now assuming no previous callers have processed bash args
print(paste("All args:", myArgs))

argIfPresent <- myArgs[1]
if (!is.na(argIfPresent)) site_value = argIfPresent else site_value='Netshoes'
argIfPresent <- myArgs[2]
if (!is.na(argIfPresent)) page_type_value = argIfPresent else page_type_value='PDP'
argIfPresent <- myArgs[3]
if (!is.na(argIfPresent)) period_value = argIfPresent else period_value='day'
argIfPresent <- myArgs[4]
if (!is.na(argIfPresent)) new_count_file = argIfPresent else new_count_file='new_max_count.txt'

print(paste("Arguments passed to or assumed by eoe_common_setup script are",
              'site_value:', site_value,
              'page_type_value:', page_type_value,
              'period_value:', period_value,
              'new_count_file:', new_count_file))


#read the historical max count table
max_count_table_file = paste0(getwd(),"/Netshoes_Page_Request_Analytics.csv")
max_count_table = read.csv(file=max_count_table_file,header=TRUE,stringsAsFactors = FALSE)
new_count = read.csv(file=new_count_file,header = FALSE,sep = "|")
colnames(new_count)=c("time","count")
print(new_count)

#compare the new_max_count and old_max_cou
target_old_count_row=max_count_table %>% filter(Site==site_value,Page_Type==page_type_value,Period==period_value)
print(paste0("The old count is ",target_old_count_row))
if(new_count$count > target_old_count_row$Count){
  max_count_table$Count[max_count_table$Site==site_value & max_count_table$Page_Type==page_type_value & max_count_table$Period==period_value]=new_count$count
  max_count_table$Max_Time[max_count_table$Site==site_value & max_count_table$Page_Type==page_type_value & max_count_table$Period==period_value]=toString(new_count$time)
  target_new_count_row=max_count_table %>% filter(Site==site_value,Page_Type==page_type_value,Period==period_value)
  print(paste0("The new count is ",target_new_count_row$Count))
  print("The max count number has been updated.")
  write.csv(max_count_table,file=max_count_table_file,row.names = FALSE)
} else{
  print("The old max count number remains.")
}

print("The current max_count_table: ")
print(max_count_table)