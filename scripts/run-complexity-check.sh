#!/usr/bin/env bash
set -e

# =========================================================
# 0. ƯU TIÊN SỬ DỤNG GOLANGCI-LINT V1.61.0 TRONG $HOME/BIN
# =========================================================
export PATH="$HOME/bin:$PATH"

echo "========================================="
echo "   CODE COMPLEXITY AUDIT RUNNER         "
echo "========================================="

OUTPUT_DIR="reports"
mkdir -p "$OUTPUT_DIR"
REPORT_FILE="$OUTPUT_DIR/complexity-report.html"

# Mở đầu HTML
cat <<EOF > "$REPORT_FILE"
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Code Complexity Audit Report</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; margin: 0; padding: 25px; background-color: #f8fafc; color: #1e293b; }
        .header { background-color: #0f172a; color: white; padding: 20px 30px; border-radius: 8px 8px 0 0; border-bottom: 4px solid #2563eb; }
        .header h1 { margin: 0; font-size: 22px; }
        .header p { margin: 5px 0 0 0; font-size: 13px; color: #94a3b8; }
        .section { background: white; padding: 20px; margin-top: 20px; border-radius: 8px; border: 1px solid #e2e8f0; }
        .pass { color: #16a34a; font-weight: bold; background: #f0fdf4; padding: 10px; border-radius: 4px; border: 1px solid #bbf7d0; }
        .fail { color: #dc2626; font-weight: bold; background: #fef2f2; padding: 10px; border-radius: 4px; border: 1px solid #fecaca; }
        iframe { width: 100%; height: 450px; border: 1px solid #cbd5e1; border-radius: 6px; margin-top: 10px; background: white; }
        pre { background: #0f172a; color: #f8fafc; padding: 15px; border-radius: 6px; overflow-x: auto; font-family: monospace; white-space: pre-wrap; }
    </style>
</head>
<body>
    <div class="header">
        <h1>📊 Multi-Language Code Complexity Audit Report</h1>
        <p>Target Compliance: Divoro Diligence Work | Generated: $(date)</p>
    </div>
EOF

# =========================================================
# 1. JAVASCRIPT / TYPESCRIPT AUDIT (ESLint)
# =========================================================
if [ -f "package.json" ]; then
    echo "[+] Running ESLint for TypeScript/JavaScript..."
    echo "<div class='section'><h2>🟨 TypeScript / JavaScript Audit (ESLint)</h2>" >> "$REPORT_FILE"
    
    set +e
    npx eslint . --ext .js,.jsx,.ts,.tsx --format html > "$OUTPUT_DIR/eslint-tmp.html" 2>&1
    ESLINT_STATUS=$?
    set -e

    if [ $ESLINT_STATUS -eq 0 ]; then
        echo "<p class='pass'>✅ PASSED: TypeScript/JavaScript complexity limits satisfied.</p>" >> "$REPORT_FILE"
    else
        echo "<p class='fail'>⚠️ WARNING: TypeScript/JavaScript complexity violations detected!</p>" >> "$REPORT_FILE"
    fi

    echo -n "<iframe srcdoc=\"" >> "$REPORT_FILE"
    sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' "$OUTPUT_DIR/eslint-tmp.html" >> "$REPORT_FILE"
    echo "\"></iframe>" >> "$REPORT_FILE"
    
    rm -f "$OUTPUT_DIR/eslint-tmp.html"
    echo "</div>" >> "$REPORT_FILE"
fi

# =========================================================
# 2. GO / GOLANG AUDIT (Complexity Audit)
# =========================================================
# Thêm chính xác các đường dẫn Go binary của user jenkins vào PATH
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$HOME/bin:$GOPATH/bin:/usr/local/go/bin:$PATH"

echo "[+] Running Complexity Audit for Go..."
echo "<div class='section'><h2>🟦 Go / Golang Audit</h2>" >> "$REPORT_FILE"

set +e

# 1. Tự động tải gocyclo nếu chưa tồn tại
if ! command -v gocyclo &> /dev/null; then
    echo "[+] Installing gocyclo to $GOPATH/bin..."
    go install github.com/fzipp/gocyclo/cmd/gocyclo@latest > /dev/null 2>&1 || true
fi

GO_VIOLATIONS=""

# 2. Chạy gocyclo quét trực tiếp các file .go (bỏ qua node_modules)
if command -v gocyclo &> /dev/null; then
    # Tìm file .go ngoại trừ node_modules và vendor
    GO_TARGETS=$(find . -name "*.go" -not -path "*/node_modules/*" -not -path "*/vendor/*")
    
    if [ -n "$GO_TARGETS" ]; then
        # Bắt lỗi nếu Cyclomatic Complexity > 10
        CYCLO_OUT=$(gocyclo -over 10 $GO_TARGETS 2>&1)
        if [ -n "$CYCLO_OUT" ]; then
            GO_VIOLATIONS="$CYCLO_OUT"
        fi
    fi
else
    # Fallback nếu gocyclo không thể install/chạy: Dùng golangci-lint
    if command -v golangci-lint &> /dev/null; then
        GO_VIOLATIONS=$(golangci-lint run main.go --config .golangci.yml 2>&1)
    fi
fi

set -e

if [ -z "$GO_VIOLATIONS" ]; then
    echo "<p class='pass'>✅ PASSED: Go complexity limits satisfied.</p>" >> "$REPORT_FILE"
else
    echo "<p class='fail'>⚠️ WARNING: Go complexity violations detected!</p>" >> "$REPORT_FILE"
    echo "<pre>" >> "$REPORT_FILE"
    sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' <<< "$GO_VIOLATIONS" >> "$REPORT_FILE"
    echo "</pre>" >> "$REPORT_FILE"
fi

echo "</div>" >> "$REPORT_FILE"

# =========================================================
# 3. RUBY AUDIT (RuboCop)
# =========================================================
if [ -f ".rubocop.yml" ] && command -v rubocop &> /dev/null; then
    echo "[+] Running RuboCop for Ruby..."
    echo "<div class='section'><h2>🟥 Ruby Audit (RuboCop)</h2>" >> "$REPORT_FILE"
    
    set +e
    rubocop --config .rubocop.yml --format html -o "$OUTPUT_DIR/rubocop-tmp.html" 2>&1
    RUBY_STATUS=$?
    set -e

    if [ $RUBY_STATUS -eq 0 ]; then
        echo "<p class='pass'>✅ PASSED: Ruby complexity limits satisfied.</p>" >> "$REPORT_FILE"
    else
        echo "<p class='fail'>⚠️ WARNING: Ruby complexity violations detected!</p>" >> "$REPORT_FILE"
    fi

    echo -n "<iframe srcdoc=\"" >> "$REPORT_FILE"
    sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' "$OUTPUT_DIR/rubocop-tmp.html" >> "$REPORT_FILE"
    echo "\"></iframe>" >> "$REPORT_FILE"
    
    rm -f "$OUTPUT_DIR/rubocop-tmp.html"
    echo "</div>" >> "$REPORT_FILE"
fi

# Đóng file HTML
cat <<EOF >> "$REPORT_FILE"
</body>
</html>
EOF

echo "[+] Report successfully generated at: $REPORT_FILE"
exit 0


