import os
import json

def extract_verilog_files(verilog_dir):
    # 遍歷資料夾中的所有 .v 檔案
    verilog_files = [f for f in os.listdir(verilog_dir) if f.endswith('.v')]
    verilog_content = {}

    # 讀取每個 Verilog 檔案的內容
    for verilog_file in verilog_files:
        verilog_path = os.path.join(verilog_dir, verilog_file)
        
        # 打開檔案並讀取內容
        with open(verilog_path, 'r') as f:
            verilog_content[verilog_file] = f.read()

    return verilog_content

# 假設你的 .v 檔案存放在 'verilog dataset/' 資料夾中
verilog_dir = 'C:/Users/MSI/Desktop/verilog_dataset/verilog_datasets'

# 提取所有 .v 檔案的內容
verilog_data = extract_verilog_files(verilog_dir)

# 儲存為 JSON 檔案
with open('verilog_data.json', 'w') as json_file:
    json.dump(verilog_data, json_file, indent=4)

print("Verilog 檔案內容已經儲存為 'verilog_data.json'")
