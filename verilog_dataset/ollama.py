import chromadb
from sentence_transformers import SentenceTransformer
import requests
import json
import re
from tqdm import tqdm  # 匯入 tqdm 函式庫

# --- ChromaDB 和 Sentence Transformer 設定 ---
# 指定 Chroma 資料庫的儲存路徑 (請替換成你實際使用的路徑)
db_path = "C:\\Users\\MSI\\Desktop\\verilog_dataset\\my_chroma_db"
chroma_client = chromadb.PersistentClient(path=db_path)
collection = chroma_client.get_collection(name="verilog_instructions")
model = SentenceTransformer("all-MiniLM-L6-v2")

# --- Ollama API 設定 ---
OLLAMA_API_URL = "http://localhost:11434/api/generate"  # 根據你的 Ollama 設定
OLLAMA_MODEL_NAME = "deepseek-coder-v2:latest"  # 使用 Llama 2 模型

def create_prompt(user_question, results):
    """
    根據使用者問題和 Chroma 查詢結果生成 Prompt。
    """
    prompt_context = ""
    if results and results['ids']:
        best_example_index = -1
        for i in range(len(results['ids'][0])):
            if "full adder" in results['documents'][0][i].lower():
                best_example_index = i
                break

        if best_example_index != -1:
            instruction = results['documents'][0][best_example_index]
            code = results['metadatas'][0][best_example_index]['code']
            full_adder_code_start = code.find("module full_adder")
            full_adder_code_end = code.find("endmodule", full_adder_code_start) + len("endmodule")
            if full_adder_code_start != -1 and full_adder_code_end != -1:
                code = code[full_adder_code_start:full_adder_code_end]
            prompt_context = f"--- 範例 1 (全加器) ---\nInstruction: {instruction}\nCode:\n```verilog\n{code}\n```\n\n"
        else:

            instruction = results['documents'][0][0]
            code = results['metadatas'][0][0]['code']
            prompt_context = f"--- 範例 1 ---\nInstruction: {instruction}\nCode:\n```verilog\n{code}\n```\n\n"

    final_prompt = f"""以下是一些 Verilog 程式碼範例，可供參考：

{prompt_context}

請基於以上範例，提供關於「{user_question}」的 Verilog 程式碼。請只輸出 Verilog 程式碼，不要包含任何解釋文字。
"""
    return final_prompt

def get_ollama_response(prompt):
    """
    將 Prompt 發送給 Ollama 模型並獲取回應。
    """
    data = {
        "prompt": prompt,
        "model": OLLAMA_MODEL_NAME,  # 使用 Llama 2 模型
        "stream": False  # 設定為 False 則等待完整回應
    }
    try:
        response = requests.post(OLLAMA_API_URL, json=data)
        response.raise_for_status()  # 檢查 HTTP 錯誤
        result = response.json()
        return result['response']
    except requests.exceptions.RequestException as e:
        print(f"與 Ollama 模型通訊時發生錯誤: {e}")
        return None  # 或你可以選擇拋出異常，取決於你的錯誤處理策略
    except json.JSONDecodeError:
        print("無法解析 Ollama 的回應。")
        return None

def clean_ollama_response(ollama_response):
    """
    從 Ollama 的回應中提取 Verilog 程式碼部分。
    """
    verilog_code = ""
    # 尋找 ```verilog``` 和 ``` 標籤
    verilog_match = re.search(r"```verilog\n(.*?)\n```", ollama_response, re.DOTALL)
    if verilog_match:
        verilog_code = verilog_match.group(1).strip()
    else:
        # 如果沒有標籤，則嘗試尋找 module 和 endmodule 關鍵字
        module_start = ollama_response.find("module")
        module_end = ollama_response.find("endmodule")
        if module_start != -1 and module_end != -1:
            verilog_code = ollama_response[module_start:module_end + len("endmodule")].strip()
        else:
            # 嘗試尋找以 // 或 /* 開頭和以 endmodule 結尾的程式碼塊
            lines = ollama_response.strip().split('\n')
            code_lines = []
            in_code_block = False
            for line in lines:
                line = line.strip()
                if line.startswith("module"):
                    in_code_block = True
                    code_lines.append(line)
                elif line.startswith("endmodule"):
                    if in_code_block:
                        code_lines.append(line)
                        break
                elif in_code_block:
                    code_lines.append(line)
            verilog_code = "\n".join(code_lines).strip()

    return verilog_code

if __name__ == '__main__':
    # 從 JSON 檔案讀取 prompt
    input_json_file = "prompt.json"  # 假設你的 prompt 存在這個檔案
    try:
        with open(input_json_file, 'r', encoding='utf-8') as f:
            prompts_data = json.load(f)
    except FileNotFoundError:
        print(f"錯誤：找不到輸入 JSON 檔案 '{input_json_file}'。")
        exit()
    except json.JSONDecodeError:
        print(f"錯誤：無法解析輸入 JSON 檔案 '{input_json_file}'。")
        exit()

    output_data = []

    # 使用 tqdm 建立進度條
    for item in tqdm(prompts_data, desc="Processing Prompts"):
        if "Instruction" in item:
            user_question = item["Instruction"]

            # 1. 將使用者查詢嵌入為向量
            query_embedding = model.encode(user_question).tolist()

            # 2. 查詢 Chroma vector store
            results = collection.query(
                query_embeddings=[query_embedding],
                n_results=3,
                include=["documents", "metadatas", "distances"]
            )

            # 3. 拼接 Prompt
            final_prompt = create_prompt(user_question, results)

            # 4. 丟給 Ollama 模型回答
            ollama_response = get_ollama_response(final_prompt)

            if ollama_response:
                # 5. 清洗 Ollama 的回應，提取 Verilog 程式碼
                cleaned_code = clean_ollama_response(ollama_response)
                output_data.append({"input_prompt": user_question, "ollama_output_code": cleaned_code})
            else:
                output_data.append({"input_prompt": user_question, "ollama_output_code": None})
        else:
            print(f"警告：輸入 JSON 檔案中的項目缺少 'Instruction' 鍵。")

    # 將結果輸出到 JSON 檔案
    output_json_file = "deepseek_verilog_output.json"
    try:
        with open(output_json_file, 'w', encoding='utf-8') as f:
            json.dump(output_data, f, indent=4, ensure_ascii=False)
        print(f"\n結果已儲存到 '{output_json_file}'。")
    except IOError:
        print(f"寫入輸出 JSON 檔案 '{output_json_file}' 時發生錯誤。")