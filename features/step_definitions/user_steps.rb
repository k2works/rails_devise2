# -*- coding: utf-8 -*-
### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
    :password => "changeme", :password_confirmation => "changeme" }
end

def find_user
  @user ||= User.where(:email => @visitor[:email]).first
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/users/sign_out'
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, @visitor)
end

def delete_user
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def sign_up
  delete_user
  visit '/users/sign_up'
  fill_in "user_name", :with => @visitor[:name]
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "登録"
  find_user
end

def sign_in
  visit '/users/sign_in'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  click_button "ログイン"
end

def user_edit
  visit '/users/new'

  delete_user

  fill_in "user_name", :with => @visitor[:name]
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]

  click_button "登録する"
  find_user
end

### GIVEN ###
前提(/^ログインしていない$/) do
  visit '/users/sign_out'
end

前提(/^ログインしている$/) do
  create_user
  sign_in
end

前提(/^存在するユーザー$/) do
  create_user
end

前提(/^存在しないユーザー$/) do
  create_visitor
  delete_user
end

### WHEN ###
もし(/^有効な資格でログインした$/) do
  create_visitor
  sign_in
end

もし(/^ログアウトする$/) do
  visit '/users/sign_out'
end

もし(/^正しいユーザー情報で登録した$/) do
  create_visitor
  user_edit
end

もし(/^間違ったメールアドレスで登録した$/) do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  user_edit  
end

もし(/^パスワード\(再入力\)未入力で登録した$/) do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  user_edit  
end

もし(/^パスワード未入力で登録した$/) do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  user_edit    
end

もし(/^パスワードとパスワード\(再入力\)の内容が違う$/) do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "changeme123")
  user_edit      
end

もし(/^トップページに戻った$/) do
  visit '/'
end

もし(/^間違ったメールアドレスでログイン$/) do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

もし(/^間違ったパスワードでログイン$/) do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

もし(/^登録情報を編集した$/) do
  click_link "登録情報編集"
  fill_in "user_name", :with => "newname"
  fill_in "user_current_password", :with => @visitor[:password]
  click_button "更新"
end

もし(/^ユーザー一覧を表示する$/) do
  visit '/'
end

### THEN ###
ならば(/^ログインできる$/) do
  page.should have_content "ログアウト"
  page.should have_content "登録情報編集"  
  page.should_not have_content "ログイン"
end

かつ(/^ログインできない$/) do
  page.should have_content "ログイン"
  page.should have_content "登録"
  page.should_not have_content "ログアウト"
end

ならば(/^ログインメッセージが表示される$/) do
  page.should have_content "ログインしました。"
end

ならば(/^登録完了メッセージが表示される$/) do
  page.should have_content "ようこそ！ アカウント登録を受け付けました。"
end

ならば(/^メールアドレス間違いのエラーメッセージが表示される$/) do
  page.should have_content "メールアドレスは不正な値です。"
end

ならば(/^パスワード未入力のエラーメッセージが表示される$/) do
  page.should have_content "パスワードを入力してください。パスワードと確認の入力が一致しません。"
end

ならば(/^パスワード\(再入力\)未入力のエラーメッセージが表示される$/) do
  page.should have_content "パスワードと確認の入力が一致しません。"
end

ならば(/^パスワード不一致のエラーメッセージが表示される$/) do
  page.should have_content "パスワードと確認の入力が一致しません。"
end

ならば(/^ログアウトメッセージが表示される$/) do
  page.should have_content "ログアウトしました。"
end

ならば(/^エラーメッセージが表示される$/) do
  page.should have_content "メールアドレスかパスワードが違います。"
end

ならば(/^登録情報編集完了メッセージが表示される$/) do
  page.should have_content "アカウント情報を変更しました。"
end

ならば(/^自分の名前を確認できる$/) do
  create_user
  page.should have_content @user[:name]
end
