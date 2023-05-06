# 8510-Final-Project
The title of this project is "'In a Perishing Condition': The Fate of Black Inmates in the Philadelphia Almshouse, 1796-1803"

## Summary
This project uses a combination of data from Billy G. Smith's "Almshouse Admissions Philadelhia 1796-1803" dataset; selected entries from the Daily Occurrence Docket of the Philadelphia Almshouse, 1800-1804, transcribed and published by Billy G. Smith and Cynthia Shelton; and secondary literature about race and poor relief in Philadelphia. Through a historical contextualization of the high percentage of deaths among black inmates, I argue that, for many poor blacks, the Philadelphia Almshouse was not shelter but a place of death: the last stop in a long road of struggle against poverty, disease, and racism.

## Data Sources

### Almshouse Admissions Philadelhia 1796-1803
Smith created this dataset from a microfilm of the Index of Admissions to the Philadelphia Almshouse housed in the Philadelphia City Archives. It is a sample of 1400 entries taken from the years 1796-1803 including last names A through G, as well as a small number of "black" and "mulatto" individuals without last names. The original dataset can be found here: https://repository.upenn.edu/mead/42/.

This dataset uses numeric codes for the Descriptions.by.Clerk and Reason.Discharged columns. I downloaded the "Codebook Almshouse Admissions 1796-1803.doc" file from the original repository and converted the code lists to tables in Word before uploading it to this repository. Then I scraped the content from the Word doc using the `docxtractr` package: https://github.com/hrbrmstr/docxtractr.

The dataset also includes a file called "Occupational Codes Philadelphia Data.xlsx" but I did not use it because there is no Occupation column in the "Almshouse_Admissions_1796_1803.xlsx" file.

### Daily Occurrence Docket
Billy G. Smith and Cynthia Shelton selected, transcribed, and published entries from the Daily Occurrence Docket of the Philadelphia Almshouse, 1800-1804. These can be found in the journal *Pennsylvania History* as well as Smith's book *Life in Early Philadelphia*. The vignettes of Sarah and Ann Bordley and James Breahere come from this source. See Bibliography for citations.

## Data Manipulation
This repository contains my modified version of Smith's Almshouse Admissions dataset as almshouse_admissions.csv. All original columns are retained. I added three new columns.

### Description
This column contains the descriptions matching the codes in the Descriptions.by.Clerk column. The codes can be found in the "Codebook Almshouse Admissions 1796-1803 - with tables.docx" uploaded to this repository.

### Reason.for.Discharge
This column contains the reasons for discharge matching the codes in the Reason.Discharged column. The codes can be found in the "Codebook Almshouse Admissions 1796-1803 - with tables.docx" uploaded to this repository.

### Race
This column contains the races of the inmates: Black, Mulatto, and White. All inmates whose descriptions contain the word "black" are listed as Black and those whose descriptions contain the word "mulatto" are listed as Mulatto. In contrast to Gary B. Nash, I have chosen not to include inmates described as "mulatto" under the term "Black," unless the description reads "black or mulatto," in which case I did include them under "Black." The grouping of black and mulatto inmates together does not alter the conclusions I have drawn.

Note that the inmates classified as White are simply those not described explicitly as "black" or "mulatto". I debated whether to use a different name for this category, such as NA, Unknown, or Non-Black, but I decided on White under the assumption that the almshouse clerk would have chosen the most "obvious" descriptor for each individual. I acknowledge that classifying these inmates as White by process of elimination is problematic, but lacking access to the original archival materials, I made this choice.

### Category
For the barplot showing Almshouse Inmate Outcomes by Category, I created five subsets of inmate data. Each of these subsets, as well as the combination of subsets used in the barplot, has an additional column called Category. Inmates with a listed gender of male were assigned to the "Males" category, inmates with a listed gender of female to the "Females" category, inmates described as "child", "foundling", or "born" to the "Children" category, inmates described as "black" to the "Black" category, and inmates described as "irish" to the "Irish" category.

## Data Visualization

### Pie Chart
I am aware that pie charts are not held in high esteem by some members of the R community, i.e., https://www.data-to-viz.com/caveat/pie.html. However, I made the decision to use a pie chart to visualize the racial composition of the almshouse inmate population because there are only three percentages and they are easily distinguished.

## Additional Files
You will notice three additional files called FinalProject - Data Preprocessing.Rmd, FinalProject - ExploratoryDataAnalysis.Rmd, and FinalProject - TextAnalysis.Rmd. Descriptions are below.

### FinalProject - Data Preprocessing.Rmd
This file contains my initial work to read in the Codebook and match up the numeric codes with the descriptions. There is also a commented-out section where I attempted (and failed) to read in a pdf of the journal article containing the Daily Occurrence Docket entries. I wanted to try to extract the entries and save them as individual .txt files but it turned out to be quite complicated. I ended up copying the entries manually to a Word doc.

### FinalProject - ExploratoryDataAnalysis.Rmd
This file contains most of my work before writing the essay. Here I explored the almshouse_admissions dataset, finding the percentage distributions of various categories and creating subsets. I used some of this code in FinalProject.Rmd. I also used this file as a scratch pad to store discarded code from FinalProject.Rmd.

### FinalProject - TextAnalysis.Rmd
This file records my attempts at text analysis of the Daily Occurrence Docket entries. After copying the entries manually to a Word doc, I then copied them again into individual .txt files, packaged them into a .zip file, and uploaded them to this repository along with a metadata .csv file. Unfortunately, the corpus was simply too small for any meaningful analysis. I don't think I ever got more than 10k words. While I ended up deleting the .txt files and metadata file to reduce clutter in the repository, I think it would be worthwhile to try text analysis again using more Daily Occurrence Docket entries. If a researcher has access to the original archival materials, they could create a much larger corpus, which would hopefully be more amenable to methods like topic modeling. My original goal was to find patterns in the language used to describe inmates by race, gender, or physical condition over time. I still think this could be a interesting project with a larger corpus.