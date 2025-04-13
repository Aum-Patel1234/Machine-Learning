from flask import Flask, render_template, request
import pickle
import numpy as np

app = Flask(__name__)

# Load model
model = pickle.load(open('model.pkl', 'rb'))

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    if request.method == 'POST':
        features = [
            float(request.form['Matches']),
            float(request.form['Innings']),
            float(request.form['NotOuts']),
            float(request.form['HighestScore']),
            float(request.form['Average']),
            float(request.form['StrikeRate']),
            float(request.form['Centuries']),
            float(request.form['HalfCenturies']),
            float(request.form['ScorelessInnings'])
        ]
        prediction = model.predict([features])[0]
        return render_template('index.html', prediction=round(prediction, 2))
        
if __name__ == '__main__':
    app.run(debug=True, port=8000)
