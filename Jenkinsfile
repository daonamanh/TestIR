pipeline {
    agent any

    // Lập lịch tự động chạy vào 02:00 AM sáng Chủ Nhật hàng tuần
    triggers {
        cron('0 2 * * 0')
    }

    options {
        timeout(time: 15, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('1. Checkout SCM') {
            steps {
                echo '=== Tải mã nguồn mới nhất từ Git ==='
                checkout scm
            }
        }

        stage('2. Install Dependencies') {
            steps {
                script {
                    echo '=== Cài đặt các thư viện linter ==='
                    if (fileExists('package.json')) {
                        sh 'npm ci || npm install'
                    }
                    if (fileExists('go.mod')) {
                        sh 'go mod download || true'
                    }
                    if (fileExists('Gemfile')) {
                        sh 'bundle install || true'
                    }
                }
            }
        }

        stage('3. Run Complexity Audit') {
            steps {
                script {
                    echo '=== Chạy script kiểm tra độ phức tạp code ==='
                    sh 'chmod +x ./scripts/run-complexity-check.sh'
                    
                    // Cho phép script trả về lỗi (exit code != 0) mà không làm sập hỏng Pipeline
                    // để Jenkins vẫn tiếp tục qua bước public báo cáo HTML
                    sh './scripts/run-complexity-check.sh || true'
                }
            }
        }

        stage('4. Publish HTML Report') {
            steps {
                echo '=== Đẩy báo cáo HTML lên giao diện Jenkins ==='
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'reports',
                    reportFiles: 'complexity-report.html',
                    reportName: 'Weekly Code Complexity Audit',
                    reportTitles: 'Divoro Code Complexity Compliance Report'
                ])
            }
        }
    }

    post {
        always {
            echo '=== Hoàn tất tiến trình kiểm tra Code Complexity ==='
        }
    }
}
