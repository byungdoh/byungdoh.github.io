# Title     : R Tutorial
# Objective : Introductory R
# Created by: Cory Shain
# Modified by: Byung-Doh Oh
# Modified on: 9/22/2022 (string concatenation and df subsetting)


"
Why R?

- High-level, user-friendly scripting language
- The standard for open-source statistical computing
- Huge user community, lots of libraries for all kinds of tasks

To really learn R or improve skills, Swirl is strongly recommended by Cory:
https://swirlstats.com/

DataCamp is recommended by me:
https://datacamp.com/
"

"
<Basic interface>
- Two main components: SOURCE and CONSOLE
  1) SOURCE: notepad for code, where you write code
  2) CONSOLE: the heart of R, where code is executed
  
- If you use RStudio, you get two more panes
  3) ENVIRONMENT: keeps track of variables you save (useful)
  4) FILES: lets you navigate directory

- How to execute code:
  1) Run selection from SOURCE
  2) Directly type to CONSOLE
"

###########################################
#
#  Basic arithmetic
#
###########################################

# Addition, Subtraction, Multiplication, Division
78 + 987
54 - 12
32 * 17
93 / 31

# Exponentiation
4 ^ 7
sqrt(81)

# Logarithms
# by default, the natural logarithm (base is e = 2.7182...)
log(82)
log(82, base=10)
log(82, 10)

# If you're unfamilar with a function, use help()
help(log)

###########################################
#
#  Variables and data types
#
###########################################

# Assignment of variable: <- or =
# <- is the more traditional way to do it
x <- 10
x

y = 10
y

# Compare whether LHS and RHS are equal: ==
x == y

x = x ^ 3
x

x == y

# Assignment using =, comparison using == 
my_var = x
my_var == x

x = log(x, 10)
x

my_var == x

# Variable types: numeric, character, logical
my_str = 'Hello World!'
my_str + my_var

# To avoid mistakes like this, use class() to check variable type
class(x)
class(my_str)
class(x == y)

# Will this work?
my_new_str = "Hello it's me"
my_str + my_new_str

paste(my_str, my_new_str)

###########################################
#
#  Control statements
#
###########################################

# if, else if, else
# execute "if" statement is true
x = 8

if (x < 10) {
    print('Little x')
} else if (x < 20) {
    print('Medium x')
} else {
    print('Big x')
}

# While loops
# execute "while" statement is true
x = 1

while (x <= 10) {
    print(x^2)
    x = x + 1
}

# For loops
# execute "for" each element
for (x in 1:10) {
    print(x^2)
}

###########################################
#
#  Vectorization
#
###########################################

# What if we need arrays of numbers?
# We could define them using a loop.

# First, initialize the array (here, with 10 elements)
x = numeric(10)

# Then loop over elements and assign values
for (i in 1:10) {
    x[i] = i^2
}

# Check the result
x

# BUT...
# R makes working with arrays like this much easier and more efficient.
# All of the above can be replaced with:
x = (1:10) ^ 2

# Check the result
x

# Doing math directly on arrays is called "vectorization".
# Most math operations in R support vectorization.

# For example, the following modify each element of the array

# Addition, subtraction, multiplication, division
x + 17
x - 100
x * 45
x / 3

# Exponentiation
x ^ 3
sqrt(x)

# Logarithms
log(x)
log(x, 10)

# We can also do element-wise operations on multiple vectors.
# Let's define another vector, this one with values sampled from a random uniform distribution.
y = runif(10)
y

# Add x and y elementwise
x + y

# Multiply x and y elementwise
x * y

# Take the logarithm of each element of x with the corresponding element of y as the base
log(x, y)

# Ways of creating arrays
# 1) More convenient: range operator (integer arrays)
x = 1:10
x

# 2) More powerful: seq() function
# Different increments
x = seq(1, 10, 2) # From 1 to 10, stepping by 2
x
x = seq(10, 1, -2) # From 10 to 1, stepping by -2 (negative increments descend)
x
x = seq(2, 3, 0.2) # From 2 to 3, stepping by 0.2
x
x = seq(2, 3, length=6) # From 2 to 3, with (6-1) equal-sized steps (i.e. step size = 0.2)
x

# 3) More general: c() function
x = c(1, 2, 3, 4, 9)
x
y = c(1, 2, 3, 4, 9.1)
y

# Combining multiple arrays into one: c() function
z = c(x, y, 75)
z

###########################################
#
#  Visualization
#
###########################################

# Data visualization in R is a big topic in its own right.
# For most applications you'll want to learn how to use a library like ggplot2.
# Here we'll just use the basic plot() function.

# Plot a parabola
x = seq(-2, 2, length=1000)
y = x^2
# Feed x, y coordinates
plot(x, y)

# Plot the natural logarithm
dev.new() # Resets the plotting canvas
x = seq(1e-5, 2, length=1000)
y = log(x)
plot(x, y)

###########################################
#
#  Using tabular data
#
###########################################

# Install packages using install.packages(packagename)
install.packages('lme4')
install.packages('languageR')

# Call packages for use with library()
# Let's get some psycholinguistic datasets
library('languageR')

# The languageR package provides the lexdec dataset with data from a lexical decision experiment (Baayen et al., 2006)
lexdec

# If the authors provide documentation, you can view it with "?", like this:
?lexdec

# Imagine lexdec was our own data and we wanted to save it to disc.
# We can use write.csv()
# I'd like to save under the directory "r_tutorial"

# Check current working directory (wd)
getwd()
# Change it to current_dir/r_tutorial
setwd("r_tutorial")
getwd()
# Then save as "lexdec.csv"
write.csv(lexdec, file="lexdec.csv")

# Now imagine we've already written lexdec.csv and we want to load it into R.
# We can use read.csv(). You may have to change your working directory accordingly.
df = read.csv("lexdec.csv")

# Now df is a variable that holds an identical dataset to lexdec after loading in from disc.
# read.csv() is a more realistic example of how you'll typically load data, since your
# data probably won't come from a public R library like languageR.

# What is the type of df?
class(df)

# df is a data.frame, which is a table of data with rows for data entries and columns for data properties.
# Each column is a vector. If it is numeric, we can do math with it.

# Let's check the actual data...
df

# That's a lot. You can use head() instead for the first few lines...
head(df)
head(df, 10)

# tail() for the last few lines...
tail(df)
tail(df, 10)

# dim() for the number of rows and number of columns...
dim(df)

# names() for the column names...
names(df)

# and summary() for some summary statistics...
summary(df)

# Access a data column using the "$" operator. For example, to get word frequencies, we can do:
df$Frequency

# Descriptive statistics of a column
mean(df$Frequency)
sd(df$Frequency)
var(df$Frequency)
min(df$Frequency)
max(df$Frequency)
median(df$Frequency)
range(df$Frequency)
quantile(df$Frequency)

# Unique values of a column
unique(df$Word)
unique(df$Subject)
# If you want to count how many...
length(unique(df$Word))
length(unique(df$Subject))

# It's common to standardize (z-transform) predictors before analyzing them.
# We can do this with the scale() function
scale(df$Frequency)

# We can also save our preprocessed variable to a new variable name for easy access
df$FrequencyZ = scale(df$Frequency)

# Now our df has 29 columns
dim(df)

# Sometimes we have to throw out precious data if they are outliers
# We can subset our data frame according to various conditions ("logical" type)
df_male = df[df$Sex == "M",]
df_female = df[df$Sex == "F",]

# Chaining conditions with logical operators
df_male_and_eng = df[df$Sex == "M" & df$NativeLanguage == "English",]
df_male_or_eng = df[df$Sex == "M" | df$NativeLanguage == "English",]

# Maybe a more realistic use case
df_filtered = df[(mean(df$RT) - 2.5*sd(df$RT) < df$RT) & (df$RT < mean(df$RT) + 2.5*sd(df$RT)),]

# This makes it easy to preprocess your data as needed before analyzing it
# According to the documentation, RT and Frequency provided are actually log-transformed.
# How could we get the response time (RT) in raw ms? What about the raw word frequency count?

# Dataframes like this let us do statistical analyses, like linear regression...

###########################################
#
#  Regression
#
###########################################

"
The researcher is responsible for interpreting the results of statistical tests!
"

# In lexdec, the usual dependent variable is RT, or log reaction time in the lexical decision task.
# If we want to just look at the influence of categorical variables, we can run an ANOVA using the aov() command:
# Basic usage: DV ~ IV1 + IV2 + ...
m = aov(RT ~ Sex + NativeLanguage, data=df)
summary(m)

# What if the influence of Sex also depends on the influence of NativeLanguage?
# In other words, what if there is an interaction?
# Interaction term of IV1 and IV2: IV1:IV2
m = aov(RT ~ Sex + NativeLanguage + Sex:NativeLanguage, data=df)
summary(m)

# Easier syntax for the same model:
m = aov(RT ~ Sex * NativeLanguage, data=df)
summary(m)

# If we want to look at numeric and/or categorical variables, we can run a linear regression using the lm() command
# If we want to regress using every single variable in the dataset, we can do this:
m = lm(RT ~ ., data=df)
summary(m)

# This is model is WAY too complicated for this dataset!
# Let's narrow down the predictors a bit.
# How about Frequency, NativeLanguage, and Length?
m = lm(RT ~ Frequency + NativeLanguage + Length, data=df)
summary(m)

# How good are our predictions?
# Calculate mean squared error (MSE)
# resid(m) stores the residuals (actual value - predicted value) associated with each data point.
resid(m)
mean(resid(m)^2)

# The residuals in this model actually differ a lot by subject (participant).
# To see this, plot:
plot(factor(df$Subject), resid(m))
# factor(df$Subject) groups df$Subject according to its value,
# so that the points from participant A1, for example, can be grouped together.

# Many subjects have non-zero mean residuals, and some have more spread out residuals than others.
# This is because different subjects have different base response rates and different ranges of responses,
# but our model hasn't taken this into account.

# When our experimental sample contains variation due to random properties of the sample (e.g. the participants)
# rather than population-level properties of the phenomenon (how frequency influences lexdec RTs),
# we can account for this with mixed-effects models that control for this random variation.

# We can run a linear mixed-effects model with the LMER command
library("lme4")
m = lmer(RT ~ Frequency + NativeLanguage + Length + (Frequency + NativeLanguage + Length | Subject), REML=FALSE, data=df)
summary(m)

# We have accounted for individual variation by including random effects for Frequency, NativeLanguage, and Length
# How does the mean squared error (MSE) and by-subject residual look now?
mean(resid(m)^2)
plot(factor(df$Subject), resid(m))

"
<Summary>
1) R makes it easy to load your data and perform various calculations
2) R has many built-in functions for basic statistical testing
3) R can also be used for fancy visualization, but this was not our focus today

Thanks for coming! Any questions?
"
