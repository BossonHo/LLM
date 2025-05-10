from flask import Flask, render_template, request, jsonify, session, redirect, url_for
import json
import os
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'your-secret'

HISTORY_FILE = "chat_history.json"
USERS_FILE = "users.json"  # 用來存儲註冊的帳號和密碼

# 儲存訊息到歷史紀錄
def save_message(user_msg, bot_reply):
    if not os.path.exists(HISTORY_FILE):
        history = []
    else:
        with open(HISTORY_FILE, 'r', encoding='utf-8') as f:
            history = json.load(f)

    history.append({
        "timestamp": datetime.now().isoformat(),
        "user": user_msg,
        "bot": bot_reply
    })

    with open(HISTORY_FILE, 'w', encoding='utf-8') as f:
        json.dump(history, f, indent=2, ensure_ascii=False)

# 註冊功能，儲存帳號密碼（不加密）
def save_user(username, password):
    if not os.path.exists(USERS_FILE):
        users = []
    else:
        with open(USERS_FILE, 'r', encoding='utf-8') as f:
            users = json.load(f)

    # 檢查帳號是否已經註冊
    if any(user['username'] == username for user in users):
        return False

    users.append({
        "username": username,
        "password": password  # 直接儲存明文密碼
    })

    with open(USERS_FILE, 'w', encoding='utf-8') as f:
        json.dump(users, f, indent=2, ensure_ascii=False)

    return True

@app.route('/')
def index():
    if 'user' not in session:
        return redirect(url_for('login'))  # 如果沒登入，重定向到登入頁
    return render_template('chat.html')  # 顯示聊天頁面

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # 讀取已註冊的用戶資料
        if os.path.exists(USERS_FILE):
            with open(USERS_FILE, 'r', encoding='utf-8') as f:
                users = json.load(f)

            # 查詢使用者
            user = next((u for u in users if u['username'] == username), None)
            if user and user['password'] == password:  # 比對明文密碼
                session['user'] = username
                return redirect(url_for('index'))  # 登入成功，重定向到首頁
            else:
                return render_template('login.html', error='登入失敗，請再試一次')

        return render_template('login.html', error='登入失敗，請再試一次')
    success=request.args.get("success")
    return render_template('login.html',success=success)

@app.route('/logout')
def logout():
    session.pop('user', None)  # 清除 session 中的 'user'
    return redirect(url_for('login'))  # 登出後重定向到登入頁

@app.route('/enroll', methods=['GET', 'POST'])
def enroll():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        if save_user(username, password):
            return redirect(url_for('login',success='1'))  # 註冊成功後重定向到登入頁
        else:
            return render_template('enroll.html', error='此帳號已存在，請選擇其他帳號')

    return render_template('enroll.html')

@app.route('/chat', methods=['POST'])
def chat():
    if 'user' not in session:
        return redirect(url_for('login'))  # 如果沒登入，重定向到登入頁

    user_message = request.json['message']
    
    # 模擬回覆（你可以改成接你的 LLM）
    reply = f"你說的是：{user_message}"

    save_message(user_message, reply)

    return jsonify({'reply': reply})

@app.route('/history')
def get_history():
    if 'user' not in session:
        return redirect(url_for('login'))  # 如果沒登入，重定向到登入頁

    if not os.path.exists(HISTORY_FILE):
        return jsonify([])

    with open(HISTORY_FILE, 'r', encoding='utf-8') as f:
        history = json.load(f)
    return jsonify(history)

@app.route('/clear', methods=['POST'])
def clear_history():
    if 'user' not in session:
        return redirect(url_for('login'))  # 如果沒登入，重定向到登入頁

    if os.path.exists(HISTORY_FILE):
        with open(HISTORY_FILE, 'w', encoding='utf-8') as f:
            json.dump([], f)
    return jsonify({'status': 'cleared'})

@app.route('/current_user')
def current_user():
    if 'user' in session:
        return jsonify({'username': session['user']})
    else:
        return jsonify({'username': '訪客'})

if __name__ == '__main__':
    app.run(debug=True)
