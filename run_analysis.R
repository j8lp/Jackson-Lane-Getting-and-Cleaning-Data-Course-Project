url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("data")) dir.create("data")
download.file(url, destfile = "data/data.zip")
files = unzip("data/data.zip",exdir="data")
