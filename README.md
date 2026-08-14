# Code Complexity Checker

A multi-language code complexity audit tool that analyzes, detects, and reports on code quality issues including high cyclomatic complexity, deep nesting, excessive parameters, and other code smell violations.

## 📋 Overview

This project demonstrates common code complexity anti-patterns and provides automated tools to detect them. It includes:
- **Go code examples** with problematic complexity patterns
- **Ruby code examples** with RuboCop violations
- **TypeScript/JavaScript linting** configuration
- **Automated reporting** with HTML output
- **CI/CD integration** via Jenkins

## 🎯 Project Goals

- Detect overly complex functions (high cyclomatic complexity)
- Identify deeply nested control structures
- Flag functions with too many parameters
- Generate detailed HTML audit reports
- Enable code quality gates in CI/CD pipelines

## 📁 Project Structure

```
.
├── main.go                          # Go example with complexity issues
├── demo-bad-code.ts                 # TypeScript/JavaScript bad code examples
├── demo-bad-code copy.ts            # Additional bad code examples
├── test_complexity.rb               # Ruby code with RuboCop violations
├── package.json                     # Node.js dependencies and scripts
├── package-lock.json                # npm lock file for consistent installs
├── go.mod                          # Go module file
├── Jenkinsfile                     # CI/CD pipeline configuration
├── .eslintrc.json                  # ESLint configuration (9 metrics for TypeScript/JS)
├── .golangci.yml                   # Golangci-lint configuration (Go linting)
├── .rubocop.yml                    # RuboCop configuration (Ruby linting)
├── .gitignore                      # Git ignore patterns
├── scripts/
│   └── run-complexity-check.sh      # Main audit script that generates reports
├── reports/
│   └── complexity-report.html       # Generated HTML audit report
└── README.md                        # This file
```

## 🚀 Quick Start

### Prerequisites

- **Node.js** (v14+) and npm - for TypeScript/JavaScript linting
- **Go** (v1.16+) - for Go code analysis (optional if not using Go)
- **Ruby** (v2.7+) - for Ruby code analysis (optional if not using Ruby)
- **Bash** shell - for running audit script
- **golangci-lint** - install with: `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest`
- **RuboCop** - install with: `gem install rubocop`

### Installation

1. **Clone or download the project:**
   ```bash
   cd /home/anhdn/TEST_IR
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

   This installs:
   - ESLint with TypeScript and SonarJS plugins
   - TypeScript compiler
   - All necessary linting tools

### Running the Complexity Check

**Run the main audit script:**
```bash
npm run lint:complexity
```

Or directly:
```bash
./scripts/run-complexity-check.sh
```

**What happens:**
- Analyzes code files for complexity violations
- Generates an HTML report: `reports/complexity-report.html`
- Checks for:
  - High cyclomatic complexity (>15)
  - Deep nesting (>3 levels)
  - Excessive parameters (>4)
  - Code smell violations

### Viewing Results

Open the generated report in a web browser:
```bash
open reports/complexity-report.html    # macOS
xdg-open reports/complexity-report.html # Linux
start reports/complexity-report.html    # Windows
```

## 📊 Complexity Metrics & Evaluation Criteria

This project implements **9 complexity metrics** to evaluate code quality, addressing auditor concerns from the Divoro vulnerability assessment:

### 1. **Cyclomatic Complexity (Rule Complexity)**
- **Definition**: Number of independent execution paths through code
- **Tools**: ESLint `complexity` rule, Gocyclo (Go), RuboCop
- **Threshold**: ≤ 15 per function
- **Example**: Each `if`, `switch`, `for`, `?:` operator increases complexity
- **Status**: ✅ Implemented in ESLint
- **Config**: `.eslintrc.json` - `complexity: [error, 15]`

### 2. **Cognitive Complexity**
- **Definition**: How difficult the code is to understand (considers nesting levels)
- **Tools**: `eslint-plugin-sonarjs/cognitive-complexity`
- **Threshold**: ≤ 15 per function
- **Differs from Cyclomatic**: Weights nested structures more heavily
- **Status**: ✅ Implemented via SonarJS plugin
- **Config**: `.eslintrc.json` - `sonarjs/cognitive-complexity`

### 3. **Max Depth (Nesting Depth)**
- **Definition**: Maximum nesting level of control structures
- **Tools**: ESLint `max-depth` rule
- **Threshold**: ≤ 3 levels (if, try, switch, for, while)
- **Example**: Detects deep nested IFs flagged in Go code
- **Status**: ✅ Implemented in ESLint
- **Config**: `.eslintrc.json` - `max-depth: [error, 3]`

### 4. **Max Parameters (Function Parameters)**
- **Definition**: Number of function parameters
- **Tools**: ESLint `max-params` rule, RuboCop
- **Threshold**: ≤ 4 parameters per function
- **Example**: Ruby `complex_method(arg1...arg6)` violates this
- **Status**: ✅ Implemented in ESLint & RuboCop
- **Config**: `.eslintrc.json` - `max-params: [error, 4]`

### 5. **Max Statements (Statements per Function)**
- **Definition**: Number of executable statements in a function
- **Tools**: ESLint `max-statements` rule
- **Threshold**: ≤ 50 statements per function
- **Purpose**: Prevents overly long functions
- **Status**: ✅ Implemented in ESLint
- **Config**: `.eslintrc.json` - `max-statements: [error, 50]`

### 6. **Max Lines per Function**
- **Definition**: Physical lines of code in a function
- **Tools**: ESLint `max-lines-per-function` rule
- **Threshold**: ≤ 100 lines per function
- **Purpose**: Keeps functions readable and maintainable
- **Status**: ✅ Implemented in ESLint
- **Config**: `.eslintrc.json` - `max-lines-per-function: [error, 100]`

### 7. **Max Nested Callbacks**
- **Definition**: Nesting depth of async/callback chains
- **Tools**: ESLint `max-nested-callbacks` rule
- **Threshold**: ≤ 3 levels
- **Purpose**: Prevents "callback hell" in async code
- **Status**: ✅ Implemented in ESLint
- **Config**: `.eslintrc.json` - `max-nested-callbacks: [error, 3]`

### 8. **No Nested Ternary**
- **Definition**: Prohibits nested ternary operators (?:)
- **Tools**: ESLint `no-nested-ternary` rule
- **Threshold**: Zero nested ternaries allowed
- **Example**: `a ? b ? c : d : e` is flagged
- **Status**: ✅ Implemented in ESLint
- **Config**: `.eslintrc.json` - `no-nested-ternary: error`

### 9. **Duplicate & Maintainability Check**
- **Definition**: Detects code duplication and maintainability issues
- **Tools**: `eslint-plugin-sonarjs` (duplicate-string, no-duplicated-branches)
- **Threshold**: Flags duplicate strings and logic blocks
- **Purpose**: Reduces maintenance burden and bug propagation
- **Status**: ✅ Implemented via SonarJS plugin
- **Config**: `.eslintrc.json` - SonarJS rules enabled

---

## 🔍 Implementation by Language

### TypeScript/JavaScript (Primary - Fully Implemented)
**Metrics Covered**: All 9 criteria ✅
- **Tools**: ESLint + @typescript-eslint + eslint-plugin-sonarjs
- **Config File**: `.eslintrc.json`
- **Coverage**: demo-bad-code.ts, demo-bad-code copy.ts
- **Report**: Integrated into HTML report
- **Status**: Ready to use - `npm run lint:complexity`

### Go (Implemented - Ready to Use)
**Metrics Covered**: Cyclomatic Complexity ✅, Cognitive Complexity ✅, Max Depth ✅, Function Length ✅
- **Tool**: Golangci-lint with configured linters
- **Config File**: `.golangci.yml` (already configured)
- **Linters Enabled**:
  - `gocyclo` - Cyclomatic complexity (threshold: 10)
  - `gocognit` - Cognitive complexity (threshold: 15)
  - `cyclop` - Alternative complexity metric (max: 10)
  - `funlen` - Function/method length (60 lines, 40 statements)
  - `nestif` - Nesting depth (threshold: 3)
  - `goconst` - Constant detection
- **Example File**: main.go (with violations for demo)
- **To Use**:
  ```bash
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
  golangci-lint run ./...
  ```

### Ruby (Implemented - Ready to Use)
**Metrics Covered**: Cyclomatic Complexity ✅, Perceived Complexity ✅, Method Length ✅, Max Parameters ✅
- **Tool**: RuboCop with metric linters
- **Config File**: `.rubocop.yml` (already configured)
- **Metrics Enabled**:
  - `Cyclomatic Complexity` (max: 10)
  - `Perceived Complexity` (max: 10)
  - `Method Length` (max: 30 lines)
  - `Class Length` (max: 200 lines)
  - `Parameter Lists` (max: 4)
- **Example File**: test_complexity.rb (with violations for demo)
- **To Use**:
  ```bash
  gem install rubocop
  rubocop
  rubocop --format json > reports/rubocop.json
  ```

## 🔧 Configuration Details

### ESLint Configuration (.eslintrc.json)

Current configuration includes all 9 metrics:

```json
{
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 2021,
    "sourceType": "module"
  },
  "plugins": [
    "@typescript-eslint",
    "sonarjs"
  ],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:sonarjs/recommended"
  ],
  "rules": {
    // 1. Cyclomatic Complexity
    "complexity": ["error", 15],
    
    // 2. Cognitive Complexity
    "sonarjs/cognitive-complexity": ["error", 15],
    
    // 3. Max Depth (Nesting)
    "max-depth": ["error", 3],
    
    // 4. Max Parameters
    "max-params": ["error", 4],
    
    // 5. Max Statements
    "max-statements": ["error", 50],
    
    // 6. Max Lines per Function
    "max-lines-per-function": ["error", 100],
    
    // 7. Max Nested Callbacks
    "max-nested-callbacks": ["error", 3],
    
    // 8. No Nested Ternary
    "no-nested-ternary": "error",
    
    // 9. Duplicate & Maintainability (SonarJS)
    "sonarjs/no-duplicated-branches": "error",
    "sonarjs/no-identical-functions": "error"
  },
  "env": {
    "node": true,
    "es2021": true
  }
}
```

**How to Customize Thresholds:**
- Modify numeric values in rules above
- Example: `"max-depth": ["error", 2]` to make stricter
- Example: `"complexity": ["warn", 20]` to warn instead of error
- Restart ESLint to apply changes

### npm Scripts Configuration (package.json)

```json
{
  "scripts": {
    "lint:complexity": "./scripts/run-complexity-check.sh",
    "lint:check": "eslint demo-bad-code.ts --format json > reports/eslint-raw.json || true",
    "lint:fix": "eslint demo-bad-code.ts --fix"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.50.0",
    "eslint-plugin-sonarjs": "^0.23.0",
    "typescript": "^5.0.0"
  }
}
```

### RuboCop Configuration (.rubocop.yml)

For Ruby code analysis. Currently configured with:
- Cyclomatic Complexity: Max 10
- Perceived Complexity: Max 10
- Method Length: Max 30 lines
- Class Length: Max 200 lines
- Parameter Lists: Max 4 parameters

**Key Rules:**
```yaml
Metrics/CyclomaticComplexity:
  Max: 10

Metrics/PerceivedComplexity:
  Max: 10

Metrics/MethodLength:
  Max: 30

Metrics/ParameterLists:
  Max: 4
```

### Golangci-lint Configuration (.golangci.yml)

For Go code analysis. Currently configured with linters:
- **gocyclo** - Cyclomatic complexity (min: 10)
- **gocognit** - Cognitive complexity (min: 15)
- **cyclop** - Alternative complexity check (max: 10)
- **funlen** - Function length (60 lines, 40 statements)
- **nestif** - Nested if depth (min: 3)
- **goconst** - Constant suggestions

**Key Settings:**
```yaml
linters-settings:
  gocyclo:
    min-complexity: 10

  gocognit:
    min-complexity: 15

  cyclop:
    max-complexity: 10

  funlen:
    lines: 60
    statements: 40

  nestif:
    min-complexity: 3
```

**To run locally:**
```bash
# Install golangci-lint
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Run checks
golangci-lint run ./...

# Run specific linter
golangci-lint run --enable gocyclo ./...
```

---

## 🔄 Jenkins CI/CD Setup (Weekly Automated Audit)

### Jenkins Schedule Overview

The audit runs **automatically every week** (Sundays at 2:00 AM UTC).

- **Trigger**: Cron schedule `0 2 * * 0` (Jenkinsfile)
- **Timeout**: 15 minutes max
- **Frequency**: Weekly
- **Build Retention**: Last 10 builds archived
- **Report Storage**: Jenkins artifacts folder

### Jenkins Server Configuration Steps

**Step 1: Create New Pipeline Job**
```
1. Jenkins Home → New Item
2. Enter Name: "Code-Complexity-Audit"
3. Select: Pipeline
4. Click OK
```

**Step 2: Configure Pipeline**
```
1. Under "Pipeline" section:
   - Definition: "Pipeline script from SCM"
   - SCM: "Git"
   - Repository URL: <your-git-repo-url>
   - Credentials: (setup if needed)
   - Branch: */main
   - Script Path: Jenkinsfile
2. Click Save
```

**Step 3: Enable Weekly Schedule**
```
The schedule is already in Jenkinsfile:
  triggers {
    cron('0 2 * * 0')  // Runs Sundays 2:00 AM
  }
```

**Step 4: Test Run**
```
1. Click "Build Now"
2. Wait for build to complete (3-5 minutes)
3. Click on build number → Console Output
4. Verify: "✅ Report generated successfully"
5. Download report from Artifacts section
```

### Accessing Reports

After each Jenkins build:
```
1. Go to Jenkins job → Last Build
2. Click "Artifacts" → reports/
3. Download: complexity-report.html
4. Open in browser to view detailed findings
```

### Customizing the Schedule

Edit `Jenkinsfile` and change the cron expression:

```groovy
triggers {
    // Current: Sundays 2:00 AM
    cron('0 2 * * 0')
    
    // Alternate options:
    // Monday 9:00 AM
    // cron('0 9 * * 1')
    
    // Daily 3:00 AM
    // cron('0 3 * * *')
    
    // Every 4 hours
    // cron('0 */4 * * *')
}
```

Then commit and push to trigger Jenkins to reload the schedule.

---

## 🎯 Demo Instructions (For Auditors & Stakeholders)

### Live Demo Setup (5-10 minutes)

**Preparation:**
1. Clone/download the project
2. Install dependencies: `npm install`
3. Ensure all files present (main.go, demo-bad-code.ts, test_complexity.rb)

**Demo Steps:**

**1. Show Current State**
```bash
# Terminal 1: Show project structure
ls -la

# Terminal 2: Show the bad code examples
cat demo-bad-code.ts    # Show violations
cat main.go            # Show deep nesting
cat test_complexity.rb # Show parameter violations
```

**2. Run Audit (Live)**
```bash
# This shows real-time analysis
npm run lint:complexity

# OR more detailed:
./scripts/run-complexity-check.sh
```

**3. Open Generated Report**
```bash
# Open in browser
open reports/complexity-report.html

# Show:
# - All 9 metrics explained
# - Violations flagged
# - Severity levels
# - Recommendations
```

**4. Explain Findings**
```
For Auditors:
- "Cyclomatic Complexity: Violations detected in 2 functions"
  → Shows we're measuring rule complexity per auditor request
- "Max Depth: 6 levels detected (threshold: 3)"
  → Shows nesting control working
- "Cognitive Complexity report"
  → Shows code understandability metric
```

**5. Show Weekly Automation**
```
Explain Jenkins setup:
- "This runs automatically every week"
- "Reports archived for trend analysis"
- "Early warning system for code degradation"
```

### Demo Talking Points

| Metric | Why It Matters | What We Do |
|--------|---------------|-----------| 
| **Cyclomatic Complexity** | Auditor concern: code testability & maintainability | Measured & flagged if >15 |
| **Cognitive Complexity** | Auditor concern: code understandability | Measured with SonarJS |
| **Nesting Depth** | Risk: logic errors in deep nesting | Limited to 3 levels |
| **Parameters** | Risk: hard to test, understand functions | Max 4 per function |
| **Function Length** | Risk: functions doing too much | Max 100 lines |
| **Duplicates** | Risk: bugs in multiple places | Detected & flagged |
| **Weekly Audit** | Proactive: catch issues early | Automated Jenkins job |
| **HTML Report** | Visibility: easy to share findings | Generated with all details |

---

## 🤝 Handover Guide (For Development Teams)

### Project Transfer Checklist

**Phase 1: Setup (Day 1)**
- [ ] Clone project to team repository
- [ ] Install dependencies: `npm install`
- [ ] Verify all config files present (.eslintrc.json, Jenkinsfile)
- [ ] Test local run: `npm run lint:complexity`
- [ ] Confirm HTML report generates

**Phase 2: Jenkins Setup (Day 2)**
- [ ] Create Jenkins pipeline job
- [ ] Configure Git credentials
- [ ] Set cron schedule
- [ ] Run first test build
- [ ] Verify artifacts archived
- [ ] Team members access Jenkins

**Phase 3: Knowledge Transfer (Day 3)**
- [ ] Document team's code standards
- [ ] Adjust ESLint thresholds if needed (`.eslintrc.json`)
- [ ] Assign owner for weekly review
- [ ] Setup email notifications for Jenkins
- [ ] Create team dashboard/monitoring

**Phase 4: Integration (Day 4+)**
- [ ] Include audit in code review process
- [ ] Create action items from violations
- [ ] Track trends over weeks
- [ ] Monthly retrospective on improvements

### Customization for Your Team

**1. Adjust Complexity Thresholds**

Edit `.eslintrc.json` to match team standards:
```json
{
  "rules": {
    "complexity": ["error", 12],           // Stricter
    "max-depth": ["error", 2],             // Stricter
    "max-params": ["error", 3],            // Stricter
    "max-statements": ["error", 40]        // Stricter
  }
}
```

**2. Modify File Patterns**

In `scripts/run-complexity-check.sh`, update to scan your actual codebase:
```bash
# Current (demo):
eslint demo-bad-code.ts

# Change to scan your project:
eslint src/**/*.ts
eslint app/**/*.tsx
```

**3. Extend to More Languages**

Go linting is already configured. To enable:
```bash
# Install golangci-lint (one-time setup)
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Run against Go code
golangci-lint run ./...
```

Ruby linting is already configured. To enable:
```bash
# Install rubocop (one-time setup)
gem install rubocop

# Run against Ruby code
rubocop test_complexity.rb
rubocop --format json > reports/rubocop.json
```

To add to automated script, edit `scripts/run-complexity-check.sh`:
```bash
# Add these lines to the shell script:
echo "Running Go complexity checks..."
golangci-lint run ./... --format json

echo "Running Ruby complexity checks..."
rubocop --format json
```

### Maintenance Schedule

| Task | Frequency | Owner | Notes |
|------|-----------|-------|-------|
| Review weekly Jenkins report | Weekly | Dev Lead | Check for regressions |
| Update thresholds | Quarterly | Tech Lead | Based on team velocity |
| Upgrade ESLint/plugins | Quarterly | DevOps | Keep tools current |
| Team training | Annually | Dev Lead | Explain metrics, best practices |
| Jenkins backup | Monthly | DevOps | Preserve build history |

### Support & Troubleshooting

**Common Issues & Solutions:**

1. **"npm install fails"**
   ```bash
   rm -rf node_modules package-lock.json
   npm cache clean --force
   npm install
   ```

2. **"Report not generating"**
   ```bash
   # Verify script permissions
   chmod +x scripts/run-complexity-check.sh
   
   # Check reports directory
   mkdir -p reports
   ls -la reports/
   ```

3. **"ESLint won't run"**
   ```bash
   # Clear cache
   npx eslint --debug demo-bad-code.ts
   
   # Verify config
   cat .eslintrc.json
   ```

4. **"Jenkins can't find Jenkinsfile"**
   ```
   - Verify file exists in repo root
   - Check spelling: Jenkinsfile (capital J, no extension)
   - Verify branch is correct in Jenkins config
   ```

**Contact/Questions:**
- Check README.md for all configuration details
- Review generated reports for specific violations
- Consult ESLint docs: https://eslint.org/
- SonarJS docs: https://github.com/SonarSource/eslint-plugin-sonarjs

---

## 📝 Example Issues

### ❌ Deeply Nested IF (Go)
```go
if a > 0 {
    if b > 0 {
        if c > 0 {
            if d > 0 {
                if e > 0 {
                    if f > 0 {
                        if g > 0 {
                            // Too deep!
                        }
                    }
                }
            }
        }
    }
}
```
**Issue:** 6 levels of nesting (threshold is 3)

### ❌ High Cyclomatic Complexity (Ruby)
```ruby
def complex_method(arg1, arg2, arg3, arg4, arg5, arg6)
  # Too many parameters: 6 (threshold is 4)
  # Multiple branches increase complexity
end
```

## 🔄 Workflow for Users

1. **Set up the project:**
   ```bash
   npm install
   ```

2. **Run the complexity check:**
   ```bash
   npm run lint:complexity
   ```

3. **Review the report:**
   - Open `reports/complexity-report.html` in your browser
   - Identify violations and high-risk areas
   - Prioritize refactoring efforts

4. **Fix issues:**
   - Reduce nesting depth
   - Split complex functions
   - Reduce parameter counts
   - Apply design patterns

5. **Re-run audit:**
   - Verify improvements
   - Track metrics over time

## 🛠️ Troubleshooting

### Script Not Running
```bash
# Make script executable
chmod +x scripts/run-complexity-check.sh

# Run with bash explicitly
bash scripts/run-complexity-check.sh
```

### Missing Dependencies
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### Report Not Generated
- Check `reports/` directory exists
- Verify write permissions: `ls -la reports/`
- Check script output for errors

## 📈 Metrics to Monitor

### Understanding Each Metric

| Metric | Purpose | Target | Impact if Violated |
|--------|---------|--------|-------------------|
| **Cyclomatic Complexity** | Measure logic paths | ≤ 15 | Hard to test, maintain |
| **Cognitive Complexity** | Measure understandability | ≤ 15 | Developer confusion, bugs |
| **Max Depth** | Prevent deep nesting | ≤ 3 | Logic errors, hard to follow |
| **Max Parameters** | Keep functions focused | ≤ 4 | Hard to test, understand |
| **Max Statements** | Prevent long functions | ≤ 50 | Single responsibility violation |
| **Max Lines/Function** | Control function size | ≤ 100 | Reusability issues |
| **Nested Callbacks** | Prevent callback hell | ≤ 3 | Async bug propagation |
| **Nested Ternary** | Readability | 0 | Confusing conditions |
| **Duplicates** | DRY principle | 0 | Maintenance nightmare |

### How to Read the Report

When you open `reports/complexity-report.html`:

```
✅ PASS: Max Depth
   └─ All functions: depth ≤ 3 ✓

⚠️  WARNING: Cyclomatic Complexity
   └─ Function "handleRequest()": 18 (threshold: 15)
   └─ Function "validateInput()": 12 (threshold: 15)

❌ FAIL: Max Parameters
   └─ Function "processData(a,b,c,d,e)": 5 params (threshold: 4)
```

**How to Interpret:**
- **✅ PASS**: No violations, continue monitoring
- **⚠️ WARNING**: Approaching threshold, consider refactoring
- **❌ FAIL**: Threshold exceeded, requires refactoring

## 🎓 Refactoring Best Practices

### 1. Reduce High Cyclomatic Complexity (>15)

**Problem:**
```typescript
// Complexity: 18 ❌
function processOrder(order, user, config, isUrgent, hasDiscount) {
  if (order.status === 'new') {
    if (user.isPremium) {
      if (config.allowDiscount && hasDiscount) {
        if (isUrgent) {
          // ... complex logic
        }
      }
    }
  }
  switch (order.type) { /* 10+ cases */ }
}
```

**Solution - Extract Methods:**
```typescript
// Complexity: 6 ✅ (split into focused functions)
function processOrder(order, user, config, isUrgent, hasDiscount) {
  const discount = calculateDiscount(user, config, hasDiscount);
  const priority = calculatePriority(isUrgent, user);
  return applyOrderProcessing(order, discount, priority);
}

function calculateDiscount(user, config, hasDiscount) { /* simple logic */ }
function calculatePriority(isUrgent, user) { /* simple logic */ }
function applyOrderProcessing(order, discount, priority) { /* simple logic */ }
```

### 2. Reduce Deep Nesting (Max Depth >3)

**Problem:**
```typescript
// Depth: 6 ❌
if (user.active) {
  if (user.verified) {
    if (order.valid) {
      if (payment.approved) {
        if (inventory.available) {
          // Process order (5 levels deep!)
        }
      }
    }
  }
}
```

**Solution - Guard Clauses:**
```typescript
// Depth: 1 ✅ (early returns)
if (!user.active) return error;
if (!user.verified) return error;
if (!order.valid) return error;
if (!payment.approved) return error;
if (!inventory.available) return error;

// Now safely proceed (all prerequisites met)
processOrder();
```

### 3. Reduce Function Parameters (>4)

**Problem:**
```typescript
// 6 params ❌
function submitForm(name, email, phone, address, country, zipcode) {
  // Which parameters are required vs optional? Confusing!
}
```

**Solution - Use Object Parameter:**
```typescript
// 1 param (object) ✅ - clearer, easier to extend
interface UserData {
  name: string;
  email: string;
  phone?: string;
  address?: string;
  country?: string;
  zipcode?: string;
}

function submitForm(userData: UserData) {
  // Clear what data is needed
}

// Usage
submitForm({
  name: "John",
  email: "john@example.com",
  // Only include needed fields
});
```

### 4. Reduce Function Length (>100 lines)

**Problem:**
```typescript
// 150 lines ❌
function generateReport(data) {
  // 1. Parse data (20 lines)
  // 2. Validate data (20 lines)
  // 3. Transform data (30 lines)
  // 4. Calculate metrics (40 lines)
  // 5. Format output (40 lines)
  // Too many responsibilities!
}
```

**Solution - Single Responsibility:**
```typescript
// Each function: 20-30 lines ✅
function generateReport(data) {
  const parsed = parseData(data);
  const validated = validateData(parsed);
  const transformed = transformData(validated);
  const metrics = calculateMetrics(transformed);
  return formatOutput(metrics);
}

function parseData(data) { /* 20 lines */ }
function validateData(data) { /* 20 lines */ }
function transformData(data) { /* 30 lines */ }
function calculateMetrics(data) { /* 20 lines */ }
function formatOutput(data) { /* 15 lines */ }
```

### 5. Eliminate Nested Ternary Operators

**Problem:**
```typescript
// ❌ Hard to read
const level = score > 90 ? "A" : score > 80 ? "B" : score > 70 ? "C" : "F";
```

**Solution - Switch or Guard Clauses:**
```typescript
// ✅ Clear and readable
function getGrade(score) {
  if (score > 90) return "A";
  if (score > 80) return "B";
  if (score > 70) return "C";
  return "F";
}

// OR use switch
function getGrade(score) {
  switch (true) {
    case score > 90: return "A";
    case score > 80: return "B";
    case score > 70: return "C";
    default: return "F";
  }
}
```

### 6. Remove Code Duplication

**Problem:**
```typescript
// ❌ Logic repeated in 3 places
function validateEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

function checkUserEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

function verifyContactEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}
```

**Solution - Extract Shared Logic:**
```typescript
// ✅ Single source of truth
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function isValidEmail(email) {
  return emailRegex.test(email);
}

// Reuse
validateEmail(email) { return isValidEmail(email); }
checkUserEmail(email) { return isValidEmail(email); }
verifyContactEmail(email) { return isValidEmail(email); }
```

### Refactoring Checklist

- [ ] **Reduce methods with cyclomatic complexity > 15**
  - Extract smaller functions
  - Use polymorphism instead of switch
  
- [ ] **Remove nesting depth > 3**
  - Apply early return guards
  - Use helper functions
  
- [ ] **Reduce parameters > 4**
  - Use object/interface
  - Consider builder pattern
  
- [ ] **Shorten methods > 100 lines**
  - Single responsibility principle
  - Extract helper methods
  
- [ ] **Remove nested ternary operators**
  - Use if/else blocks
  - Consider switch statements
  
- [ ] **Eliminate code duplication**
  - Extract common logic
  - Use shared utilities

---

## ✅ Project Status & DoD (Definition of Done)

### Completed Tasks ✅

- [x] **Multi-language code examples** - Go, Ruby, TypeScript with violations
- [x] **9 Complexity metrics configured** - All metrics implemented in ESLint
- [x] **HTML report generation** - Automated report with findings
- [x] **ESLint configuration** - `.eslintrc.json` with all 9 rules
- [x] **npm scripts** - `npm run lint:complexity` for easy execution
- [x] **Documentation** - Complete README with setup, config, demo instructions
- [x] **Handover guide** - Step-by-step team transfer checklist
- [x] **Troubleshooting** - Common issues and solutions
- [x] **Best practices** - Refactoring examples and patterns

### Jenkins Automation ✅

- [x] **Weekly schedule** - Configured in Jenkinsfile (`0 2 * * 0`)
- [x] **Automated runs** - No manual intervention needed
- [x] **Report archiving** - Builds saved for trend analysis
- [x] **Timeout protection** - 15-minute safety limit
- [x] **Build retention** - Last 10 builds kept

### Demo Readiness ✅

- [x] **Quick demo** - 5-10 minute walkthrough ready
- [x] **Stakeholder talking points** - Auditor concerns addressed
- [x] **Example violations** - Real code showing all 9 metrics
- [x] **Report visualization** - HTML dashboard with findings

### Team Handover ✅

- [x] **Setup checklist** - 4-phase implementation guide
- [x] **Customization guide** - How to adjust thresholds and files
- [x] **Maintenance schedule** - Weekly/quarterly tasks defined
- [x] **Support documentation** - Troubleshooting and contact info

---

## 🎓 Knowledge Base

### Quick Reference

```bash
# Setup
npm install

# Run audit (local) - TypeScript/JS
npm run lint:complexity

# Run directly
./scripts/run-complexity-check.sh

# View report
open reports/complexity-report.html

# Check individual metrics - TypeScript/JS
npx eslint demo-bad-code.ts

# Fix auto-fixable issues
npx eslint demo-bad-code.ts --fix

# Check Go code
golangci-lint run ./...

# Check Ruby code
rubocop test_complexity.rb
```

### Key Files

- **`.eslintrc.json`** - TypeScript/JS: All 9 metric thresholds configured
- **`.golangci.yml`** - Go: Cyclomatic complexity, cognitive complexity, function length, nesting depth
- **`.rubocop.yml`** - Ruby: Cyclomatic complexity, perceived complexity, method length
- **`Jenkinsfile`** - Weekly automation setup
- **`package.json`** - Dependencies and scripts
- **`scripts/run-complexity-check.sh`** - Main audit script
- **`reports/complexity-report.html`** - Generated findings

## 📚 Resources

- [Cyclomatic Complexity - Wikipedia](https://en.wikipedia.org/wiki/Cyclomatic_complexity)
- [ESLint Documentation](https://eslint.org/)
- [SonarJS Rules](https://github.com/SonarSource/eslint-plugin-sonarjs)
- [RuboCop Documentation](https://rubocop.org/)

## 📜 License

This project is provided for demonstration and educational purposes.

## 👥 Support

For issues or questions, refer to:
- Review the generated HTML report for detailed findings
- Check script logs: `scripts/run-complexity-check.sh`
- Examine individual code files for violations
