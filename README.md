# Django Project Setup Guide

This guide provides the basic steps to set up a Django project, add templates, static files, create an app, and make the project aware of the app.

---

## Steps to Start a Django Project

### 1. Create and Activate a Conda Virtual Environment
```bash
# Create a virtual environment
conda create -n myenv python=(version) -y

# Activate the virtual environment
conda activate myenv
```

### 2. Install Django
```bash
pip install django
```

### 3. Start a New Django Project
```bash
# Replace 'project_name' with your desired project name
django-admin startproject project_name
cd project_name
```

---

## Working with Apps in Django

### 4. Create a Django App
```bash
# Replace 'app_name' with your desired app name
python manage.py startapp app_name
```

### 5. Register the App in the Project
- Open `project_name/settings.py`.
- Add your app name to the `INSTALLED_APPS` list:
```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'app_name',  # Add your app here
]
```

---

## Adding Templates and Static Files

### 6. Set Up Templates
1. Create a folder named `templates` in the project or app directory.
2. Add the `TEMPLATES` directory in `project_name/settings.py`:
```python
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],  # Add the templates directory here
        ...
    },
]
```

3. Create a sample HTML file in the `templates` folder:
```html
<!-- templates/index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Welcome to Django</title>
</head>
<body>
    <h1>Hello, Django!</h1>
</body>
</html>
```

### 7. Set Up Static Files
1. Create a folder named `static` in the project or app directory.
2. Add the static directory in `project_name/settings.py`:
```python
STATIC_URL = '/static/'
STATICFILES_DIRS = [BASE_DIR / 'static']  # Add this line
```

3. Create a sample CSS file in the `static` folder:
```css
/* static/styles.css */
body {
    background-color: #f0f0f0;
    font-family: Arial, sans-serif;
}
```

---

## Running the Server

### 8. Run the Django Development Server
```bash
python manage.py runserver
```

- Open your browser and navigate to [http://127.0.0.1:8000/](http://127.0.0.1:8000/).

---

## Summary of Commands
| Command                          | Description                              |
|----------------------------------|------------------------------------------|
| `conda create -n myenv python=3.9 -y` | Create a virtual environment using Conda |
| `conda activate myenv`           | Activate the Conda virtual environment   |
| `django-admin startproject name` | Start a new project                      |
| `python manage.py startapp name` | Create a new app                         |
| `python manage.py runserver`     | Start the development server             |

---

### Additional Notes
- Ensure that the app's `views.py` is correctly set up and linked to `urls.py` in both the app and the project for routing.
- Keep `requirements.txt` updated using:
```bash
pip freeze > requirements.txt
```

---

Now you're ready to start building your Django application!