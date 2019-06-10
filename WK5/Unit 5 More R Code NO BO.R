# Live Session 5 R Code
library(dplyr)
library(tidyverse)

#Merging

#Start with basic inner, outer, right and left

df1 = data.frame(Student_ID = c("1234", "2345", "8910", "9101", "3456", "5678","8888"), Course = c("Time Series", "NLP", "Stats1", "DDS", "DDS", "ML2","Data Mining"))
df2 = data.frame(Student_ID = c("1234", "2345", "8910", "9101", "3456", "5678","99999", "11111"), Gender = c("M", "F", "M", "F", "F", "F", "M", "M"), State = c("TX", "TX", "CA", "ID", "NY", "FL","NM", "AZ") )


#inner join
merge(df1,df2, by = "Student_ID")
inner_join(df1,df2,by = "Student_ID")
df1 %>% inner_join(df2,by = "Student_ID")

#Different Column Names: by.x and by.y
df3 = data.frame(Student_ID_Number = c("1234", "2345", "8910", "9101", "3456", "5678", "8888"), Course = c("Time Series", "NLP", "Stats1", "DDS", "DDS", "ML2", "Data Mining"))
df4 = data.frame(Student_ID = c("1234", "2345", "8910", "9101", "3456", "5678","99999", "11111"), Gender = c("M", "F", "M", "F", "F", "F", "M", "M"), State = c("TX", "TX", "CA", "ID", "NY", "FL","NM", "AZ") )

merge(df3,df4, by.x = "Student_ID_Number", by.y = "Student_ID")


#outer join
merge(df1,df2, by = "Student_ID",all = TRUE)
full_join(df1,df2,by = "Student_ID")
df1 %>% full_join(df2,by = "Student_ID")

merge(df3,df4, by.x = "Student_ID_Number", by.y = "Student_ID", all = TRUE)

#left join
merge(df1,df2, by = "Student_ID",all.x = TRUE)
left_join(df1,df2, by = "Student_ID")

merge(df3,df4, by.x = "Student_ID_Number", by.y = "Student_ID", all.x = TRUE)

#right join 
merge(df1,df2, by = "Student_ID",all.y = TRUE)
right_join(df1,df2, by = "Student_ID")

merge(df3,df4, by.x = "Student_ID_Number", by.y = "Student_ID", all.y = TRUE)








## Regular Expressions

# BASICS

strings <- c("a", "ab", "acb", "accb", "acccb", "accccb")
grep("ac*b", strings, value = TRUE) # * = 0 or more
## [1] "ab"     "acb"    "accb"   "acccb"  "accccb"
grep("ac+b", strings, value = TRUE) # + = 1 or more
## [1] "acb"    "accb"   "acccb"  "accccb"
grep("ac?b", strings, value = TRUE) # ? 0 or 1
## [1] "ab"  "acb"
grep("ac{3}b", strings, value = TRUE) # {x} exactly x
## [1] "acccb"
grep("ac{2,}b", strings, value = TRUE)   #what will this return ?
grep("ac{2,3}b", strings, value = TRUE)  #what will this return ?
  

strings <- c("abcd", "cdab", "cabd", "c abd", "cabdd")
## [1] "abcd"  "cdab"  "cabd"  "c abd"  "cbdd" 
grep("ab", strings, value = TRUE)
## [1] "abcd"  "cdab"  "cabd"  "c abd"  "cbdd"
grep("^ab", strings, value = TRUE)
## [1] "abcd"
grep("ab$", strings, value = TRUE)
## [1] "cdab"
grep("(^c)d?", strings, value = TRUE)  # what will this return?
grep("(^c)d+", strings, value = TRUE)  # what will this return?
  
  

strings <- c("^ab", "ab", "abc", "abd", "abe", "ab 12")
grep("ab.", strings, value = TRUE)
## [1] "abc"   "abd"   "abe"   "ab 12"
grep("ab[c-e]", strings, value = TRUE)
## [1] "abc" "abd" "abe"
grep("ab[^c]", strings, value = TRUE)
## [1] "abd"   "abe"   "ab 12"
grep("^ab", strings, value = TRUE)
## [1] "ab"    "abc"   "abd"   "abe"   "ab 12"
grep("\\^ab", strings, value = TRUE)          ## [1] "^ab" ... escaped regex first then string
grep("abc|abd", strings, value = TRUE)  # what will this return?
  
  
#separate example

NamesDF = data.frame(Name = c("Flash_Gordon", "Babe_Ruth", "John_Smith", "Susan_Anthony", "Michael_Jordan"))

NamesDF = separate(NamesDF,"Name", into = c("First","Last"), sep = "_")                     

#gsub

NamesDF$GenderAge = c("M19", "M40", "M32", "F140", "M55")
#or
NamesDF = mutate(NamesDF,GenderAge=  c("M19", "M40", "M32", "F140", "M55"))

NamesDF$GenderAge = gsub("M","M_",NamesDF$GenderAge)
NamesDF$GenderAge = gsub("F","F_",NamesDF$GenderAge)

NamesDF= separate(NamesDF,"GenderAge",into = c("Gender","Age"), sep = "_")





#Stars Regex (Look ahead)


# REGEX CHECKING WEBSITES
#https://regex101.com/
#https://regexr.com


#API Breakout


#NYT JSON Example

library(dplyr)
library(tidyr)
library(plyr)
library(rjson)
library(RTextTools)
library(jsonlite)


NYTIMES_KEY = "D5paMD9GgmD5zgGhZmNOQScjGxXw8cju";

# Let's set some parameters
term <- "Trump" # Need to use + to string together separate words
begin_date <- "20190101"
end_date <- "20190106"

baseurl <- paste0("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=",term,
                  "&begin_date=",begin_date,"&end_date=",end_date,
                  "&facet_filter=true&api-key=",NYTIMES_KEY, sep="")

initialQuery <- jsonlite::fromJSON(baseurl)
maxPages <- round((initialQuery$response$meta$hits[1] / 10)-1)

#for(i in 1:100000000)
#{  
#  j = (i + 1 -1 )/i 
#}

pages <- list()
for(i in 0:maxPages){
  nytSearch <- jsonlite::fromJSON(paste0(baseurl, "&page=", i), flatten = TRUE) %>% data.frame() 
  message("Retrieving page ", i)
  pages[[i+1]] <- nytSearch 
  Sys.sleep(1) 
}


allNYTSearch <- rbind_pages(pages)

grep("Putin", allNYTSearch$response.docs.headline.main, value = TRUE)
grep("Russia", allNYTSearch$response.docs.headline.main, value = TRUE)
grep("(Putin|Russia)", allNYTSearch$response.docs.headline.main, value = TRUE)

  
# Case Study 1





