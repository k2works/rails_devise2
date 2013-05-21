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

 DeviseのViewを編集できるようにする
 既に作成したViewは上書きしない

 `$ rails g devise:views`

 以下のページを翻訳する

 `$ vi app/views/layouts/application.html.erb`

 `$ vi app/views/layouts/_messages.html.erb`

 `$ vi app/views/layouts/_navigation.html.erb`

 `$ vi app/views/devise/sessions/new.html.erb`

 `$ vi app/views/devise/shared/_links.erb`

 `$ vi app/views/devise/registrations/edit.html.erb`

 `$ vi app/views/devise/registrations/new.html.erb`

 `$ vi app/views/devise/passwords/new.html.erb`

2. Cucumber日本語化

 `$ vi devise2/features/step_definitions/user_steps.rb`

 `$ vi features/users/sign_in.feature`

 `$ vi features/users/sign_out.feature`

 `$ vi features/users/sign_up.feature`

 `$ vi features/users/user_show.feature`

 `$ vi features/users/user_edit.feature`

3. RSpec日本語化

 `$ vi spec/models/user_spec.rb`

 `$ vi spec/controllers/users_controller_spec.rb`

 `$ vi spec/controllers/home_controller_spec.rb`

4. 辞書ファイルを整理する

モデル,ビュー,デフォルトに分割する

`$ mkdir config/locales/defaults`

`$ mkdir config/locales/models`

`$ mkdir config/locales/views`

デフォルトの作成

`$ cp config/locales/en.yml config/locales/defaults/`

`$ cp config/locales/ja.yml config/locales/defaults/`

モデルの作成

`$ mkdir config/locales/models/defaults`

`$ mkdir config/locales/models/user`

`$ cp config/locales/en.yml config/locales/models/defaults/`

`$ cp config/locales/ja.yml config/locales/models/defaults/`

`$ cp config/locales/en.yml config/locales/models/user/`

`$ cp config/locales/ja.yml config/locales/models/user/`

ビューの作成

 `$ mkdir config/locales/views/defaults`

 `$ mkdir config/locales/views/devise`

 `$ mkdir config/locales/views/devise/confirmations`

 `$ mkdir config/locales/views/devise/passwords`

 `$ mkdir config/locales/views/devise/sessions`

 `$ mkdir config/locales/views/devise/registrations`

 `$ mkdir config/locales/views/devise/mailer`

`$ mkdir config/locales/views/devise/unlocks`

 `$ mkdir config/locales/views/devise/shared`

 `$ cp config/locales/en.yml config/locales/views/defaults/`

 `$ cp config/locales/ja.yml config/locales/views/defaults/`

 `$ cp config/locales/en.yml config/locales/views/devise/confirmations/`

 `$ cp config/locales/ja.yml config/locales/views/devise/confirmations/`

 `$ cp config/locales/en.yml config/locales/views/devise/passwords/`

 `$ cp config/locales/ja.yml config/locales/views/devise/passwords/`

 `$ cp config/locales/en.yml config/locales/views/devise/sessions/`

 `$ cp config/locales/ja.yml config/locales/views/devise/sessions/`

 `$ cp config/locales/en.yml config/locales/views/devise/registrations/`

 `$ cp config/locales/ja.yml config/locales/views/devise/registrations/`

 `$ cp config/locales/en.yml config/locales/views/devise/mailer/`

 `$ cp config/locales/ja.yml config/locales/views/devise/mailer/`

 `$ cp config/locales/en.yml config/locales/views/devise/unlocks/`

 `$ cp config/locales/ja.yml config/locales/views/devise/unlocks/`

 `$ cp config/locales/en.yml config/locales/views/devise/shared/`

 `$ cp config/locales/ja.yml config/locales/views/devise/shared/`

 `$ mkdir config/locales/views/home`

 `$ cp config/locales/en.yml config/locales/views/home/`

 `$ cp config/locales/ja.yml config/locales/views/home/`

 `$ mkdir config/locales/views/users`

 `$ cp config/locales/en.yml config/locales/views/users/`

 `$ cp config/locales/ja.yml config/locales/views/users/`

ファイルの編集

 `$ rm config/locales/ja.yml`

 `$ rm config/locales/en.yml`

 `$ vi config/locales/defaults/ja.yml`

 `$ vi config/locales/models/defaults/ja.yml`

 `$ rm config/locales/models/user/ja.yml`

 `$ mv config/locales/translation`

 `$ mv config/locales/models/user/translation_ja.yml config/locales/models/user/ja.yml`

 `$ vi config/locales/views/defaults/ja.yml`

 `$ vi config/locales/views/users/ja.yml`

 `$ vi config/locales/views/home/ja.yml`

 `$ vi config/locales/views/devise/confirmations/ja.yml`

 `$ vi config/locales/views/devise/passwords/ja.yml`

 `$ vi config/locales/views/devise/sessions/ja.yml`

 `$ vi config/locales/views/devise/unlocks/ja.yml`

 `$ vi config/locales/views/devise/mailer/ja.yml`

 `$ vi config/locales/views/devise/registrations/ja.yml`

 `$ vi config/locales/views/devise/shared/ja.yml`

`$ vi config/application.rb`

config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

#### ユーザー管理機能の追加
1. ユーザー管理機能画面を追加

`$ vi app/controllers/users_controller.rb`

`$ vi app/views/users/index.html.erb`

`$ vi app/views/users/show.html.erb`

`$ vi app/views/users/_form.html.erb`

`$ vi app/views/users/new.html.erb`

`$ vi app/views/users/edit.html.erb`

`$ vi config/locales/views/users/ja.yml`

`$ vi app/views/layouts/_navigation.html.erb`

2. サインアップできないように設定する

 :registerableをコメントアウトする

`$ vi app/models/user.rb`

 以下を削除する
 
 `$ vi app/views/layouts/_navigation.html.erb`

     <% if user_signed_in? %>
       <li>
         <%= link_to t('.Edit_account'), edit_user_registration_path %>
       </li>
     <% else %>
      <li>
        <%= link_to t('.Sign_up'), new_user_registration_path %>
      </li>
      <% end %>

テストの修正

$ vi features/users/user_new.feature`

`$ vi features/users/sign_up.feature`

`$ vi features/step_definitions/user_steps.rb`


### 参照
[RailsApps Tutorials](http://railsapps.github.io/tutorial-rails-devise-rspec-cucumber.html)

[RoR チュートリアル「Rails Tutorial for Devise with RSpec and Cucumber」をやってみる](http://d.hatena.ne.jp/next49/20120824/p2)

[i18n_generators を使ったロケールファイルの生成](http://qiita.com/items/e33bd512550aa2219da8)

[RailsのI18n APIの使い方の基本と辞書ファイルの整理方針: Modelごと、Viewごとに分けて管理する](http://memo.yomukaku.net/entries/LXvSUpT)

[Rails3.2のアプリにユーザー機能を追加する～Devise](http://blog.scimpr.com/2012/11/17/rails3-2%E3%81%AE%E3%82%A2%E3%83%97%E3%83%AA%E3%81%AB%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC%E6%A9%9F%E8%83%BD%E3%82%92%E8%BF%BD%E5%8A%A0%E3%81%99%E3%82%8B%EF%BD%9Edevise/)
