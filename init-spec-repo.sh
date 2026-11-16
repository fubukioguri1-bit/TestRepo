#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# ① 変更が必要な項目
# -------------------------------------------------
REPO_NAME="testRepo"                     # 任意のリポジトリ名
REMOTE_URL="fubukioguri1@1bit:https://github.com/fubukioguri1-bit/TestRepo.git"   # GitHub のリモート URL（SSH 推奨）

# -------------------------------------------------
# ② ディレクトリ構成の作成
# -------------------------------------------------
mkdir -p "$REPO_NAME"

cd "$REPO_NAME"

# ルート README と .gitignore
cat > README.md <<'EOF'
# $REPO_NAME 仕様書

## 目次
- [0. Overview](0_overview/)
- [1. Requirements](1_requirements/)
- [2. Architecture](2_architecture/)
- [3. Data Model](3_data/)
- [4. Operations](4_operations/)
- [5. Testing](5_testing/)
- [6. Risk Management](6_risk-management/)

> 本リポジトリは Markdown と Mermaid を用いて仕様書をモジュール化しています。  
> 変更は Pull Request でレビューしてください。
EOF

cat > .gitignore <<'EOF'
# OS
.DS_Store
Thumbs.db

# Node
node_modules/
npm-debug.log

# IDE / Editor
.vscode/
.idea/
*.sublime-workspace
*.sublime-project

# Build artefacts
dist/
build/
*.log

# Mermaid generated PNG/SVG (if you ever export)
*.png
*.svg
EOF

# -------------------------------------------------
# ③ 各サブディレクトリとサンプルファイルを作成
# -------------------------------------------------
declare -A DIRS=(
  ["0_overview"]="0.1_background.md 0.2_goals.md 0.3_stakeholders.md"
  ["1_requirements"]="1.1_functional.md 1.2_nonfunctional.md 1.3_constraints.md"
  ["2_architecture"]="2.1_system-context.mermaid.md 2.2_component-diagram.mermaid.md 2.4_deployment.md"
  ["2_architecture/2.3_sequence-diagrams"]="2.3.1_user-login.mermaid.md 2.3.2_data-sync.mermaid.md"
  ["3_data"]="3.1_entity-relationship.md 3.2_schema.sql 3.3_data-dictionary.md"
  ["4_operations"]="4.1_ci-cd.md 4.2_monitoring.md 4.3_backup-recovery.md 4.4_security.md"
  ["5_testing"]="5.1_test-strategy.md 5.2_test-cases"
  ["5_testing/5.2_test-cases"]="5.2.1_unit-tests.md 5.2.2_integration-tests.md 5.2.3_performance-tests.md"
  ["6_risk-management"]="6.1_risk-register.md"
  ["docs"]="README.md"
)

# テンプレート本文（簡易版）を関数で作成
create_file() {
  local path="$1"
  local filename="$2"
  local content="$3"
  cat > "$path/$filename" <<EOF
$content
EOF
}

for dir in "${!DIRS[@]}"; do
  mkdir -p "$dir"
  for file in ${DIRS[$dir]}; do
    case "$file" in
      *.md)
        # Markdown のベーシックテンプレート
        create_file "$dir" "$file" "# ${file%.*}
  
ここに概要を書きます。"
        ;;
      *.sql)
        # SQL スキーマの雛形
        create_file "$dir" "$file" "-- 例: テーブル定義
CREATE TABLE example (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);"
        ;;
    esac
  done
done

# -------------------------------------------------
# ④ Git 初期化 & リモート設定
# -------------------------------------------------
git init
git add .
git commit -m "Initial commit: repository skeleton for specification documents"
git branch -M main

# リモートが設定されていれば push
if [[ -n "$REMOTE_URL" ]]; then
  git remote add origin "$REMOTE_URL"
  git push -u origin main
fi

echo "✅ リポジトリ作成が完了しました！"
echo "   - ディレクトリ構成は `tree -L 3` で確認できます"
echo "   - Markdown / Mermaid の lint はローカルで `npm run lint` などのスクリプトを追加して活用してください"
