# Lab 2 Script: Loading data and the grammar of graphics (ggplot2)
# The University of Texas at San Antonio
# URP-5393: Urban Planning Methods II


#---- Objectives ----
# In this Lab you will learn to:

# 1. Load datasets into your R session -> open the `Lab2_script.R` to go over in class.
# 2. Learn about the different ways `R` can plot information
# 3. Learn about the usage of the `ggplot2` package


#---- Part 1: Loading data ----

# Data can be loaded in a variety of ways. As always is best to learn how to load using base functions that will likely remain in time so you can go back and retrace your steps. 
# This time we will load two data sets in three ways.


## ---- Part 1.1: Loading data from R pre-loaded packages ----

data() # shows all preloaded data available in R in the datasets package
help(package="datasets")#introduction of package dataset
help(package="Orange")#introduction of package Orange

#Let's us the Violent Crime Rates by US State data 

help("USArrests")#introduction of data "USArrest"

# Step 1. Load the data in you session by creating an object

usa_arrests<-datasets::USArrests # this looks the object 'USAarrests' within '::' the package 'datasets'
#:: means looking the specific object or function in one package

class(usa_arrests)#the type or usa_arrests,returning "data frame"
names(usa_arrests)#access the column names,returning "Murder"   "Assault"  "UrbanPop" "Rape" 
dim(usa_arrests)#dimension of the data frame,with 50 rows and 4 columns
head(usa_arrests)#first five lines of the data frame
tail(usa_arrests)#last five lines of the data frame

## ---- Part 1.2: Loading data from your computer directory ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512

building_permits_sa<-read.csv(file = "datasets/accelaissuedpermitsextract.csv",header = T)#load csv to r and convert it into data frame,and regard the first line as column name

names(building_permits_sa)#column name,returning "PERMIT.TYPE"        "PERMIT.."           "PROJECT.NAME" ... 
View(building_permits_sa)#view the data frame
class(building_permits_sa)#type,returning "data frame"
dim(building_permits_sa)#dimension,5232 rows and 16 columns
str(building_permits_sa)
#structure of the data frame,including type,dimension,column name ,column type and several characters
summary(building_permits_sa)#abstract of each column,including min,max,mean...



## ---- Part 1.3: Loading data directly from the internet ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512

building_permits_sa2 <- read.csv("https://data.sanantonio.gov/dataset/05012dcb-ba1b-4ade-b5f3-7403bc7f52eb/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512/download/accelaissuedpermitsextract.csv",header = T) 
#loading csv from internet and convert to the data frame

#testst

## ---- Part 1.4: Loading data using a package + API ----
#install.packages("tidycensus")
#install.packages("tigris")
install.packages("tidycensus")
help(package="tidycensus")#instruction of package
library(tidycensus)
library(tigris)


#type ?census_api_key to get your Census API for full access.

age10 <- get_decennial(geography = "state", #get decennial Census data,geographical level=state
                       variables = "P013001", #"varible code,meaning Median Age
                       year = 2010)#year

head(age10)#first five lines


bexar_medincome <- get_acs(geography = "tract", variables = "B19013_001",
                           state = "TX", county = "Bexar", geometry = TRUE)#get median household income,geographical level=tract


View(bexar_medincome)#view the data

class(bexar_medincome)#returning single features(geographic) and data frame. 

#---- Part 2: Visualizing the data ----
#install.packages('ggplot2')

library(ggplot2)



## ---- Part 2.1: Visualizing the 'usa_arrests' data ----

ggplot()#define a drawing object

#scatter plot - relationship between two continuous variables
ggplot(data = usa_arrests,mapping = aes(x=Assault,y=Murder)) +
  geom_point()#scatter plot,x axle is assault,y axle is murder
#define global data and aesthetics mapping,then loading different plot(here is geom_point plot)

ggplot() +
  geom_point(data = usa_arrests,mapping = aes(x=Assault,y=Murder))
#define a blank drawing object and add different plots,(here is the scatter plot of usa_arrests)

#bar plot - compare levels across observations
usa_arrests$state<-rownames(usa_arrests)#
usa_arrests$state#extract column name

ggplot(data = usa_arrests,aes(x=state,y=Murder))+
  geom_bar(stat = 'identity')#bar plot,y = the number of Murder

ggplot()+geom_bar(data = usa_arrests,aes(x=state,y=Murder),stat='identity')#another syntax

ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder))+
  geom_bar(stat = 'identity')+
  coord_flip()#x axis is state ,ordered by murder,and flip the axises

# adding color # would murder arrests be related to the percentage of urban population in the state?
ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder,fill=UrbanPop))+
  geom_bar(stat = 'identity')+
  coord_flip()#let the bars' color be based on the urban population,fill means color

# adding size
ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()
#let the size of points be based on the urban population(introduce the third varible?)

# plotting by south-east and everyone else 

usa_arrests$southeast<-as.numeric(usa_arrests$state%in%c("Florida","Georgia","Mississippi","Lousiana","South Carolina"))
#check if usa_arrests$state belongs to c("Florida","Georgia","Mississippi","Lousiana","South Carolina"),and  translate bollean into number

ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop, color=southeast)) +
  geom_point()#the correlation between assault and murder,point size is based on urban pop,and color is based on southeast

usa_arrests$southeast<-factor(usa_arrests$southeast,levels = c(1,0),labels = c("South-east state",'other'))#change data into categorical variable based on 1 and 0

ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_wrap(southeast~ .)#divide into 2 plots based on southeast&others


ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_grid(southeast ~ .)#create a subgraph based on the specified southeast

## ---- Part 3: Visualizing the spatial data ----
# Administrative boundaries


library(leaflet)
library(tigris)

bexar_county <- counties(state = "TX",cb=T)#get geographic boundary data for U.S. counties,cb means simplified boundary
bexar_tracts<- tracts(state = "TX", county = "Bexar",cb=T)#get geographic boundary data for tracts in Bexar county
bexar_blockgps <- block_groups(state = "TX", county = "Bexar",cb=T)#get geographic boundary data for block_groups
#bexar_blocks <- blocks(state = "TX", county = "Bexar") #takes lots of time


# incremental visualization (static)

ggplot()+
  geom_sf(data = bexar_county)#visualize counties' boundary

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",]#select Bexar's boundary

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",])+
  geom_sf(data = bexar_tracts)#the boundary of bexar and the boundary of all the tracts

p1<-ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",],color='blue',fill=NA)+
  geom_sf(data = bexar_tracts,color='black',fill=NA)+
  geom_sf(data = bexar_blockgps,color='red',fill=NA)#bexar boundary,the line is blue and no fill;tracts' boundary and blockgps with red lines

ggsave(filename = "02_lab/plots/01_static_map.pdf",plot = p1) #saves the plot as a pdf




# incremental visualization (interactive)

#install.packages("mapview")
install.packages("mapview")
library(mapview)

mapview(bexar_county)#interactive map

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)#interactive map of the boundaries of bexar and bexar_tract

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)+
  mapview(bexar_blockgps)#interactive maps of boundaries of bexar and bexar census tracts and bexar blockgps


#another way to vizualize this
leaflet(bexar_county) %>%
  addTiles() %>%#add open street map
  addPolygons()#add polygon-bexar_county

names(table(bexar_county$NAME))#creat the frequency frame of county names and then extract the names

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons()#creat the boundary of bexar_county

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%#choose bexar county
  addTiles() %>%#add open street map
  addPolygons(group="county")%>%#add polygon
  addPolygons(data=bexar_tracts,group="tracts") %>%#add census tracts boundary
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups")#add blockgps boundary

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%#load bexar county's boundary
  addTiles() %>%
  addPolygons(group="county")%>%#add group "county"
  addPolygons(data=bexar_tracts,group="tracts") %>%#add census tracts and group them as "tracts"
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups") %>%#add blockgps and group them as block groups,color=#eeeeee,line weight=1
  addLayersControl(
    overlayGroups = c("county", "tracts","block groups"),#three layers can be controlled
    options = layersControlOptions(collapsed = FALSE)#open the layer contorller
  )



