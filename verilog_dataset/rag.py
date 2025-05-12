import json

# 讀入 verilog_data.json（檔名對應 Verilog code）
with open("verilog_data.json", "r", encoding="utf-8") as f:
    verilog_data = json.load(f)

# 讀入 compare.json（每筆是 Instruction + Filename）
with open("compare.json", "r", encoding="utf-8") as f:
    compare_data = json.load(f)

# 轉換成 [{"Instruction": ..., "code": ...}] 格式
converted_data = []

# 若 compare.json 是單一 dict 而非 list，包成 list 處理
if isinstance(compare_data, dict):
    compare_data = [compare_data]

for item in compare_data:
    instruction = item.get("Instruction")
    filename = item.get("Filename")
    code = verilog_data.get(filename)

    if instruction and code:
        converted_data.append({
            "Instruction": instruction,
            "code": code
        })
    else:
        print(f"Warning: 找不到對應的 code for filename: {filename}")

# 儲存成新 JSON 檔
with open("rag_ready_dataset.json", "w", encoding="utf-8") as f:
    json.dump(converted_data, f, indent=2, ensure_ascii=False)

print("✅ 轉換完成，已儲存為 rag_ready_dataset.json")
