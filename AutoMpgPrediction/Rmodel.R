# Load required libraries
library(ggplot2)
library(caret)
# library(corrplot)

# Read the CSV file into a data frame
df <- read.csv("./data/auto-mpg.csv", stringsAsFactors = FALSE)

# Show first few rows and structure (similar to head() and info())
head(df)
str(df)

# Check unique values of model year (note: column names may have been modified)
unique(df$model.year)  # In R, spaces are replaced by dots if not quoted

# Convert horsepower to numeric (some values might be non-numeric)
df$horsepower <- as.numeric(df$horsepower)

# Replace NA (from non-numeric conversion) with 0, then replace 0's with mean horsepower
df$horsepower[is.na(df$horsepower)] <- 0
# Calculate mean excluding zeros (if needed) or use overall mean from the column
hp_mean <- mean(df$horsepower[df$horsepower != 0])
df$horsepower[df$horsepower == 0] <- hp_mean

# Convert columns to integer type (R doesn't have int8/int16 so we use integer)
df$model.year <- as.integer(df$model.year)
df$cylinders  <- as.integer(df$cylinders)
df$horsepower <- as.integer(df$horsepower)

# Get a summary of the data (similar to describe())
summary(df)

# Remove the 'car name' column (assuming its column name is 'car.name')
data <- df[, !(names(df) %in% c("car.name"))]
head(data)

### Visualization: Bar Plots for MPG vs. Each Variable ###

# Define the variables to plot
variables <- c("cylinders", "displacement", "horsepower", "weight", "acceleration", "model.year", "origin")

# Set up a multi-panel plot (4 rows x 2 columns)
par(mfrow = c(4, 2), mar = c(4, 4, 3, 1))  # adjust margins

# Loop through each variable to create a bar plot
for (var in variables) {
  # Use a barplot with mpg as names; note that mpg is continuous so labels might be crowded
  barplot(height = data[[var]],
          names.arg = data$mpg,
          col = "skyblue",
          main = paste("MPG vs", var),
          xlab = "MPG",
          ylab = var,
          las = 2)  # rotate x-axis labels for clarity
  grid(nx = NA, ny = NULL)
}

# Turn off any unused panel (if any)
# (In this case, our layout is exactly 7 plots in 8 panels, so we clear the last one)
plot.new()

# Reset graphical parameters if needed
par(mfrow = c(1,1))

### Linear Regression Modeling ###

set.seed(32)
# Create a training/test split (80% train, 20% test)
train_index <- sample(seq_len(nrow(data)), size = 0.8 * nrow(data))
train <- data[train_index, ]
test  <- data[-train_index, ]

# Fit a linear regression model predicting mpg from all other variables
lm_model <- lm(mpg ~ ., data = train)

# Get R^2 on test data
pred <- predict(lm_model, newdata = test)
mse <- mean((test$mpg - pred)^2)
r2  <- 1 - sum((test$mpg - pred)^2) / sum((test$mpg - mean(test$mpg))^2)

cat("Test MSE:", mse, "\n")
cat("Test R^2:", r2, "\n")

### 5-Fold Cross-Validation for Linear Regression ###

# Define cross-validation settings
set.seed(32)
ctrl <- trainControl(method = "cv", number = 5)

# Train the model using caret
cv_lm <- train(mpg ~ ., data = data, method = "lm", trControl = ctrl)
print(cv_lm)
cat("Mean R^2 from 5-fold CV:", cv_lm$results$Rsquared, "\n")

### Polynomial Regression (Degree = 2) ###

# In R, you can add polynomial terms via poly(..., degree=2, raw=TRUE)
# Create a formula with polynomial terms for each predictor
poly_formula <- mpg ~ poly(cylinders, 2, raw = TRUE) +
  poly(displacement, 2, raw = TRUE) +
  poly(horsepower, 2, raw = TRUE) +
  poly(weight, 2, raw = TRUE) +
  poly(acceleration, 2, raw = TRUE) +
  poly(model.year, 2, raw = TRUE) +
  poly(origin, 2, raw = TRUE)

# Fit the polynomial model on the training set
poly_model <- lm(poly_formula, data = train)
poly_r2 <- summary(poly_model)$r.squared

cat("Polynomial Model (Degree 2) R^2 on Training Data:", poly_r2, "\n")

# Evaluate on test set
poly_pred <- predict(poly_model, newdata = test)
poly_test_r2 <- 1 - sum((test$mpg - poly_pred)^2) / sum((test$mpg - mean(test$mpg))^2)
cat("Polynomial Model (Degree 2) R^2 on Test Data:", poly_test_r2, "\n")

# Cross-validation for the polynomial model using caret
set.seed(32)
cv_poly <- train(poly_formula, data = data, method = "lm", trControl = ctrl)
print(cv_poly)
cat("Mean R^2 from 5-fold CV for Polynomial Model:", cv_poly$results$Rsquared, "\n")
