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
# 0. CẤU HÌNH MÔI TRƯỜNG & BIẾN TOÀN CỤC
# =========================================================
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$HOME/bin:$GOPATH/bin:/usr/local/go/bin:$PATH"

echo "========================================="
echo "   CODE COMPLEXITY AUDIT RUNNER         "
echo "========================================="

OUTPUT_DIR="reports"
mkdir -p "$OUTPUT_DIR"
REPORT_FILE="$OUTPUT_DIR/complexity-report.html"

TOTAL_AUDITS=0
PASSED_AUDITS=0
FAILED_AUDITS=0

JS_CONTENT=""
GO_CONTENT=""
RUBY_CONTENT=""

# =========================================================
# 1. JAVASCRIPT / TYPESCRIPT AUDIT (ESLint)
# =========================================================
if [ -f "package.json" ]; then
    TOTAL_AUDITS=$((TOTAL_AUDITS + 1))
    echo "[+] Running ESLint for TypeScript/JavaScript..."
    
    set +e
    npx eslint . --ext .js,.jsx,.ts,.tsx --format html > "$OUTPUT_DIR/eslint-tmp.html" 2>&1
    ESLINT_STATUS=$?
    set -e

    if [ $ESLINT_STATUS -eq 0 ]; then
        PASSED_AUDITS=$((PASSED_AUDITS + 1))
        JS_CONTENT=$(cat <<EOF
<div class="audit-section">
  <div class="section-header">
    <h2 class="section-title">🟨 TypeScript / JavaScript Audit</h2>
    <span class="badge badge-pass">✓ Passed</span>
  </div>
  <p style="color: var(--text-muted); margin:0;">All JavaScript/TypeScript functions comply with complexity thresholds.</p>
</div>
EOF
)
    else
        FAILED_AUDITS=$((FAILED_AUDITS + 1))
        IFRAME_DOC=$(sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' "$OUTPUT_DIR/eslint-tmp.html")
        JS_CONTENT=$(cat <<EOF
<div class="audit-section">
  <div class="section-header">
    <h2 class="section-title">🟨 TypeScript / JavaScript Audit</h2>
    <span class="badge badge-fail">⚠ Violations Detected</span>
  </div>
  <p style="color: var(--text-muted); margin-bottom: 8px;">Complexity issues detected via ESLint:</p>
  <iframe srcdoc="${IFRAME_DOC}"></iframe>
</div>
EOF
)
    fi
    rm -f "$OUTPUT_DIR/eslint-tmp.html"
fi

# =========================================================
# 2. GO / GOLANG AUDIT (Direct AST Cyclomatic Complexity)
# =========================================================
if [ -f "go.mod" ] || find . -maxdepth 2 -name "*.go" | grep -q .; then
    TOTAL_AUDITS=$((TOTAL_AUDITS + 1))
    echo "[+] Running Complexity Audit for Go..."
    
    set +e
    if ! command -v gocyclo &> /dev/null; then
        echo "[+] Installing gocyclo binary..."
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
    fi
    set -e

    if [ -z "$GO_VIOLATIONS" ]; then
        PASSED_AUDITS=$((PASSED_AUDITS + 1))
        GO_CONTENT=$(cat <<EOF
<div class="audit-section">
  <div class="section-header">
    <h2 class="section-title">🟦 Go / Golang Audit</h2>
    <span class="badge badge-pass">✓ Passed</span>
  </div>
  <p style="color: var(--text-muted); margin:0;">All Go functions satisfied the Cyclomatic Complexity limit (Max: 10).</p>
</div>
EOF
)
    else
        FAILED_AUDITS=$((FAILED_AUDITS + 1))
        ESCAPED_GO_VIOLATIONS=$(sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' <<< "$GO_VIOLATIONS")
        GO_CONTENT=$(cat <<EOF
<div class="audit-section">
  <div class="section-header">
    <h2 class="section-title">🟦 Go / Golang Audit</h2>
    <span class="badge badge-fail">⚠ Violations Detected</span>
  </div>
  <p style="color: var(--text-muted); margin-bottom: 8px;">Functions exceeding complexity threshold (>10):</p>
  <div class="code-container"><pre>${ESCAPED_GO_VIOLATIONS}</pre></div>
</div>
EOF
)
    fi
fi

# =========================================================
# 3. RUBY AUDIT (RuboCop)
# =========================================================
if [ -f ".rubocop.yml" ] && command -v rubocop &> /dev/null; then
    TOTAL_AUDITS=$((TOTAL_AUDITS + 1))
    echo "[+] Running RuboCop for Ruby..."
    
    set +e
    rubocop --config .rubocop.yml --format html -o "$OUTPUT_DIR/rubocop-tmp.html" 2>&1
    RUBY_STATUS=$?
    set -e

    if [ $RUBY_STATUS -eq 0 ]; then
        PASSED_AUDITS=$((PASSED_AUDITS + 1))
        RUBY_CONTENT=$(cat <<EOF
<div class="audit-section">
  <div class="section-header">
    <h2 class="section-title">🟥 Ruby Audit</h2>
    <span class="badge badge-pass">✓ Passed</span>
  </div>
  <p style="color: var(--text-muted); margin:0;">All Ruby code satisfies complexity standards.</p>
</div>
EOF
)
    else
        FAILED_AUDITS=$((FAILED_AUDITS + 1))
        IFRAME_RUBY=$(sed -e 's/&/\&amp;/g' -e 's/"/\&quot;/g' "$OUTPUT_DIR/rubocop-tmp.html")
        RUBY_CONTENT=$(cat <<EOF
<div class="audit-section">
  <div class="section-header">
    <h2 class="section-title">🟥 Ruby Audit</h2>
    <span class="badge badge-fail">⚠ Violations Detected</span>
  </div>
  <p style="color: var(--text-muted); margin-bottom: 8px;">Complexity violations detected via RuboCop:</p>
  <iframe srcdoc="${IFRAME_RUBY}"></iframe>
</div>
EOF
)
    fi
    rm -f "$OUTPUT_DIR/rubocop-tmp.html"
fi

# =========================================================
# 4. XUẤT TOÀN BỘ BÁO CÁO HTML
# =========================================================
cat <<EOF > "$REPORT_FILE"
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Code Complexity Audit Report</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-main: #0f172a;
            --card-bg: #1e293b;
            --border-color: #334155;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --pass-bg: rgba(34, 197, 94, 0.1);
            --pass-border: #22c55e;
            --pass-text: #4ade80;
            --fail-bg: rgba(239, 68, 68, 0.1);
            --fail-border: #ef4444;
            --fail-text: #f87171;
        }

        * { box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            margin: 0;
            padding: 30px;
            background-color: var(--bg-main);
            color: var(--text-main);
            line-height: 1.5;
        }

        .container { max-width: 1200px; margin: 0 auto; }

        .header {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            padding: 24px 30px;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            margin-bottom: 24px;
        }
        .header h1 { margin: 0; font-size: 22px; font-weight: 700; color: #fff; }
        .header p { margin: 4px 0 0 0; font-size: 13px; color: var(--text-muted); }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }
        .metric-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 16px 20px;
            border-radius: 10px;
        }
        .metric-card .title { font-size: 12px; font-weight: 600; text-transform: uppercase; color: var(--text-muted); letter-spacing: 0.05em; }
        .metric-card .value { font-size: 28px; font-weight: 700; margin-top: 4px; }
        .metric-card.pass .value { color: var(--pass-text); }
        .metric-card.fail .value { color: var(--fail-text); }

        .audit-section {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border-color);
        }
        .section-title { font-size: 18px; font-weight: 600; margin: 0; }

        .badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }
        .badge-pass { background: var(--pass-bg); border: 1px solid var(--pass-border); color: var(--pass-text); }
        .badge-fail { background: var(--fail-bg); border: 1px solid var(--fail-border); color: var(--fail-text); }

        .code-container {
            background: #090d16;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 16px;
            margin-top: 12px;
            overflow-x: auto;
        }
        pre {
            font-family: 'Fira Code', monospace;
            font-size: 13px;
            color: #e2e8f0;
            margin: 0;
            white-space: pre-wrap;
            word-break: break-all;
        }
        iframe {
            width: 100%;
            height: 520px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            background: #fff;
            margin-top: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Multi-Language Code Complexity Audit</h1>
            <p>Divoro Diligence Work Compliance Report | Generated: $(date '+%Y-%m-%d %H:%M:%S')</p>
        </div>

        <div class="summary-grid">
            <div class="metric-card">
                <div class="title">Total Audits</div>
                <div class="value">${TOTAL_AUDITS}</div>
            </div>
            <div class="metric-card pass">
                <div class="title">Passed</div>
                <div class="value">${PASSED_AUDITS}</div>
            </div>
            <div class="metric-card fail">
                <div class="title">Violations</div>
                <div class="value">${FAILED_AUDITS}</div>
            </div>
        </div>

        ${JS_CONTENT}
        ${GO_CONTENT}
        ${RUBY_CONTENT}
    </div>
</body>
</html>
EOF

echo "[+] Report successfully generated at: $REPORT_FILE"
exit 0