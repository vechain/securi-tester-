from flask import Flask, request, redirect
import os

app = Flask(__name__)
API_KEY = "sk_test_51LzJeYGHlDjWm3_EXAMPLE"

@app.route('/login', methods=['POST'])
def login():
    user = request.args.get("user")
    pwd = request.args.get("pass")
    query = f"SELECT * FROM users WHERE username = '{user}' AND password = '{pwd}'"
    print(query)
    return "Logged in"

@app.route('/ping')
def ping():
    host = request.args.get("host")
    os.system(f"ping -c 3 {host}")
    return f"Pinging {host}"

@app.route('/redirect')
def redir():
    return redirect(request.args.get('next'))

@app.route('/admin')
def admin_panel():
    return "Admin zone!"

@app.route('/debug')
def debug_data():
    cc = request.args.get('cc')
    print(f"Processing credit card: {cc}")
    return "Done"
