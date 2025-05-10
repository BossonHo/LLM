import chromadb
from sentence_transformers import SentenceTransformer

# 指定 Chroma 資料庫的儲存路徑 (請替換成你實際使用的路徑)
db_path = "C:\\Users\\MSI\\Desktop\\verilog_dataset\\my_chroma_db"

# 連接到已存在的 Chroma 資料庫
chroma_client = chromadb.PersistentClient(path=db_path)

# 取得你的 collection
collection = chroma_client.get_collection(name="verilog_instructions")

# 使用與建立向量資料庫時相同的 SentenceTransformer 模型
model = SentenceTransformer("all-MiniLM-L6-v2")

# 你想要查詢的 Instruction
query = "Create a 4-bit adder"

# 將查詢的 Instruction 嵌入為向量
query_embedding = model.encode(query).tolist()

# 查詢向量資料庫，尋找最相似的 3 個結果
results = collection.query(
    query_embeddings=[query_embedding],
    n_results=3, # 你可以調整希望返回的結果數量
    include=["documents", "metadatas", "distances"] # 指定返回的內容
)

# 印出查詢結果
print(f"查詢語句：{query}\n")
if results and results['ids']:
    for i in range(len(results['ids'][0])):
        print(f"相似度排名 {i+1}:")
        print(f"  距離: {results['distances'][0][i]}")
        print(f"  Instruction: {results['documents'][0][i]}")
        print(f"  Verilog Code: {results['metadatas'][0][i]['code']}")
        print("-" * 30)
else:
    print("沒有找到相似的結果。")