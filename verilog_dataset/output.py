import json
import re
import os

def json_to_verilog_files(json_file_path, output_dir="mistral_output"):
    try:
        with open(json_file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"錯誤：找不到 JSON 檔案 '{json_file_path}'。")
        return
    except json.JSONDecodeError:
        print(f"錯誤：無法解析 JSON 檔案 '{json_file_path}'。")
        return

    # 創建輸出目錄如果不存在
    os.makedirs(output_dir, exist_ok=True)

    for item in data:
        if "input_prompt" in item and "ollama_output_code" in item:
            instruction = item["input_prompt"]
            code = item["ollama_output_code"]

            # 清理 Instruction 字串以作為檔案名
            filename = re.sub(r'[^\w\s-]', '', instruction).strip().replace(' ', '_')
            # 取前幾個詞作為檔案名，避免過長
            filename_parts = filename.split('_')
            short_filename = '_'.join(filename_parts[:9]) + ".v"
            output_path = os.path.join(output_dir, short_filename)

            try:
                with open(output_path, 'w', encoding='utf-8') as outfile:
                    outfile.write(code)
                print(f"已將程式碼寫入檔案：'{output_path}'")
            except IOError:
                print(f"寫入檔案 '{output_path}' 時發生錯誤。")
        else:
            print("警告：JSON 檔案中的項目缺少 'Instruction' 或 'code' 鍵。")

if __name__ == "__main__":
    input_json_file = "mistral_verilog_output.json"  
    output_directory = "mistral_output"   

    json_to_verilog_files(input_json_file, output_directory)