from flask import Flask,  render_template, request, json
import json
import pickle
import numpy as np

app = Flask(__name__)

__model = None
__data_columns = None


@app.route('/')
def home_page():
    return render_template('index.html')

@app.route('/get_locations', methods=['POST'])
def get_locations():
    global __data_columns
    if __data_columns is None:
        with open('artifacts/columns.json', 'r') as file:
            __data_columns = json.load(file)['data_columns']

    return json.dumps({
        'data_columns': __data_columns[3:]
    })

@app.route('/predict_price', methods=['POST'])
def predict_price():
    global __model, __data_columns      # important or it will be locall variables which cannot be accessed outside

    if __model is None or __data_columns is None:
        load_saved_artifacts()

    # data = request.get_json()
    location = request.form['location']
    sqft = float(request.form['sqft'])
    bhk = int(request.form['bhk'])
    bath = int(request.form['bath'])

    try:
        loc_index = __data_columns.index(location.lower())
    except:
        loc_index = -1

    x = np.zeros(len(__data_columns))
    x[0] = sqft
    x[1] = bath
    x[2] = bhk
    if loc_index >= 0:
        x[loc_index] = 1


    estimated_price = __model.predict([x])[0]
    # print(estimated_price)
    return json.dumps({
        'estimated_price': round(estimated_price,2),
    })

def load_saved_artifacts():
    global __model, __data_columns

    with open('artifacts/columns.json', 'r') as file:
        __data_columns = json.load(file)['data_columns']

    with open('artifacts/banglore_home_prices_model.pickle', 'rb') as file:
        __model = pickle.load(file)

    print('Artifacts loaded successfully.')


if __name__ == "__main__":
    print('Starting Python Flask server...')
    load_saved_artifacts()  
    # print(predict_price('thubarahalli',1000,2,2))
    # print(predict_price('thubarahalli',1200,2,2))
    # print(predict_price('vidyaranyapura',1200,2,2))
    app.run(debug=True, port=8080)
