import os
import subprocess

def run_verilator_lint(file_path):
    cmd = ["verilator", "--lint-only", file_path]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.returncode, result.stdout, result.stderr


def lint_all_verilog(folder_path="verilog_dataset"):
    if not os.path.exists(folder_path):
        print(f"[X] 資料夾不存在: {folder_path}")
        return

    v_files = [f for f in os.listdir(folder_path) if f.endswith(".v")]
    if not v_files:
        print(f"[!] 沒有找到任何 .v 檔案")
        return

    total_files = len(v_files)
    passed_files = 0
    
    for vfile in v_files:
        full_path = os.path.join(folder_path, vfile)
        print(f"\n[>] 檢查：{vfile}")
        code, out, err = run_verilator_lint(full_path)
        if code == 0:
            passed_files += 1
            print("    ✅ 通過")
        else:
            print("    ❌ 錯誤:")
            print(err)
    
    # 計算 accuracy
    accuracy = (passed_files / total_files) * 100
    print(f"\n[✓] 檢查完成！")
    print(f"    總檔案數量: {total_files}")
    print(f"    通過的檔案數量: {passed_files}")
    print(f"    accuracy: {accuracy:.2f}%")

if __name__ == "__main__":
    lint_all_verilog("verilog_dataset")
