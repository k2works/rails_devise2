## Devise認証をRails3に組み込む
### 目的
Railsアプリでユーザー認証機能を組み込む。
* DBBで開発する。
* メールアドレスではなくユーザー名でログインできるようにする。

### 前提条件
* Rails3.2.13
* Ruby-1.9.2p392
* devise(2.2.4)

### 手順

#### RSpecの設定
1. Gemfileを編集する。

  `gem "rspec-rails"`
  
  `gem "factory_girl_rails"`
  
  `gem "database_cleaner"`
  
  `gem "email_spec"`
    
2. Gemをインストールする。

 `$ bundle`

3. アプリを起動する。

 `$ rails s`

3. RSpecをセットアップする。

 `$ rails g rspec:install`

4. DatabaseCleanerの設定をする。
  
 `$ sepc/spec_helper.rb`

5. FactoryGirlにテストオブジェクトを追加する。

 `$ mkdir spec/support`

 `$ vi spec/support/devise.rb`
      
6. Devise Test Helperを追加する。

 `$ vi spec/support/devise.rb`

7. Email Specの設定

 `$ vi spec/sepc_helper.rb`
 
8. Rails Generatorの設定。

 `$ vi config/application.rb`

9. RSpecの実行

 `$ rake -T`

 `$ rake db:migrate`

 `$ rake db:test:prepare`

 `$ rake spec`

  controller,modelテストの作成

#### Cucumberの設定

1. Gemの追加

 `gem "cucumber-rails"`
  
 `gem "capybara"`
   
 `gem "database_cleaner"`
   
 `gem "email_spec"`

 `$ bundle`

 `$rails g cucumber:install`

2. Database Cleanerの設定の確認

 features/support/env.rb

3. Email Specの設定

 `$ vi features/support/email_spec.rb`

 `$ rails g email_spec:steps`

4. Cucumberの実行

5. Cucumberシナリオ作成

#### 環境設定

1. 環境変数設定ファイル

 `$ rails g figaro:install`

 `$ vi config/application.yaml`

2. メールの設定

#### レイアウトとスタイルシート

1. ナビゲーションリンクの追加

 `$ vi app/views/layouts/_navigation.html.erb`

2. フラッシュメッセージの追加

 `$ vi app/views/layouts/_messages.html.erb`

3. CSSスタイルシートとSASS

 `$ vi app/assets/stylesheets/aplication.css.scss`

4. デフォルアプリケーションレイアウトの編集

 `$ vi app/views/layouts/application.html.erb`

#### 認証機能の組み込み

1. Gemの設定

 `gem 'devise'`

2. Deviseのセットアップ

 `$ rails g devise:install`

3. Deviseのメール設定

4. Devise用モデルの作成

 `$ rails g devise User`

5. Cucumber対応

 `$ vi /config/initializers/devise.rb`

 `config.sign_out_via = Rails.env.test? ? :get : :delete`

6. ログインパスワードをログに表示しないようにする。

 `$ vi config/application.rb`

 `config.filter_parameters += [:password, :password_confirmation]`

#### ユーザー管理機能の追加

1. Migrationの追加

 `$ rails g migration AddNameToUsers name:string`

 `$ rake db:migrate`

 `$ rake db:test:prepare`

2. Userモデルの修正

 `$ vi app/models/user.rb`

3. ユーザー登録画面の作成

 `$ mkdir -p app/views/devise/registrations/`

 `$ vi app/views/devise/registrations/new.html.erb`

 `$ vi app/views/devise/registrations/edit.html.erb`

#### ホームページの追加

1. コントローラーの追加
 
 `$ rm public/index.html`

 `$ rails g controller home index --no-controller-specs --skip-stylesheets --skip-javascripts`

2. config/routes.rbの編集

3. ユーザーを表示できるようにする

 `$ vi app/controllers/home_controller.rb`

 `$ vi app/views/home/index.html.erb`

#### データの初期化
1. Seedファイルの作成

 `$ vi db/seeds.rb`

 `$ rake db:migrate`

 `$ rake db:seed`

#### ユーザーページの作成
1. リンクの追加

 `$ vi app/views/home/index.html.erb`

2. ユーザーコントローラーの追加

 `$ rails g controller users index show --no-controller-specs --skip-stylesheets --skip-javascripts`

3. Routes.rbの設定

 `$ vi config/routes.rb`

4. ユーザーページの設定

 `$ vi app/views/users/show.html.erb`

 `$ vi app/views/users/index.html.erb`

5. リダイレクト

`$ vi app/controllers/users_controller.rb`

#### 日本語対応
1. 認証関連ページを日本語化する
 日本語ファイルをダウンロードする

 https://gist.github.com/kawamoto/4729292

 config/locales/dvise.ja.ymlとして保存する

 config/application.rbを編集する

 `config.i18n.default_locale = :ja`

2. Railsアプリを日本語化する

 `$ echo "gem 'i18n_generators'" >> Gemfile`

 `$ bundle`

 `$ rails g i18n ja`

 以下のファイルを翻訳する

`$ vi config/locales/translation_ja.yml`
 `$ vi config/locales/ja.yml`

 viewの表記方法は
 コントローラ名.human_attribute_name 'モデルの属性名'
  `<%= f.label Book.human_attribute_name 'title' %>`

以下のページを翻訳する

`$ vi app/views/layouts/application.html.erb`

`$ vi app/views/layouts/_messages.html.erb`

`$ vi app/views/layouts/_navigation.html.erb`




2. Cucumber日本語化

### 参照
[RailsApps Tutorials](http://railsapps.github.io/tutorial-rails-devise-rspec-cucumber.html)

[RoR チュートリアル「Rails Tutorial for Devise with RSpec and Cucumber」をやってみる](http://d.hatena.ne.jp/next49/20120824/p2)

[i18n_generators を使ったロケールファイルの生成](http://qiita.com/items/e33bd512550aa2219da8)
