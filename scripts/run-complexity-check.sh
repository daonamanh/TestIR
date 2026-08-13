# #!/usr/bin/env bash
# set -e

# # =========================================================
# # 0. ƯU TIÊN SỬ DỤNG GOLANGCI-LINT V1.61.0 TRONG $HOME/BIN
# # =========================================================
# export PATH="$HOME/bin:$PATH"

# echo "========================================="
# echo "   CODE COMPLEXITY AUDIT RUNNER         "
# echo "========================================="

# OUTPUT_DIR="reports"
# mkdir -p "$OUTPUT_DIR"
# REPORT_FILE="$OUTPUT_DIR/complexity-report.html"

# # Mở đầu HTML
# cat <<EOF > "$REPORT_FILE"
# <!DOCTYPE html>
# <html lang="vi">
# <head>
#     <meta charset="UTF-8">
#     <title>Code Complexity Audit Report</title>
#     <style>
#         body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; margin: 0; padding: 25px; background-color: #f8fafc; color: #1e293b; }
#         .header { background-color: #0f172a; color: white; padding: 20px 30px; border-radius: 8px 8px 0 0; border-bottom: 4px solid #2563eb; }
#         .header h1 { margin: 0; font-size: 22px; }
#         .header p { margin: 5px 0 0 0; font-size: 13px; color: #94a3b8; }
#         .section { background: white; padding: 20px; margin-top: 20px; border-radius: 8px; border: 1px solid #e2e8f0; }
#         .pass { color: #16a34a; font-weight: bold; background: #f0fdf4; padding: 10px; border-radius: 4px; border: 1px solid #bbf7d0; }
#         .fail { color: #dc2626; font-weight: bold; background: #fef2f2; padding: 10px; border-radius: 4px; border: 1px solid #fecaca; }
#         iframe { width: 100%; height: 450px; border: 1px solid #cbd5e1; border-radius: 6px; margin-top: 10px; background: white; }
#         pre { background: #0f172a; color: #f8fafc; padding: 15px; border-radius: 6px; overflow-x: auto; font-family: monospace; white-space: pre-wrap; }
#     </style>
# </head>
# <body>
#     <div class="header">
#         <h1>📊 Multi-Language Code Complexity Audit Report</h1>
#         <p>Target Compliance: Divoro Diligence Work | Generated: $(date)</p>
#     </div>
# EOF

# # =========================================================
# # 1. JAVASCRIPT / TYPESCRIPT AUDIT (ESLint)
# # =========================================================
# if [ -f "package.json" ]; then
#     echo "[+] Running ESLint for TypeScript/JavaScript..."
#     echo "<div class='section'><h2>🟨 TypeScript / JavaScript Audit (ESLint)</h2>" >> "$REPORT_FILE"
    
#     set +e
#     npx eslint . --ext .js,.jsx,.ts,.tsx --format html > "$OUTPUT_DIR/eslint-tmp.html" 2>&1
#     ESLINT_STATUS=$?
#     set -e

#     if [ $ESLINT_STATUS -eq 0 ]; then
#         echo "<p class='pass'>✅ PASSED: TypeScript/JavaScript complexity limits satisfied.</p>" >> "$REPORT_FILE"
#     else
#         echo "<p class='fail'>⚠️ WARNING: TypeScript/JavaScript complexity violations detected!</p>" >> "$REPORT_FILE"
#     fi

#     echo -n "<iframe srcdoc=\"" >> "$REPORT_FILE"
#     sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' "$OUTPUT_DIR/eslint-tmp.html" >> "$REPORT_FILE"
#     echo "\"></iframe>" >> "$REPORT_FILE"
    
#     rm -f "$OUTPUT_DIR/eslint-tmp.html"
#     echo "</div>" >> "$REPORT_FILE"
# fi

# # =========================================================
# # 2. GO / GOLANG AUDIT (Complexity Audit)
# # =========================================================
# # Thêm chính xác các đường dẫn Go binary của user jenkins vào PATH
# export GOPATH="${GOPATH:-$HOME/go}"
# export PATH="$HOME/bin:$GOPATH/bin:/usr/local/go/bin:$PATH"

# echo "[+] Running Complexity Audit for Go..."
# echo "<div class='section'><h2>🟦 Go / Golang Audit</h2>" >> "$REPORT_FILE"

# set +e

# # 1. Tự động tải gocyclo nếu chưa tồn tại
# if ! command -v gocyclo &> /dev/null; then
#     echo "[+] Installing gocyclo to $GOPATH/bin..."
#     go install github.com/fzipp/gocyclo/cmd/gocyclo@latest > /dev/null 2>&1 || true
# fi

# GO_VIOLATIONS=""

# # 2. Chạy gocyclo quét trực tiếp các file .go (bỏ qua node_modules)
# if command -v gocyclo &> /dev/null; then
#     # Tìm file .go ngoại trừ node_modules và vendor
#     GO_TARGETS=$(find . -name "*.go" -not -path "*/node_modules/*" -not -path "*/vendor/*")
    
#     if [ -n "$GO_TARGETS" ]; then
#         # Bắt lỗi nếu Cyclomatic Complexity > 10
#         CYCLO_OUT=$(gocyclo -over 10 $GO_TARGETS 2>&1)
#         if [ -n "$CYCLO_OUT" ]; then
#             GO_VIOLATIONS="$CYCLO_OUT"
#         fi
#     fi
# else
#     # Fallback nếu gocyclo không thể install/chạy: Dùng golangci-lint
#     if command -v golangci-lint &> /dev/null; then
#         GO_VIOLATIONS=$(golangci-lint run main.go --config .golangci.yml 2>&1)
#     fi
# fi

# set -e

# if [ -z "$GO_VIOLATIONS" ]; then
#     echo "<p class='pass'>✅ PASSED: Go complexity limits satisfied.</p>" >> "$REPORT_FILE"
# else
#     echo "<p class='fail'>⚠️ WARNING: Go complexity violations detected!</p>" >> "$REPORT_FILE"
#     echo "<pre>" >> "$REPORT_FILE"
#     sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' <<< "$GO_VIOLATIONS" >> "$REPORT_FILE"
#     echo "</pre>" >> "$REPORT_FILE"
# fi

# echo "</div>" >> "$REPORT_FILE"

# # =========================================================
# # 3. RUBY AUDIT (RuboCop)
# # =========================================================
# if [ -f ".rubocop.yml" ] && command -v rubocop &> /dev/null; then
#     echo "[+] Running RuboCop for Ruby..."
#     echo "<div class='section'><h2>🟥 Ruby Audit (RuboCop)</h2>" >> "$REPORT_FILE"
    
#     set +e
#     rubocop --config .rubocop.yml --format html -o "$OUTPUT_DIR/rubocop-tmp.html" 2>&1
#     RUBY_STATUS=$?
#     set -e

#     if [ $RUBY_STATUS -eq 0 ]; then
#         echo "<p class='pass'>✅ PASSED: Ruby complexity limits satisfied.</p>" >> "$REPORT_FILE"
#     else
#         echo "<p class='fail'>⚠️ WARNING: Ruby complexity violations detected!</p>" >> "$REPORT_FILE"
#     fi

#     echo -n "<iframe srcdoc=\"" >> "$REPORT_FILE"
#     sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' "$OUTPUT_DIR/rubocop-tmp.html" >> "$REPORT_FILE"
#     echo "\"></iframe>" >> "$REPORT_FILE"
    
#     rm -f "$OUTPUT_DIR/rubocop-tmp.html"
#     echo "</div>" >> "$REPORT_FILE"
# fi

# # Đóng file HTML
# cat <<EOF >> "$REPORT_FILE"
# </body>
# </html>
# EOF

# echo "[+] Report successfully generated at: $REPORT_FILE"
# exit 0


#!/usr/bin/env bash
set -e

# =========================================================
# 0. CẤU HÌNH & KHỞI TẠO
# =========================================================
OUTPUT_DIR="reports"
mkdir -p "$OUTPUT_DIR"
REPORT_FILE="$OUTPUT_DIR/complexity-report.html"

TOTAL=0
PASSED=0
FAILED=0

# Chứa các đoạn HTML của từng phần
JS_HTML=""
GO_HTML=""
RUBY_HTML=""

# =========================================================
# 1. AUDIT (Chỉ tính toán và lưu HTML vào biến)
# =========================================================

# --- JS ---
if [ -f "package.json" ]; then
    TOTAL=$((TOTAL + 1))
    npx eslint . --ext .js,.jsx,.ts,.tsx --format html > "$OUTPUT_DIR/tmp_js.html" 2>&1
    if [ $? -eq 0 ]; then
        PASSED=$((PASSED + 1))
        JS_HTML="<div class='audit-section'><div class='section-header'><h2 class='section-title'>🟨 JS/TS Audit</h2><span class='badge badge-pass'>✓ Passed</span></div><p>All clean.</p></div>"
    else
        FAILED=$((FAILED + 1))
        ESCAPED_JS=$(sed -e 's/"/\&quot;/g' "$OUTPUT_DIR/tmp_js.html")
        JS_HTML="<div class='audit-section'><div class='section-header'><h2 class='section-title'>🟨 JS/TS Audit</h2><span class='badge badge-fail'>⚠ Fail</span></div><iframe srcdoc=\"$ESCAPED_JS\"></iframe></div>"
    fi
    rm -f "$OUTPUT_DIR/tmp_js.html"
fi

# --- GO ---
if [ -f "go.mod" ] || find . -maxdepth 1 -name "*.go" | grep -q .; then
    TOTAL=$((TOTAL + 1))
    # Chạy gocyclo
    GO_OUT=$(gocyclo -over 10 . 2>&1 || true)
    if [ -z "$GO_OUT" ]; then
        PASSED=$((PASSED + 1))
        GO_HTML="<div class='audit-section'><div class='section-header'><h2 class='section-title'>🟦 Go Audit</h2><span class='badge badge-pass'>✓ Passed</span></div><p>All clean.</p></div>"
    else
        FAILED=$((FAILED + 1))
        # Escaping cho HTML
        ESCAPED_GO=$(echo "$GO_OUT" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')
        GO_HTML="<div class='audit-section'><div class='section-header'><h2 class='section-title'>🟦 Go Audit</h2><span class='badge badge-fail'>⚠ Fail</span></div><div class='code-container'><pre>$ESCAPED_GO</pre></div></div>"
    fi
fi

# --- RUBY ---
if [ -f ".rubocop.yml" ]; then
    TOTAL=$((TOTAL + 1))
    rubocop --format html -o "$OUTPUT_DIR/tmp_ruby.html" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        PASSED=$((PASSED + 1))
        RUBY_HTML="<div class='audit-section'><div class='section-header'><h2 class='section-title'>🟥 Ruby Audit</h2><span class='badge badge-pass'>✓ Passed</span></div><p>All clean.</p></div>"
    else
        FAILED=$((FAILED + 1))
        ESCAPED_RB=$(sed -e 's/"/\&quot;/g' "$OUTPUT_DIR/tmp_ruby.html")
        RUBY_HTML="<div class='audit-section'><div class='section-header'><h2 class='section-title'>🟥 Ruby Audit</h2><span class='badge badge-fail'>⚠ Fail</span></div><iframe srcdoc=\"$ESCAPED_RB\"></iframe></div>"
    fi
    rm -f "$OUTPUT_DIR/tmp_ruby.html"
fi

# =========================================================
# 2. XUẤT FILE HTML (Dùng printf để tránh lỗi biến)
# =========================================================
NOW=$(date '+%Y-%m-%d %H:%M:%S')

printf "
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: sans-serif; background: #0f172a; color: white; padding: 30px; }
        .summary { display: flex; gap: 20px; margin-bottom: 30px; }
        .card { background: #1e293b; padding: 20px; border-radius: 10px; flex: 1; text-align: center; }
        .audit-section { background: #1e293b; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        .badge-pass { color: #4ade80; } .badge-fail { color: #f87171; }
        iframe { width: 100%%; height: 500px; border: none; background: white; margin-top: 10px; }
        .code-container { background: #000; padding: 15px; }
    </style>
</head>
<body>
    <h1>Complexity Audit ($NOW)</h1>
    <div class='summary'>
        <div class='card'>TOTAL<br><h2>%d</h2></div>
        <div class='card'>PASSED<br><h2>%d</h2></div>
        <div class='card'>FAILED<br><h2>%d</h2></div>
    </div>
    %s
    %s
    %s
</body>
</html>
" "$TOTAL" "$PASSED" "$FAILED" "$JS_HTML" "$GO_HTML" "$RUBY_HTML" > "$REPORT_FILE"

echo "[+] Report generated: $REPORT_FILE"