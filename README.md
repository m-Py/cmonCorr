# cmonCorr

Create correlations of a specified size by reshuffling a vector to (not) match another one. Can be used for visualisation and comparison of correlations and exploration of their properties.

# Installation

```R
devtools::install_github("einGlasRotwein/cmonCorr")

library("cmonCorr")
```

# Credit

Internal functions for input validation adapted from [prmisc](https://github.com/m-Py/prmisc) by [Martin Papenberg](https://github.com/m-Py).

# Examples

## sim_cor_vec

Reshuffles a vector to create a correlation of specified size with another one.

Takes one or two vectors as input. If only one is provided, the second vector is a duplicate of the first one.

```R
vec1 <- 1:100
vec2 <- 51:150

example1 <- sim_cor_vec(vector1 = vec1, vector2 = vec2, r = .2, shuffles = 100)

library(tidyverse)
example1$data %>%
  ggplot(aes(x = x, y = y)) +
  geom_point(colour = "#0c2c76", alpha = .6) +
  geom_smooth(method = "lm", colour = "#ff4600") +
  labs(title = paste("desired correlation", example1$desired_correlation, " - ",
                     "actual correlation", round(example1$actual_correlation, 2))) +
  theme(plot.title = element_text(hjust = .5))
```

![](https://raw.githubusercontent.com/einGlasRotwein/cmonCorr/master/examples/example1.png)

```R
vec1 <- 1:200

example2 <- sim_cor_vec(vector1 = vec1, r = .42, shuffles = 1000)
```

![](https://raw.githubusercontent.com/einGlasRotwein/cmonCorr/master/examples/example2.png)

## sim_cor_vec

**WARNING:** Experimental danger zone, as there will not always be error messages when parameters in arglist are not provided correctly. When in doubt, generate vectors to be correlated outside the function and then use `sim_cor_vec`.

Reshuffles a vector to create a correlation of specified size with another one.

Takes parameters for one or two vectors as input. If only parameters for one are provided, the second vector is created from the parameters of the first one.

```R
example3 <- sim_cor_param(100, "normal", list(mean = 10, sd = 1), r = .52, shuffles = 1000)
```

![](https://raw.githubusercontent.com/einGlasRotwein/cmonCorr/master/examples/example3.png)

```R
example4 <- sim_cor_param(100, "normal", list(mean = 10, sd = 1), r = -.8, shuffles = 100,
                          "unif", list(min = 1, max = 2))
```

![](https://raw.githubusercontent.com/einGlasRotwein/cmonCorr/master/examples/example4.png)
