from flask import Flask, render_template, request, jsonify, session, redirect, url_for
import json
import os
import requests
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'your-secret'

HISTORY_FILE = "chat_history.json"
USERS_FILE = "users.json"

# 呼叫本地 Ollama 模型
def query_ollama(prompt):
    try:
        response = requests.post(
            "http://localhost:11434/api/generate",
            json={
                "model": "llama2",  # 可改成你下載的模型名稱
                "prompt": prompt,
                "stream": False
            }
        )
        if response.status_code == 200:
            return response.json()["response"]
        else:
            return "抱歉，模型無法回應。"
    except Exception as e:
        return f"Ollama 錯誤：{e}"

# 儲存訊息
def save_message(user_msg, bot_reply):
    history = []
    if os.path.exists(HISTORY_FILE):
        with open(HISTORY_FILE, 'r', encoding='utf-8') as f:
            history = json.load(f)
    history.append({
        "timestamp": datetime.now().isoformat(),
        "user": user_msg,
        "bot": bot_reply
    })
    with open(HISTORY_FILE, 'w', encoding='utf-8') as f:
        json.dump(history, f, indent=2, ensure_ascii=False)

# 註冊帳號
def save_user(username, password):
    users = []
    if os.path.exists(USERS_FILE):
        with open(USERS_FILE, 'r', encoding='utf-8') as f:
            users = json.load(f)
    if any(user['username'] == username for user in users):
        return False
    users.append({"username": username, "password": password})
    with open(USERS_FILE, 'w', encoding='utf-8') as f:
        json.dump(users, f, indent=2, ensure_ascii=False)
    return True

@app.route('/')
def index():
    if 'user' not in session:
        return redirect(url_for('login'))
    return render_template('chat.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if os.path.exists(USERS_FILE):
            with open(USERS_FILE, 'r', encoding='utf-8') as f:
                users = json.load(f)
            user = next((u for u in users if u['username'] == username), None)
            if user and user['password'] == password:
                session['user'] = username
                return redirect(url_for('index'))
        return render_template('login.html', error='登入失敗，請再試一次')
    success = request.args.get("success")
    return render_template('login.html', success=success)

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('login'))

@app.route('/enroll', methods=['GET', 'POST'])
def enroll():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if save_user(username, password):
            return redirect(url_for('login', success='1'))
        else:
            return render_template('enroll.html', error='此帳號已存在，請選擇其他帳號')
    return render_template('enroll.html')

@app.route('/chat', methods=['POST'])
def chat():
    if 'user' not in session:
        return redirect(url_for('login'))

    user_message = request.json['message']
    reply = query_ollama(user_message)
    save_message(user_message, reply)
    return jsonify({'reply': reply})

@app.route('/history')
def get_history():
    if 'user' not in session:
        return redirect(url_for('login'))

    if not os.path.exists(HISTORY_FILE):
        return jsonify([])
    with open(HISTORY_FILE, 'r', encoding='utf-8') as f:
        history = json.load(f)
    return jsonify(history)

@app.route('/clear', methods=['POST'])
def clear_history():
    if 'user' not in session:
        return redirect(url_for('login'))

    if os.path.exists(HISTORY_FILE):
        with open(HISTORY_FILE, 'w', encoding='utf-8') as f:
            json.dump([], f)
    return jsonify({'status': 'cleared'})

@app.route('/current_user')
def current_user():
    if 'user' in session:
        return jsonify({'username': session['user']})
    return jsonify({'username': '訪客'})

if __name__ == '__main__':
    app.run(debug=True)
