# AWSサーバーレスAPI自動構築（Terraform／Lambda＋API Gateway HTTP API＋DynamoDB）

---

## まえがき

このリポジトリは、**AWSサーバーレス3点セット（Lambda＋API Gateway＋DynamoDB）**を、Terraformのみで“ゼロから自動構築”するサンプルです。  
最小構成かつ「実務現場でよく使われる」モジュール分割形式で、**API構築〜データ永続化までフルIaC化**しています。

---

## 採用AWSサービスと用途

- **Lambda**  
　APIリクエストごとに自動で起動し、任意のPython（今回はサンプル）コードを実行。サーバーレスなため「サーバー管理一切不要」で、処理したデータはDynamoDBに保存します。

- **API Gateway（HTTP API）**  
　外部公開エンドポイントを自動生成し、受け取ったリクエストをLambdaにルーティング。  
　【理由】最新の「HTTP API」はREST APIに比べて**シンプルかつ低コスト・低レイテンシ**で、イベント駆動・Webhook連携などモダン用途にも最適。

- **DynamoDB**  
　フルマネージドNoSQLデータベース。Lambdaから呼び出され、APIで受け取ったデータを永続化。高可用性でスケーラビリティ抜群。

- **IAMロール**  
　LambdaやAPI Gatewayなどサービス間の「安全なアクセス権限」をTerraformで自動構成。

---

## このリポジトリでできること

- すべてTerraformで「AWSサーバーレスAPIフルセット」を数分で自動構築
- コード変更不要・手作業ゼロでインフラ＆API＆DB構築
- 実務で求められる“管理しやすいモジュール構成”で転職ポートフォリオにも最適

---

## 実行手順

1. `terraform init`
2. `terraform plan`
3. `terraform apply`
   - 実行後、API GatewayのURLが出力されます

---

## サンプルAPI呼び出し例

```bash
curl -X POST <出力されたURL> -d '{"message":"Hello World"}'
ディレクトリ構成
plaintext
コピーする
編集する
serverless-api-terraform/
│
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
│
├── modules/
│   ├── apigw/
│   ├── lambda/
│   └── dynamodb/
│
└── README.md
補足・解説
API Gateway HTTP APIは、REST APIよりもコスト削減＆高速化が見込めるため「新規構築ではまず選択肢」となる最新仕様です。

Lambdaは「AWS管理の実行環境」で自動実行＆スケーリングされるため、インフラ保守から解放されます。

DynamoDBは「サーバーレス」＆「NoSQL」なのでRDSと比べて運用負荷ゼロ・料金も従量課金で安価。

こんな方におすすめ
AWS実務未経験だが本格的なサーバーレスAPI構築を体験したい

IaCポートフォリオを作りたい（面接やGitHub用に最適）

既存業務の自動化・API化を個人で再現してみたい
