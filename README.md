
---

## 構築手順

1. **Lambda関数コード作成 & zip化**
    - `lambda_function.py`を作成し`zip lambda.zip lambda_function.py`
2. **terraform init / plan / apply**
    - `cd environments/dev`
    - `terraform init`
    - `terraform plan`
    - `terraform apply`
3. **Outputsに表示されるAPIエンドポイントをブラウザで確認**
    - デプロイ成功で`outputs`にURLが出ます

---

## 実装内容

- AWS API Gateway HTTP API（高速・低コスト）
- Lambda（Python, サーバーレス実行）
- Terraform Module設計
- 全自動デプロイ
- S3 backend化（任意）

---

## 補足

- `terraform.tfvars`や`.tfstate`は `.gitignore`推奨
- **GitHub公開用には「ソース・構成例・README」のみpush**

---

## 参考リンク

- [あなたのGitHubアカウントURL]
