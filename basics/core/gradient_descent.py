import numpy as np
import pandas as pd
import openpyxl as op
import matplotlib.pyplot as plt

class GradientDescent():
    data:pd.DataFrame = None
    X:pd.Series = None
    Y:pd.Series = None

    def __init__(self,filePath):
        self.data = pd.read_excel(filePath)
        print(self.data)


    def gradientDescent(self,x,y,learning_rate = 0.01,iterations=3000):
        self.X = self.data[x]
        self.Y = self.data[y]

        # print(self.X,self.Y)
        
        n = self.X.size
        slope = 0
        intercept = 0
        gd_df = pd.DataFrame(columns = ['slope', 'intercept', 'current_coef', 'current_intercept', 'cost_value'])


        for i in range(iterations):
            # Step 1 - Evaluate 
            y_predicted = slope * self.X + intercept                                         # it is a full Series Object
            # print(y_predicted)

            
            # Step 2 - cost Function - sum of Mean Squared Error (MSE)
            cost_value = np.sum([val ** 2 for val in (self.Y - y_predicted)])

            # Step 3: Calculate gradients                                                    Note -  here (y_actual - y_predicted) is also called Residual
            slope_gradient = (-2/n) * np.sum(self.X * (self.Y - y_predicted))                # derivative of MSE w.r.t d(slope)
            intercept_gradient = (-2/n) *  np.sum(self.Y - y_predicted)                      # derivative of MSE w.r.t d(intercept)
            
            # Step 4: Update parameters by using step size
            slope -= (slope_gradient * learning_rate)                                        # update the slope 
            intercept -= (intercept_gradient * learning_rate)                                # update the intercept         

            gd_df.loc[i] = [slope,intercept,slope_gradient,intercept_gradient,cost_value]    # store the updated 
            
        # print(gd_df.head())
        print(gd_df.tail())

        return gd_df
    
    
    def stochasticGradientDescent(self,x,y,learning_rate=0.01,iterations=1000):
        self.X = self.data[x]
        self.Y = self.data[y]

        n = self.X.size
        slope = 0
        intercept = 0
        sgd = pd.DataFrame(columns = ['slope', 'intercept', 'current_coef', 'current_intercept', 'cost_value'])

        for i in range(iterations):
            random_index = np.random.randint(0,n)
            y_i = self.Y.iloc[random_index]
            x_i = self.X.iloc[random_index]

            y_predicted = x_i * slope + intercept                          
            # print(y_predicted)                                      

            
            slope_gradient = -2 * x_i * (y_i - y_predicted)
            intercept_gradient = -2 * (y_i - y_predicted)

            slope -= (slope_gradient * learning_rate)
            intercept -= (intercept_gradient * learning_rate)

            y_full_predicted = slope * self.X + intercept
            cost_value = np.mean((self.Y - y_full_predicted) ** 2) / n
            sgd.loc[i] = [slope,intercept,slope_gradient,intercept_gradient,cost_value]
            # if i % 100 == 0:
            #     print(f"Iteration {i}: Cost = {cost_value:.4f}, Slope = {slope:.4f}, Intercept = {intercept:.4f}")

        print(sgd.tail())
        plt.scatter(sgd['slope'],sgd['intercept'])
        
        
        
    
    def miniBatchGradientDescent(self,x,y,batch=5):
        self.X = self.data[x]
        self.Y = self.data[y]
    

    def normalEquation(self,x,y):
        X = self.data[x]
        Y = self.data[y]
        print(X,Y)

        return np.linalg.inv(X.T @ X) @ X.T @ Y
    
    def ne(self, x, y):
        X = self.data[x].values.reshape(-1, 1)  # Reshape X into a 2D array (n_samples, 1)
        Y = self.data[y].values                # Extract Y as a 1D array
        
        # Add a column of ones to X for the intercept term
        X = np.hstack([np.ones((X.shape[0], 1)), X])

        # Normal Equation: theta = (X.T X)^-1 X.T Y
        return np.linalg.inv(X.T @ X) @ X.T @ Y


    
if __name__ == "__main__":
    gd = GradientDescent('basics/data/years_experience_salary.xlsx')
    # gd.gradientDescent(x='YearExperience',y='Salary')
    gd.stochasticGradientDescent(x='YearExperience',y='Salary')
    print(gd.ne(x='YearExperience',y='Salary'))
    
    pass