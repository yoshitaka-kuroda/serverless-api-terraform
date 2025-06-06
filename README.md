AWSサーバーレスAPI自動構築（Terraform／Lambda＋API Gateway HTTP API＋DynamoDB）  
API Gateway（HTTP API）＋AWS Lambda＋DynamoDBというサーバレス構成のAPIサービスをTerraformで自動構築するサンプルプロジェクトです。  
API Gatewayにアクセスすると、Lambda関数（サーバーレスのプログラム）が実行され、「Hello, World!」というメッセージが返ります。今回の例ではDynamoDBを組み込んでいますが、サンプルなので「Hello, World!」を返すシンプルなAPI構成です。インフラ構築やプログラムのデプロイはすべてTerraformで管理します。

---

## 採用AWSサービスと用途

**Lambda**  
　APIリクエストごとに自動で起動し、任意のPythonコードを実行します。サーバーレスのため「サーバー管理一切不要」で、処理したデータはDynamoDBに保存します。

**API Gateway（HTTP API）**  
　外部公開エンドポイントを自動生成し、受け取ったリクエストをLambdaにルーティングします。  
　「HTTP API」はREST APIに比べてシンプルかつ低コスト・低レイテンシで、イベント駆動やWebhook連携などモダン用途にも最適です。

**DynamoDB**  
　フルマネージドNoSQLデータベースです。Lambdaから呼び出され、APIで受け取ったデータを永続化します。高可用性でスケーラブルなため、本番環境でも安心して使えます。

**IAMロール**  
　LambdaやAPI Gatewayなどサービス間の「安全なアクセス権限」をTerraformで自動構成します。  
　例：LambdaにはDynamoDBへの読み書き権限のみを付与し、過剰な権限を持たせません。

---

## 実行手順

```bash
# 1. environments/dev ディレクトリへ移動
cd serverless-api-terraform/environments/dev

# 2. Terraform 初期化
terraform init

# 3. （任意）設定ファイルの文法チェック
terraform validate

# 4. 実行計画の確認
terraform plan -out=tfplan.out

# 5. リソースの作成
terraform apply tfplan.out

上記実行後、API Gateway のエンドポイント URL が出力されます。

curl -X POST <出力されたURL> -d '{"message":"Hello World"}'
レスポンスに "Hello, World!" が返ってくれば正常です。

ディレクトリ構成

```
serverless-api-terraform/
│
├── environments/               # 環境ごとの Terraform 実行用ファイルを格納
│   └── dev/
│       ├── main.tf             # モジュール呼び出し・環境ごとメイン定義
│       ├── variables.tf        # main.tf で使う変数定義
│       └── terraform.tfvars    # 環境固有の値（例：テーブル名、Lambda名など）
│
├── modules/                    # 再利用可能なモジュール群
│   ├── apigw/                  # API Gateway（HTTP API）構成モジュール
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── lambda/                 # Lambda 関数構成モジュール
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── dynamodb/               # DynamoDB テーブル構成モジュール
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── README.md                   # このファイル
```

補足・解説
API Gateway HTTP API
REST API に比べてコスト・レイテンシ共に有利なため、最近の AWS プロジェクトでは標準的に選択される傾向があります。
シンプルなルーティング設定でも十分に API 要件を満たせるのが特徴です。

Lambda
AWS管理の実行環境で自動実行＆スケーリングされるため、インフラ保守が不要になります。
今回は Python コードで「Hello, World!」を返すだけの最低限の処理を実装していますが、
本番環境では認証やエラーハンドリング、外部サービス連携などを追加しても構いません。

DynamoDB
サーバーレス＆NoSQL のため、RDS と比較して運用負荷が低く、
料金も従量課金制で安価です。本プロジェクトでは簡易的にテーブルを作成し、
API 経由でデータを保存・取得できる仕組みを構築しています。

IAM ロール
Terraform で Lambda 用の IAM ロールを作成し、最小限の権限（DynamoDB への読み書き権限など）のみを付与します。
API Gateway には Lambda 実行権限を付与し、必要以上の権限は与えないように設計
