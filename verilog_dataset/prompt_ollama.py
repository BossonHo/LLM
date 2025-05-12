import chromadb
from sentence_transformers import SentenceTransformer
import requests
import json

# --- ChromaDB 和 Sentence Transformer 設定 ---
# 指定 Chroma 資料庫的儲存路徑 (請替換成你實際使用的路徑)
db_path = "C:\\Users\\MSI\\Desktop\\verilog_dataset\\my_chroma_db"
chroma_client = chromadb.PersistentClient(path=db_path)
collection = chroma_client.get_collection(name="verilog_instructions")
model = SentenceTransformer("all-MiniLM-L6-v2")

# --- Ollama API 設定 ---
OLLAMA_API_URL = "http://localhost:11434/api/generate"  # 根據你的 Ollama 設定
OLLAMA_MODEL_NAME = "llama2:latest"  # 使用 Llama 2 模型

def create_prompt(user_question, results):
    """
    根據使用者問題和 Chroma 查詢結果生成 Prompt。
    """
    prompt_context = ""
    if results and results['ids']:
        # 优先选择最相关的范例 (例如，包含 "full adder" 的范例)
        best_example_index = -1
        for i in range(len(results['ids'][0])):
            if "full adder" in results['documents'][0][i].lower():
                best_example_index = i
                break

        if best_example_index != -1:
            instruction = results['documents'][0][best_example_index]
            code = results['metadatas'][0][best_example_index]['code']
            # 提取 full_adder 模块的代码 (简化)
            full_adder_code_start = code.find("module full_adder")
            full_adder_code_end = code.find("endmodule", full_adder_code_start) + len("endmodule")
            if full_adder_code_start != -1 and full_adder_code_end != -1:
                code = code[full_adder_code_start:full_adder_code_end]
            prompt_context = f"--- 範例 1 (全加器) ---\nInstruction: {instruction}\nCode:\n```verilog\n{code}\n```\n\n"
        else:
            # 如果没有找到包含 full adder 的范例，则使用第一个结果
            instruction = results['documents'][0][0]
            code = results['metadatas'][0][0]['code']
            prompt_context = f"--- 範例 1 ---\nInstruction: {instruction}\nCode:\n```verilog\n{code}\n```\n\n"

    final_prompt = f"""以下是一些 Verilog 程式碼範例，可供參考：

{prompt_context}

請基於以上範例，提供關於「{user_question}」的 Verilog 程式碼或相關解釋。
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

if __name__ == '__main__':
    # 使用者想要查詢的 Instruction
    user_question = "Create a 4-bit adder"

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

    print("生成的 Prompt:\n")
    print(final_prompt)

    # 4. 丟給 Ollama 模型回答
    ollama_response = get_ollama_response(final_prompt)

    if ollama_response:
        print("\nOllama 的回答:\n")
        print(ollama_response)
