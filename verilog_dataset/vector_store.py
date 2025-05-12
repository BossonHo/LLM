import json
import chromadb
from sentence_transformers import SentenceTransformer
from huggingface_hub import login
import os

# 直接寫入 Hugging Face Token
login(token="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")

# 使用 SentenceTransformer 模型來生成向量（你可以根據需求選擇模型）
model = SentenceTransformer("all-MiniLM-L6-v2")

# 載入已經準備好的 dataset
with open("rag_ready_dataset.json", "r", encoding="utf-8") as f:
    dataset = json.load(f)

# 使用絕對路徑指定 Chroma 資料庫的儲存位置
db_path = "C:\\Users\\MSI\\Desktop\\verilog_dataset\\my_chroma_db"  # 使用一個更明確的資料夾名稱

# 創建 Chroma 客戶端，並指定儲存路徑
chroma_client = chromadb.PersistentClient(path=db_path)

# 檢查是否存在指定的 collection，若無則創建
collection_name = "verilog_instructions"
try:
    collection = chroma_client.get_collection(name=collection_name)
except chromadb.errors.NotFoundError:
    # 如果該 collection 不存在，則創建一個新的 collection
    collection = chroma_client.create_collection(name=collection_name)

# 建立向量資料庫，並把每個 "Instruction" 嵌入成向量
for idx, item in enumerate(dataset):
    instruction = item["Instruction"]
    code = item["code"]
    embedding = model.encode(instruction).tolist()

    # 將每個 Instruction 和對應的 code 加入 collection
    collection.add(
        ids=[str(idx)],
        documents=[instruction],
        metadatas=[{"code": code}],
        embeddings=[embedding]
    )

print("✅ 向量資料庫建立並儲存完成")
print(f"資料庫儲存路徑：{os.path.abspath(db_path)}")