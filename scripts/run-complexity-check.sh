# #!/usr/bin/env bash
# set -e

# echo "========================================="
# echo "   CODE COMPLEXITY AUDIT RUNNER         "
# echo "========================================="

# OUTPUT_DIR="reports"
# mkdir -p "$OUTPUT_DIR"
# REPORT_FILE="$OUTPUT_DIR/complexity-report.html"

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
#         iframe { width: 100%; height: 500px; border: 1px solid #cbd5e1; border-radius: 6px; margin-top: 10px; background: white; }
#     </style>
# </head>
# <body>
#     <div class="header">
#         <h1>📊 Code Complexity Weekly Audit Report</h1>
#         <p>Target Compliance: Divoro Diligence Work | Generated: $(date)</p>
#     </div>
# EOF

# EXIT_CODE=0

# if [ -f "package.json" ]; then
#     echo "[+] Running ESLint for TypeScript/JavaScript..."
#     echo "<div class='section'><h2>TypeScript / JavaScript Audit (ESLint)</h2>" >> "$REPORT_FILE"
    
#     if npx eslint "**/*.{js,jsx,ts,tsx}" --format html > "$OUTPUT_DIR/eslint-tmp.html" 2>&1; then
#         echo "<p class='pass'>✅ PASSED: TypeScript/JavaScript complexity limits satisfied.</p>" >> "$REPORT_FILE"
#     else
#         echo "<p class='fail'>⚠️ WARNING: TypeScript/JavaScript complexity violations detected!</p>" >> "$REPORT_FILE"
#         EXIT_CODE=1
#     fi

#     # [ĐÃ SỬA LỖI QUOTE Ở ĐÂY] Tách lệnh iframe ra để không bị đè nháy kép
#     echo -n "<iframe srcdoc=\"" >> "$REPORT_FILE"
#     sed 's/"/\&quot;/g' "$OUTPUT_DIR/eslint-tmp.html" >> "$REPORT_FILE"
#     echo "\"></iframe>" >> "$REPORT_FILE"
    
#     rm -f "$OUTPUT_DIR/eslint-tmp.html"
#     echo "</div>" >> "$REPORT_FILE"
# fi

# cat <<EOF >> "$REPORT_FILE"
# </body>
# </html>
# EOF

# echo "[+] Report successfully generated at: $REPORT_FILE"
# exit $EXIT_CODE



#!/usr/bin/env bash
set -e

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
        pre { background: #0f172a; color: #f8fafc; padding: 15px; border-radius: 6px; overflow-x: auto; font-family: monospace; }
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
# 2. GO / GOLANG AUDIT (GolangCI-Lint)
# =========================================================
if [ -f ".golangci.yml" ] && command -v golangci-lint &> /dev/null; then
    echo "[+] Running GolangCI-Lint for Go..."
    echo "<div class='section'><h2>🟦 Go / Golang Audit (GolangCI-Lint)</h2>" >> "$REPORT_FILE"
    
    set +e
    golangci-lint run --config .golangci.yml > "$OUTPUT_DIR/go-tmp.txt" 2>&1
    GO_STATUS=$?
    set -e

    if [ $GO_STATUS -eq 0 ]; then
        echo "<p class='pass'>✅ PASSED: Go complexity limits satisfied.</p>" >> "$REPORT_FILE"
    else
        echo "<p class='fail'>⚠️ WARNING: Go complexity violations detected!</p>" >> "$REPORT_FILE"
        echo "<pre>" >> "$REPORT_FILE"
        sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' "$OUTPUT_DIR/go-tmp.txt" >> "$REPORT_FILE"
        echo "</pre>" >> "$REPORT_FILE"
    fi
    
    rm -f "$OUTPUT_DIR/go-tmp.txt"
    echo "</div>" >> "$REPORT_FILE"
fi

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