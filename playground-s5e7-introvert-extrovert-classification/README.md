# Personality Prediction: Introverts vs Extroverts  
**Playground Series - Season 5, Episode 7**

---

## 📂 Dataset Overview
**Source**: [Kaggle Dataset by Rakesh Kapilavai](https://www.kaggle.com/datasets/rakeshkapilavai/extrovert-vs-introvert-behavior-data/data)

This dataset aims to classify a person as an **Introvert** or an **Extrovert** based on behavioral traits.

### 🧾 Features

| Feature                   | Description                                      |
|---------------------------|--------------------------------------------------|
| `Time_spent_Alone`        | Hours spent alone daily (0–11)                   |
| `Stage_fear`              | Presence of stage fright (`Yes` / `No`)         |
| `Social_event_attendance` | Frequency of attending social events (0–10)      |
| `Going_outside`           | Frequency of going outside (0–7)                 |
| `Drained_after_socializing` | Feeling drained after socializing (`Yes` / `No`) |
| `Friends_circle_size`     | Number of close friends (0–15)                   |
| `Post_frequency`          | Social media post frequency (0–10)              |
| `Personality`             | **Target** — `Introvert` or `Extrovert`         |

---

## 🧹 Data Quality Notes

- ❗ **Missing Values**  
  - `Time_spent_Alone`, `Going_outside` contain **NaNs** → **Data cleaning required**  
- ⚖️ **Balanced Classes**  
  - Equal representation of both personality types → Good for classification  
- 🟩 **Categorical Encoding**  
  - Binary features (`Yes`/`No`) can be easily mapped to `0` and `1`  

---

## 🎯 Scoring Metric

**Primary Evaluation Metric**: [Accuracy Score](https://www.kaggle.com/code/metric/accuracy-score)

---