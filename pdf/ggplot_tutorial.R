# Title     : ggplot2 Tutorial
# Objective : Introductory ggplot2
# Created by: Cory Shain
# Modified by: Byung-Doh Oh
# Modified on: 2/19/2023

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

"
<Focus of this tutorial>
- How ggplot2 works and what its basic commands are
  
<Not the focus of this tutorial>
- How to best visualize data for your ground-breaking research
"

# Install packages using install.packages(packagename)
# install.packages("ggplot2")
# install.packages("languageR")

# Load libraries
library(ggplot2)
library(languageR)

# The languageR package provides the lexdec dataset with data from a lexical decision experiment (Baayen et al., 2006)
# Inspect the "lexical decision" dataset
lexdec

# If the authors provide documentation, you can view it with "?", like this:
?lexdec

# In order to use your own data, use read.csv(). You may have to change your working directory accordingly.
# getwd()
# setwd("r_tutorial")
# df = read.csv("lexdec.csv")

# We want to explain variance in log reaction time (lexdec$RT).
# We have several linguistic variables that might explain this, but first, let's check for a low-level confound.
# Do people just speed up overall during the experiment?
lexdec$Trial
lexdec$RT

# Staring at raw numbers doesn't help very much.
# Let's conduct a "visual inspection."

"
official cheatsheet: https://github.com/rstudio/cheatsheets/blob/main/data-visualization-2.1.pdf
"

# First, define a plotting canvas with "Trial" on x-axis and "RT" on y-axis.
# The canvas is defined using the "ggplot" function, with a dataset and a set of "aes"thetic mappings.
g_trial = ggplot(lexdec, aes(x=Trial, y=RT))

# Then plot points
# "geom_"s are visual marks that represent data points.
g_trial + geom_point()

# Is there a trend? Hard to tell. Let's put a trend line in there:
g_trial + geom_point() + geom_smooth()

# Slight speedup, but we can probably safely ignore it.
# Now, how does word frequency affect reaction times?

# Set up plotting canvas
# Note that we need to define a new canvas because the x-axis is different.
g_freq = ggplot(lexdec, aes(x=Frequency, y=RT))

# Make a scatterplot
g_freq + geom_point()

# I don't like the gray grid. I'm going to add a "theme."
# First, redefine canvas g_freq so the theme always applies:
g_freq = g_freq + theme_classic()

# Then replot:
g_freq + geom_point()

# That's better.
# Anything weird about this plot? Try this:
sort(exp(lexdec$Frequency))

# They're all integers! So the apparent bins come from integer counts.

# Is there a relationship? Let's plot a trend.
g_freq + geom_point() + geom_smooth()

# That gave us a wiggly curve. Let's force it to be a line.
g_freq + geom_point() + geom_smooth(method="lm")

# So RTs are overall faster for more frequent words.
# Is this true for every participant?
# Let's use "facet"s to generate subplots based on discrete variables.
g_freq + geom_point() + geom_smooth(method="lm") + facet_wrap(~Subject, ncol=9)

# Are there effects of participant gender?
g_freq + geom_point() + geom_smooth(method="lm") + facet_wrap(~Sex, ncol=2)

# I don't like the little solid black points. How about bigger transparent pink ones?
g_freq + geom_point(color="pink", alpha=1/2, size=4) + geom_smooth(method="lm") + facet_wrap(~Sex, ncol=2)

# We can also make colors be a function of group and put these on one plot, using aes().
g_freq + geom_point(aes(color=Sex), alpha=1/2, size=4) + geom_smooth(method="lm", aes(color=Sex))

# This really helps show that gender doesn't seem to be a factor in this study.
# What about whether the participant is a native English speaker?

# First, let's check overall differences in a violin plot.
# Again, note that we need to define a new canvas because the x-axis is different.
ggplot(lexdec, aes(x=NativeLanguage, y=RT)) + geom_violin() + theme_classic()

# Seems like there may be a small difference in mean RT.
# Maybe there's also a difference in sensitivity to frequency?
g_freq + geom_point(aes(color=NativeLanguage), alpha=1/2, size=4) + geom_smooth(method="lm", aes(color=NativeLanguage))

# Looks like native speakers aren't as affected by frequency.
# Maybe there's an interaction between gender and native/non-native?
# To check, we can plot a facet grid:
g_freq + geom_point(alpha=1/2, size=4) + geom_smooth(method="lm") + facet_grid(Sex ~ NativeLanguage)

# We can also add "marginal" facets showing the totals within each group:
g_freq + geom_point(alpha=1/2, size=4) + geom_smooth(method="lm") + facet_grid(Sex ~ NativeLanguage, margins=TRUE)

# The marginal plots show miniature versions of some of the plots we've already made.
# There doesn't seem to be an interaction.

# For bar plots, it's easiest to aggregate the data yourself first.
# We'll use the dplyr package to make this easier.

"
dplyr is a grammar of data manipulation, providing a consistent set of verbs that help you solve the most common data manipulation challenges:
official documentation: https://dplyr.tidyverse.org/index.html
official cheatsheet: https://github.com/rstudio/cheatsheets/blob/main/data-visualization-2.1.pdf
"

#install.packages('dplyr')
library(dplyr)

# We can group our data like this:
by_lang = group_by(lexdec, NativeLanguage)

# And we can summarize the group stats using pipes (%>%), which is a special operator in dplyr.
# x %>% f(y)
by_lang %>% summarize(Mean=mean(RT))

# This is equivalent to...
# f(x, y)
summarize(by_lang, Mean=mean(RT))

# We can add as many summaries as we want.
by_lang %>% summarize(Mean=mean(RT), Lower=quantile(RT, 0.025), Upper=quantile(RT, 0.975), SD=sd(RT))

# Let's save this summary so it's easy to plot it.
by_lang = by_lang %>% summarize(Mean=mean(RT), Lower=quantile(RT, 0.025), Upper=quantile(RT, 0.975), SD=sd(RT))

# Now we can make a bar plot with 95% confidence intervals.
# First, set up a plotting canvas:
g_bar = ggplot(by_lang, aes(x=NativeLanguage, y=Mean)) + theme_classic()

# Then plot:
# geom_bar will try to aggregate the count within groups by default.
# However, since we already calculated the means using dplyr,
# we're going to directly plot the value itself using stat="identity".
g_bar + geom_bar(stat="identity")

# Now we can add error bars
g_bar + geom_bar(stat="identity") + geom_errorbar(aes(ymin=Lower, ymax=Upper))

# The information is there but it looks atrocious.
# Here's some styling:
g_bar + geom_bar(stat="identity", fill="cyan", size=2, color="gray") + geom_errorbar(aes(ymin=Lower, ymax=Upper), size=2, color="gray", width=0.25)

# This is better, but the labels aren't great.
# The y axis shouldn't be called "Mean", since it actually shows intervals over RT measures.
# The x axis label lacks a space, and there's no plot title.
# We can change all this with the labs() function ("labels").
g_bar + geom_bar(stat="identity", fill="cyan", size=2, color="gray") + geom_errorbar(aes(ymin=Lower, ymax=Upper), size=2, color="gray", width=0.25) + labs(title="Reaction time by native language", x="Native Language", y="Log RT")

# Annoyingly, the title is left-justified.
# There's a verbose hack to fix this:
# The theme() function customizes various properties of the theme such as axis, legend, etc.
g_bar + geom_bar(stat="identity", fill="cyan", size=2, color="gray") + geom_errorbar(aes(ymin=Lower, ymax=Upper), size=2, color="gray", width=0.25) + labs(title="Reaction time by native language", x="Native Language", y="Log RT") + theme(plot.title = element_text(hjust = 0.5))

# We can also remove axis labels altogether by setting them to "NULL".
g_bar + geom_bar(stat="identity", fill="cyan", size=2, color="gray") + geom_errorbar(aes(ymin=Lower, ymax=Upper), size=2, color="gray", width=0.25) + labs(title="Reaction time by native language", x=NULL, y="Log RT") + theme(plot.title = element_text(hjust = 0.5))

"
<Summary>
1) ggplot2 allows visualization of your data
2) Start with ggplot(), supply a dataset and aesthetic mappings, and then add on layers (geom, theme, facet, etc.)
3) With basic knowledge covered today, refer to the cheatsheet and try to modify examples to suit your needs

Thanks for coming! Any questions?

Lots of ggplot2 docs and tutorials: https://ggplot2.tidyverse.org/
Additional interactive self study: https://swirlstats.com/
"
