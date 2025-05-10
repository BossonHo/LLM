import json

# 讀取 verilog_data.json
with open('verilog_data.json', 'r') as json_file:
    verilog_data = json.load(json_file)

def retrieve_relevant_code(query, verilog_data):
    relevant_code = []

    # 根據關鍵字查詢程式碼
    for filename, content in verilog_data.items():
        if query.lower() in content.lower():
            relevant_code.append((filename, content))

    return relevant_code

# 假設你想查詢 "counter" 相關的程式碼
query = "counter"
relevant_code = retrieve_relevant_code(query, verilog_data)

# 顯示檢索到的相關程式碼
for filename, code in relevant_code:
    print(f"Found in {filename}:\n{code[:200]}...\n")  # 顯示程式碼的前 200 字符
