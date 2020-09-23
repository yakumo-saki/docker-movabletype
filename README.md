# 使い方

MovableTypeコンテナは以下の手順で自分でビルドする必要があります。

## MovableTypeコンテナの準備

### MovableTypeの入手

個人の場合は https://www.sixapart.jp/inquiry/movabletype/personal_download.html からライセンスに同意して
メールで送られてくるURLからZIPファイルを入手します。
ZIPファイルを展開して（`unzip MT7_R4701.zip`) 中身を`mt`というディレクトリに移動します。
完了後のディレクトリ構成は以下のようになります。

```
.
├── mt
│   ├── index.html
│   ├── mt-atom.cgi
│   ├── mt-cdsearch.cgi
│   ├── mt.cgi
│   ├── mt-check.cgi
│   ├── （略）
├── apache2.conf
├── docker-compose.yml
├── Dockerfile
├── entrypoint.sh
└── README.md
```

### MovableTypeのコンテナのビルド

Dockerfileのあるディレクトリで以下のコマンドを入力します。

```
$ docker build -t movabletype:latest .
```

### コンテナ起動

```
$ docker-compose up -d .
```

### MySQLデータベース関連

```
$ docker-compose exec db mysql -p
Enter password: <password>

mysql> CREATE DATABASE mt DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
mysql> CREATE USER mtuser IDENTIFIED BY 'mtuser_Passw0rd!';
mysql> GRANT ALL on mt.* to mtuser;
mysql> FLUSH PRIVILEGES;
```

### インストールウィザード

`<mt host>:8080` にブラウザでアクセスする。

* データベースの種類 `mysql`
* データベースサーバー `db`
* データベース名 `mt`
* ユーザー名 `mtuser`
* パスワード `mtuser_Passw0rd!`

メールの設定等は各自の環境に合わせて設定してください。

### インストールウィザード（mt-config.cgi）

ウィザードの最後で、 ` Movable Type Proの構成ファイルを保存できませんでした。 ` というエラーが表示されます。
その画面内にある、 `ウィザードで作成されたmt-config.cgiを表示する` というリンクをクリックして
mt-config.cgiの内容を表示させます。
`./data/mt-config/mt-config.cgi` に上記で表示された内容のファイルを作成してください。


### コンテナの再起動

作成した mt-config.cgi を反映させるためにコンテナを再起動します。
`./data/mt-config/mt-config.cgi` はコンテナ起動時に存在を確認して、存在していれば所定の場所にリンクを張る
という動作なので、コンテナを再起動しないと反映されません。


```
$ docker-compose down
$ docker-compose up -d
``` 

### supportディレクトリの所有者変更

/var/www/html/mt-static/support ディレクトリにマップされるディレクトリの所有者を
`www-data` に変更します。これを行わないと、ダッシュボードにエラーが表示されます。

`sudo chown -R www-data.www-data ./data/mt-support`

### インストールの完了

`<mt host>:8080` にブラウザでアクセスすると、ユーザー作成画面になります。
ユーザーを作成すると、データベースが初期化され、MovableTypeが使用可能になります。

## FAQ

* XMLRPC::Transport::HTTP::Plack が見つかりません

すいませんがコンテナに入れていません。構成上使用しないはずなので問題にはならないと思います。


