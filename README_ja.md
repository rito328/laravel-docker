# Laravel Docker Starter
PHP Framework Laravel用 Docker開発環境構築パッケージ for Mac

## システム要件
- Docker Desktop for Mac
- composer (インストールしていない場合は、セットアップ時に導入されます。)
## 動作確認済み環境
- macOS Mojave
- Docker Desktop for Mac: 2.0.0.2
  - Engine: 18.09.1
  - Compose: 1.23.2
## 構築される環境
### appコンテナ
- centos 最新版
  - Apache 2.4
  - PHP 7.2
  - Laravel 最新版
### DBコンテナ
- MySQL 8.0
## ソース構造
```
laravel-docker/
├── README.md
├── docker
│   ├── app
│   │   ├── Dockerfile         ... appサーバのDockerfile
│   │   └── init
│   │       ├── .env           ... Laravelのenvファイル
│   │       ├── .env.testing   ... Laravelのテスト用envファイル
│   │       ├── app_setting.sh ... appサーバの初期動作を制御します。
│   │       └── phpunit.xml    ... Laravel phpunit.xml
│   ├── db
│   │   ├── Dockerfile         ... dbサーバのDockerfile
│   │   ├── conf.d
│   │   │   └── my.cnf         ... MySQLの設定ファイル
│   │   └── init
│   │       └── create_test_db.sh ... テスト用DBを作成する為のシェルスクリプト
│   └── docker-compose.yml     ... appとdbのコンテナはdocker-composeによって制御されます。
├── order.sh                   ... LaravelとDockerを操作するシェルスクリプトです。
└── src                        ... Laravelプロジェクトと初期設定ファイルはこのディレクトリへ設置されます。
```
## Getting started
```
// GithubからソースをCloneします。
git clone https://github.com/rito328/laravel-docker.git

// laravel-dockerディレクトリへ移動します。
cd /path/to/laravel-docker

// セットアップを開始すると、Laravelがインストールされ、Docker環境が起動します。
sh order.sh setup
```
> !! POINT !!
> > Laravelセットアップ時にマイグレーションとシーディングが実行されるので、予めこれらを定義しておく事で、初期データを投入可能です。


セットアップが完了したら、localhostにアクセスします。
```
http://localhost/
```
一度セットアップを行えば、あとはstart/stopで動作を制御できます。
```
// stop
sh order.sh stop 

// start
sh order.sh start
```
Laravelプロジェクトは ```src/``` 配下にインストールされます。
```
laravel-docker/
└── src
     └── laravel
```
Laravelプロジェクトは外部ボリュームからマウントされるため、永続化されます。

## コマンド一覧
```
sh order.sh setup    : Laravelインストール・Docker環境構築を行います。
sh order.sh start    : setup のエイリアスです。
sh order.sh stop     : コンテナを停止します。
sh order.sh restart  : コンテナを再起動します。
sh order.sh destroy  : コンテナ・イメージを削除します。
sh order.sh conn app : appコンテナ（Webサーバ）へ接続します。
sh order.sh conn db  : dbコンテナ内のMySQLへ接続します。
sh order.sh help     : ヘルプを表示します。
```

## Contributions
面倒くさがり屋の為のスターターパックですから、もっと便利になっても良いし、ソースはまだまだ良くなっていくはずです。もちろん、悪い部分は改善されるべきです。是非プルリクエストを送ってください。あなたの参加を歓迎します。

## Message
このパッケージは、LaravelをDocker環境下で気軽に試せるように作りました。  
一部設定ファイルもコミットしているので、これらのソースファイル一式を本番環境にそのままデプロイする事は勧められません。  

Have fun Laravel & Docker life!
