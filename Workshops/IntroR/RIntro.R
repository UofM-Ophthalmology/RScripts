
setwd()

library(ggplot2)

# Here we will be introducing R and some it's basic functions
#
# When "#" appears in the code chunks everything after the "#" in that line is ignored. It's useful for commenting code.
#
# In the text "#" creates an outline in RStudio and a header in the output document.
#
# # Basics

# Ctrl + Enter runs the lines of code your cursor is on.

# The green button at the the top right of the code block runs everything in the code block.


## Math

5+5

# Variables
x <- 21
y <- 4

# More math
x/y


## Data Types
# Using the c() function to combine elements into a vector.
# Vector assigned with c()

char_ <- c('One','Two','Three')

class(char_)

char_[1]

number_index <- 1:10

number_index

class(number_index)

num_index <- c(1.2,1.6,1088934)

class(num_index)

paste0(char_[1],' = ', number_index[1])


# Another data type which is used in plotting are factors.

fctr <- c('Tom','John','Karen')
class(fctr)
fctr
as.factor(fctr)

# We will come back to this when plotting.

## Subsetting
# %% gives us the remainder after dividing
number_index %% 2

even_index <- number_index[number_index %% 2 == 0]
even_index

## For loops

# Looping through 1 to 10
for (i in 1:10){
  print(i) # printing out the variable
}

## If statements

# Same for loop as before
for (i in 1:10){
  i # without a print statement this isn't outputted
  if (i == 2){ # if i = 2 do the following
    print(i) # print the variable
  }
}

# Same as above but we add an else variable
for (i in 1:10){
  i
  if (i == 2){
    print(i)
  }
  else{ # if the if condition isn't met this is performed
    print(paste0(i,' is not equal to ',2))
  }
}

# Loop through 10 to 20, if the number is divisible by 6 print that number

for(){

  if(){

  }

}

# # Data Frames with Iris

?iris

# Assigning iris to a different variable
df <- iris
# Check the dimensions of the data frame
dim(df) # row by col

# Look at the first six (default) rows of the data frame
head(df)

# Look at the last six (default) rows of the data frame
tail(df)

# Look at only the first two rows
head(df,2)

# Look at the columns of the data frame
colnames(df)

# Generating summary statistics for the different variables
# Count the number of entries

# "$" access the columns of the dataframe by name
table(df$Species)

# [,#] access the number of that column
table(df[,5])

table(df$Sepal.Length)
# table isn't as useful when look at numeric variables

class(df$Sepal.Length)

# Summary will summarize a numeric variable
summary(df$Sepal.Length)

## Writing and reading data


# Plotting

## Histograms

ggplot(df) + # calling ggplot on the data frame
  geom_histogram(aes(x = Sepal.Length)) # plotting Sepal length as a histogram


ggplot(df) + # calling ggplot on the data frame
  geom_histogram(aes(x = Sepal.Length), # plotting Sepal length as a histogram
                 bins = 20) + # changing the number of bins
  theme_bw() + # lots of themes to choose from (ex. theme_classic())
  xlab('Sepal Length') + # cleaning up x-axis label
  ylab('Count') + # changing y-axis label
  ggtitle('Histogram of Sepal Length') # Adding title


# Plot sepal width as a histogram with 5 bins and the classic theme.

## Density

ggplot(df, aes(x = Sepal.Length)) + # aes can be added to main ggplot call
  # to apply to all downstream ggplot calls
  geom_density() + # creating a density curve
  theme_bw()


ggplot(df, aes(x = Sepal.Length,
               color = Species)) + # adding a colour which will split the plot
  geom_density() + # creating a density curve
  theme_bw() +
  labs(colour = 'SPECIES') # changes the fill label from Species

## Scatter/Point

ggplot(df, aes(x = Sepal.Length,
               y = Sepal.Width,
               color = Species)) +
  geom_point() + # adding a point plot
  theme_bw()

ggplot(df, aes(x = Sepal.Length,
               y = Sepal.Width,
               color = Species)) +
  geom_point() + # adding a point plot
  theme_bw() +
  scale_color_manual(values = c('purple','darkred','orange'))

colnames(df)

ggplot(df, aes(x = Sepal.Length,
               y = Sepal.Width,
               shape = Species,
               color = Petal.Length)) +
  geom_point(size = 2) + # adding a point plot
  theme_bw()

ggplot(df, aes(x = Sepal.Length,
               y = Sepal.Width,
               shape = Species,
               color = Petal.Length)) +
  geom_point(size = 2) + # adding a point plot
  theme_bw() +
  scale_color_gradient(low = 'pink', high = 'darkred')

# Plot as scatter plot with petal length (x-axis) by petal width (y-axis) and color by Species. Manually choose colors for the Species.

ggplot()

# # Correlation & Linear Models
# Looking at the relationship between sepal length and sepal width.

# A similar plot to what we saw previously
ggplot(df, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() + theme_bw()

ggplot(df, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() + theme_bw() +
  geom_smooth(method = 'lm') # adding geom_smooth which creates a regression line
# lm stands for linear model

# Testing the correlation between two variables (default = Pearson correlation)
cor(df$Sepal.Length, df$Sepal.Width)

# cor.test provides you with more information than cor
cor.test(df$Sepal.Length, df$Sepal.Width)

?lm()
lm(data = df,
   formula = Sepal.Width ~ Sepal.Length)

model1 <- lm(data = df,
             formula = Sepal.Width ~ Sepal.Length)

model1

summary(model1)

# # Splitting by species
# Use the code above but color the plots by species to see how the results change.

ggplot(df, aes(x = Sepal.Length, y = Sepal.Width,
               color = Species)) +
  geom_point() + theme_bw()


ggplot(df, aes(x = Sepal.Length, y = Sepal.Width,
               color = Species)) +
  geom_point() + theme_bw() +
  geom_smooth(method = 'lm')

# Subsetting
species_df <- list()

for (i in levels(df$Species)){
  temp <- df[df$Species == i,]

  print(i)

  print(cor.test(temp$Sepal.Length, temp$Sepal.Width))

  species_df[[i]] <- temp
}

# We see when we split it up by species the correlation is significant between sepal length and sepal width.

species_df

pvals <- c()
for (i in names(species_df)){
  print(i)

  temp <- species_df[[i]]

  lm_ <- lm(data = temp, Sepal.Width ~ Sepal.Length)

  names(summary(lm_))
  summary(lm_)$coefficients
  print(summary(lm_)$coefficients)
  pvalue <- summary(lm_)$coefficients[1,4]

  pvals <- c(pvals, pvalue)
}



# T-test

ggplot(df, aes(x = Species, y = Petal.Length,
               fill = Species)) +
  geom_violin() + theme_bw()

ggplot(df, aes(x = Species, y = Petal.Length,
               fill = Species)) +
  geom_violin() + theme_bw() +
  geom_jitter()

?t.test()

combos <- combn(levels(df$Species),2)

combos

pvals <- c()
for (i in 1:dim(combos)[2]){
  print(i)

  species1 <- combos[1,i]
  species2 <- combos[2,i]

  print(paste0('Comparing ', species1,' vs ',
               species2))

  test_ <- t.test(df[df$Species == species1,]$Petal.Length,
                  df[df$Species == species2,]$Petal.Length)

  print(paste0('P-value = ',test_$p.value))

  diff <- test_$estimate[2] - test_$estimate[1]

  print(paste0('With an average difference of ', round(diff,2)))
}


# # Wilcoxon Rank Sum
# Non-parametric version of the t-test. This is what is used by default in the Seurat FindMarkers function.

?wilcox.test()


# Clustering

Basic clustering with k-means clustering.

## Kmeans

?kmeans


# Heatmaps

# For the heatmap
# What is the below code doing?
df$sample <- 1:dim(df)[1]

rownames(df) <- paste0(df$sample,'_', df$Species)

# Going from wide to long
temp <- reshape2::melt(as.matrix(df[,1:4]))

temp[temp$Var1 == '1_setosa',]

ggplot(temp) +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  theme_bw() +
  scale_fill_gradient(low = 'white', high = 'red') +
  xlab('Samples') + ylab('Metadata') +
  labs(fill = 'Value') +
  theme(axis.text.x = element_blank())


temp$Species <- data.table::tstrsplit(temp$Var1,'_', keep = 2)[[1]]
ggplot(temp) +
  facet_grid(cols = vars(Species),
             space = 'free', scales = 'free') +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  theme_bw() +
  scale_fill_gradient(low = 'white', high = 'red') +
  xlab('Samples') + ylab('Metadata') +
  labs(fill = 'Value') +
  theme(axis.text.x = element_blank())

temp <- reshape2::melt(as.matrix(scale(df[,1:4])))

temp[temp$Var1 == '1_setosa',]

ggplot(temp) +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  theme_bw() +
  scale_fill_gradient2(low = 'blue', mid = 'white', high = 'red') +
  xlab('Samples') + ylab('Metadata') +
  labs(fill = 'Scaled\nValue') +
  theme(axis.text.x = element_blank())


temp$Species <- data.table::tstrsplit(temp$Var1,'_', keep = 2)[[1]]
ggplot(temp) +
  facet_grid(cols = vars(Species),
             space = 'free', scales = 'free') +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  theme_bw() +
  scale_fill_gradient2(low = 'blue',  mid = 'white', high = 'red') +
  xlab('Samples') + ylab('Metadata') +
  labs(fill = 'Scaled\nValue') +
  theme(axis.text.x = element_blank())
