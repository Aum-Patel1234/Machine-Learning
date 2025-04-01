# app.R
library(shiny)
library(ggplot2)
library(caret)

## GLOBAL: Data Loading, Cleaning, and Modeling ##
# Read the CSV file into a data frame (ensure the file is in the "data" folder)
df <- read.csv("./data/auto-mpg.csv", stringsAsFactors = FALSE)

# Convert horsepower to numeric (some values might be non-numeric)
df$horsepower <- as.numeric(df$horsepower)

# Replace NA (from non-numeric conversion) with 0, then replace 0's with mean horsepower
df$horsepower[is.na(df$horsepower)] <- 0
hp_mean <- mean(df$horsepower[df$horsepower != 0])
df$horsepower[df$horsepower == 0] <- hp_mean

# Convert columns to integer type
df$model.year <- as.integer(df$model.year)
df$cylinders  <- as.integer(df$cylinders)
df$horsepower <- as.integer(df$horsepower)

# Remove the 'car name' column (assuming its column name is 'car.name')
data <- df[, !(names(df) %in% c("car.name"))]

# Create training and test splits (80% train, 20% test)
set.seed(32)
train_index <- sample(seq_len(nrow(data)), size = 0.8 * nrow(data))
train <- data[train_index, ]
test  <- data[-train_index, ]

### Linear Regression Model ###
lm_model <- lm(mpg ~ ., data = train)
pred <- predict(lm_model, newdata = test)
mse <- mean((test$mpg - pred)^2)
r2  <- 1 - sum((test$mpg - pred)^2) / sum((test$mpg - mean(test$mpg))^2)

### 5-Fold Cross-Validation for Linear Regression ###
set.seed(32)
ctrl <- trainControl(method = "cv", number = 5)
cv_lm <- train(mpg ~ ., data = data, method = "lm", trControl = ctrl)

### Polynomial Regression (Degree = 2) ###
poly_formula <- mpg ~ poly(cylinders, 2, raw = TRUE) +
  poly(displacement, 2, raw = TRUE) +
  poly(horsepower, 2, raw = TRUE) +
  poly(weight, 2, raw = TRUE) +
  poly(acceleration, 2, raw = TRUE) +
  poly(model.year, 2, raw = TRUE) +
  poly(origin, 2, raw = TRUE)

poly_model <- lm(poly_formula, data = train)
poly_r2 <- summary(poly_model)$r.squared
poly_pred <- predict(poly_model, newdata = test)
poly_test_r2 <- 1 - sum((test$mpg - poly_pred)^2) / sum((test$mpg - mean(test$mpg))^2)

# Cross-validation for the polynomial model using caret
set.seed(32)
cv_poly <- train(poly_formula, data = data, method = "lm", trControl = ctrl)

## UI ##
ui <- fluidPage(
  titlePanel("Auto MPG Analysis and Modeling"),
  tabsetPanel(
    # 1. Prediction Tab (First Page)
    tabPanel("Predict",
             sidebarLayout(
               sidebarPanel(
                 h3("Input Parameters"),
                 numericInput("cylinders", "Cylinders:", value = 4, min = 3, max = 12),
                 numericInput("displacement", "Displacement:", value = round(mean(data$displacement)), min = 68, max = 455),
                 numericInput("horsepower", "Horsepower:", value = round(mean(data$horsepower)), min = 46, max = 230),
                 numericInput("weight", "Weight:", value = round(mean(data$weight)), min = 1613, max = 5140),
                 numericInput("acceleration", "Acceleration:", value = round(mean(data$acceleration),1), min = 8, max = 24),
                 numericInput("model.year", "Model Year:", value = round(mean(data$model.year)), min = min(data$model.year), max = max(data$model.year)),
                 numericInput("origin", "Origin (1: USA, 2: Europe, 3: Asia):", value = 1, min = 1, max = 3),
                 actionButton("predictBtn", "Predict MPG")
               ),
               mainPanel(
                 h3("Prediction Results"),
                 verbatimTextOutput("predictionOutput")
               )
             )
    ),
    # 2. Data Overview Tab
    tabPanel("Data Overview",
             fluidRow(
               column(6,
                      h3("Data Summary"),
                      verbatimTextOutput("dataSummary")
               ),
               column(6,
                      h3("First Few Rows"),
                      tableOutput("headData")
               )
             )
    ),
    # 3. Visualizations Tab
    tabPanel("Visualizations",
             sidebarLayout(
               sidebarPanel(
                 selectInput("var", "Select Variable for Bar Plot:",
                             choices = c("cylinders", "displacement", "horsepower", "weight", 
                                         "acceleration", "model.year", "origin"),
                             selected = "cylinders")
               ),
               mainPanel(
                 plotOutput("barPlot", height = "500px")
               )
             )
    ),
    # 4. Linear Regression Results Tab
    tabPanel("Linear Regression",
             fluidRow(
               column(6,
                      h3("Linear Model Summary"),
                      verbatimTextOutput("lmSummary")
               ),
               column(6,
                      h3("Test Metrics"),
                      verbatimTextOutput("lmMetrics")
               )
             )
    ),
    # 5. Polynomial Regression Results Tab
    tabPanel("Polynomial Regression",
             fluidRow(
               column(6,
                      h3("Polynomial Model Summary"),
                      verbatimTextOutput("polySummary")
               ),
               column(6,
                      h3("Test Metrics"),
                      verbatimTextOutput("polyMetrics")
               )
             )
    ),
    # 6. Cross-Validation Tab
    tabPanel("Cross-Validation",
             fluidRow(
               column(6,
                      h3("5-Fold CV: Linear Regression"),
                      verbatimTextOutput("cvLmSummary")
               ),
               column(6,
                      h3("5-Fold CV: Polynomial Regression"),
                      verbatimTextOutput("cvPolySummary")
               )
             )
    )
  )
)

## SERVER ##
server <- function(input, output, session) {
  
  # Prediction functionality
  prediction <- eventReactive(input$predictBtn, {
    # Create a new data frame based on input values
    newdata <- data.frame(
      cylinders   = as.integer(input$cylinders),
      displacement = input$displacement,
      horsepower  = as.integer(input$horsepower),
      weight      = input$weight,
      acceleration = input$acceleration,
      model.year  = as.integer(input$model.year),
      origin      = as.integer(input$origin)
    )
    # Predict using both models
    lm_pred <- predict(lm_model, newdata = newdata)
    poly_pred <- predict(poly_model, newdata = newdata)
    
    result <- paste0("Model Prediction: ", round(poly_pred, 2))
    return(result)
  })
  
  output$predictionOutput <- renderPrint({
    prediction()
  })
  
  # Data Overview outputs
  output$dataSummary <- renderPrint({
    summary(data)
  })
  
  output$headData <- renderTable({
    head(data)
  })
  
  # Visualization: Bar Plot for selected variable vs mpg
  output$barPlot <- renderPlot({
    var <- input$var
    barplot(height = data[[var]],
            names.arg = data$mpg,
            col = "skyblue",
            main = paste("MPG vs", var),
            xlab = "MPG",
            ylab = var,
            las = 2)
    grid(nx = NA, ny = NULL)
  })
  
  # Linear Regression outputs
  output$lmSummary <- renderPrint({
    summary(lm_model)
  })
  
  output$lmMetrics <- renderPrint({
    cat("Test MSE:", round(mse, 3), "\n")
    cat("Test R^2:", round(r2, 3), "\n")
  })
  
  # Polynomial Regression outputs
  output$polySummary <- renderPrint({
    summary(poly_model)
  })
  
  output$polyMetrics <- renderPrint({
    cat("Polynomial Model (Degree 2) R^2 on Training Data:", round(poly_r2, 3), "\n")
    cat("Polynomial Model (Degree 2) R^2 on Test Data:", round(poly_test_r2, 3), "\n")
  })
  
  # Cross-Validation outputs
  output$cvLmSummary <- renderPrint({
    cv_lm
  })
  
  output$cvPolySummary <- renderPrint({
    cv_poly
  })
}

## Run the Shiny App ##
shinyApp(ui = ui, server = server)
