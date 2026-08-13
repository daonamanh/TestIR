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

# Mở đầu HTML với CSS UI Đồng bộ
cat <<EOF > "$REPORT_FILE"
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Code Complexity Audit Report</title>
    <style>
        :root {
            --bg-body: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --pass-bg: #f0fdf4;
            --pass-text: #15803d;
            --pass-border: #bbf7d0;
            --fail-bg: #fef2f2;
            --fail-text: #b91c1c;
            --fail-border: #fecaca;
        }

        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; 
            margin: 0; 
            padding: 30px 20px; 
            background-color: var(--bg-body); 
            color: var(--text-main);
            line-height: 1.5;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header { 
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); 
            color: white; 
            padding: 28px 32px; 
            border-radius: 12px; 
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            margin-bottom: 24px;
        }
        .header h1 { margin: 0; font-size: 24px; font-weight: 700; letter-spacing: -0.02em; }
        .header p { margin: 8px 0 0 0; font-size: 13px; color: #94a3b8; }

        /* Card Section đồng bộ */
        .section { 
            background: var(--card-bg); 
            padding: 24px; 
            margin-bottom: 24px; 
            border-radius: 12px; 
            border: 1px solid var(--border-color);
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
            transition: box-shadow 0.2s ease;
        }
        .section:hover {
            box-shadow: 0 4px 12px 0 rgba(0, 0, 0, 0.05);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f1f5f9;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Status Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .badge-pass {
            background-color: var(--pass-bg);
            color: var(--pass-text);
            border: 1px solid var(--pass-border);
        }
        .badge-fail {
            background-color: var(--fail-bg);
            color: var(--fail-text);
            border: 1px solid var(--fail-border);
        }

        /* Content Container */
        .content-container {
            margin-top: 16px;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        iframe { 
            width: 100%; 
            height: 480px; 
            border: none;
            display: block;
            background: #ffffff; 
        }

        pre { 
            background: #0f172a; 
            color: #f1f5f9; 
            padding: 18px; 
            margin: 0;
            overflow-x: auto; 
            font-family: "JetBrains Mono", "Fira Code", Consolas, Monaco, monospace; 
            font-size: 13px;
            line-height: 1.6;
            white-space: pre-wrap; 
            max-height: 480px;
        }
    </style>
</head>
<body>
    <div class="container">
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
    
    set +e
    npx eslint . --ext .js,.jsx,.ts,.tsx --format html > "$OUTPUT_DIR/eslint-tmp.html" 2>&1
    ESLINT_STATUS=$?
    set -e

    cat <<EOF >> "$REPORT_FILE"
    <div class="section">
        <div class="section-header">
            <h2 class="section-title">🟨 TypeScript / JavaScript Audit (ESLint)</h2>
EOF

    if [ $ESLINT_STATUS -eq 0 ]; then
        echo "<span class='badge badge-pass'>✅ PASSED</span></div>" >> "$REPORT_FILE"
        echo "<p style='color: var(--text-muted); font-size: 14px; margin: 0;'>No complexity violations detected in JS/TS files.</p>" >> "$REPORT_FILE"
    else
        echo "<span class='badge badge-fail'>⚠️ VIOLATIONS DETECTED</span></div>" >> "$REPORT_FILE"
        echo "<div class='content-container'><iframe srcdoc=\"" >> "$REPORT_FILE"
        sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' "$OUTPUT_DIR/eslint-tmp.html" >> "$REPORT_FILE"
        echo "\"></iframe></div>" >> "$REPORT_FILE"
    fi

    rm -f "$OUTPUT_DIR/eslint-tmp.html"
    echo "</div>" >> "$REPORT_FILE"
fi

# =========================================================
# 2. GO / GOLANG AUDIT (Complexity Audit)
# =========================================================
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$HOME/bin:$GOPATH/bin:/usr/local/go/bin:$PATH"

echo "[+] Running Complexity Audit for Go..."

set +e

# Tự động tải gocyclo nếu chưa tồn tại
if ! command -v gocyclo &> /dev/null; then
    echo "[+] Installing gocyclo to $GOPATH/bin..."
    go install github.com/fzipp/gocyclo/cmd/gocyclo@latest > /dev/null 2>&1 || true
fi

GO_VIOLATIONS=""

if command -v gocyclo &> /dev/null; then
    GO_TARGETS=$(find . -name "*.go" -not -path "*/node_modules/*" -not -path "*/vendor/*")
    
    if [ -n "$GO_TARGETS" ]; then
        CYCLO_OUT=$(gocyclo -over 10 $GO_TARGETS 2>&1)
        if [ -n "$CYCLO_OUT" ]; then
            GO_VIOLATIONS="$CYCLO_OUT"
        fi
    fi
else
    if command -v golangci-lint &> /dev/null; then
        GO_VIOLATIONS=$(golangci-lint run main.go --config .golangci.yml 2>&1)
    fi
fi

set -e

cat <<EOF >> "$REPORT_FILE"
    <div class="section">
        <div class="section-header">
            <h2 class="section-title">🟦 Go / Golang Audit</h2>
EOF

if [ -z "$GO_VIOLATIONS" ]; then
    echo "<span class='badge badge-pass'>✅ PASSED</span></div>" >> "$REPORT_FILE"
    echo "<p style='color: var(--text-muted); font-size: 14px; margin: 0;'>Cyclomatic complexity is within limits (&le; 10) for all Go functions.</p>" >> "$REPORT_FILE"
else
    echo "<span class='badge badge-fail'>⚠️ VIOLATIONS DETECTED</span></div>" >> "$REPORT_FILE"
    echo "<div class='content-container'><pre>" >> "$REPORT_FILE"
    sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' <<< "$GO_VIOLATIONS" >> "$REPORT_FILE"
    echo "</pre></div>" >> "$REPORT_FILE"
fi

echo "</div>" >> "$REPORT_FILE"

# =========================================================
# 3. RUBY AUDIT (RuboCop)
# =========================================================
if [ -f ".rubocop.yml" ] && command -v rubocop &> /dev/null; then
    echo "[+] Running RuboCop for Ruby..."
    
    set +e
    rubocop --config .rubocop.yml --format html -o "$OUTPUT_DIR/rubocop-tmp.html" 2>&1
    RUBY_STATUS=$?
    set -e

    cat <<EOF >> "$REPORT_FILE"
    <div class="section">
        <div class="section-header">
            <h2 class="section-title">🟥 Ruby Audit (RuboCop)</h2>
EOF

    if [ $RUBY_STATUS -eq 0 ]; then
        echo "<span class='badge badge-pass'>✅ PASSED</span></div>" >> "$REPORT_FILE"
        echo "<p style='color: var(--text-muted); font-size: 14px; margin: 0;'>No RuboCop complexity rules violated.</p>" >> "$REPORT_FILE"
    else
        echo "<span class='badge badge-fail'>⚠️ VIOLATIONS DETECTED</span></div>" >> "$REPORT_FILE"
        echo "<div class='content-container'><iframe srcdoc=\"" >> "$REPORT_FILE"
        sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' "$OUTPUT_DIR/rubocop-tmp.html" >> "$REPORT_FILE"
        echo "\"></iframe></div>" >> "$REPORT_FILE"
    fi

    rm -f "$OUTPUT_DIR/rubocop-tmp.html"
    echo "</div>" >> "$REPORT_FILE"
fi

# Đóng file HTML
cat <<EOF >> "$REPORT_FILE"
    </div>
</body>
</html>
EOF

echo "[+] Report successfully generated at: $REPORT_FILE"
exit 0




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


