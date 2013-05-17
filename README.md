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
  sepc/spec_helper.rb

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end
    config.before(:each) do
      DatabaseCleaner.start
    end
    config.after(:each) do
      DatabaseCleaner.clean
    end

5. FactoryGirlにテストオブジェクトを追加する。
 `$ mkdir spec/support`

 `$ vi spec/support/devise.rb`

    FactoryGirl.define do
      factory :user do
        name 'Test User'
        email 'example@example.com'
        password 'changeme'
        password_confirmation 'changeme'
        # required if the Devise Confirmable module is used
        # confirmed_at Time.now
      end
      end
      
6. Devise Test Helperを追加する。

 `$ vi spec/support/devise.rb`

    RSpec.configure do |config|
      config.include Devise::TestHelpers, :type => :controller
    end

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

    gem "cucumber-rails"
    gem "capybara"
    gem "database_cleaner"    
    gem "email_spec"

 `$ bundle`

 `$rails g cucumber:install`

2. Database Cleanerの設定の確認

 features/support/env.rb

    begin
      DatabaseCleaner.strategy = :transaction
      rescue NameError
      raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
      end

3. Email Specの設定

 `$ vi features/support/email_spec.rb`

 `require 'email_spec/cucumber`

 `rails g email_spec:steps`

4. Cucumberの実行

#### 環境設定

1. 環境変数設定ファイル

 `$ rails g figaro:install`

 `$ vi config/application.yaml`

2. メールの設定

#### レイアウトとスタイルシート

1. ナビゲーションリンクの追加

 `$ vi app/views/layout/_navigation.html.erb`

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

 `$ mkdir app/views/devise/registrations/`

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

### 参照
[RailsApps Tutorials](http://railsapps.github.io/tutorial-rails-devise-rspec-cucumber.html)

[RoR チュートリアル「Rails Tutorial for Devise with RSpec and Cucumber」をやってみる](http://d.hatena.ne.jp/next49/20120824/p2)
