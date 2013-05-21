# -*- coding: utf-8 -*-
### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
    :password => "changeme", :password_confirmation => "changeme" }
end

def adduser
  @adduser ||= { :name => "Add User", :email => "example2@example.com",
    :password => "changeme2", :password_confirmation => "changeme2" }  
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

def create_adduser
  adduser
  delete_adduser
  @user = FactoryGirl.create(:user, @adduser)  
end

def delete_user
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def delete_adduser
  @user ||= User.where(:email => @adduser[:email]).first
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

def user_add
  visit '/users/new'
  fill_in "user_name", :with => @adduser[:name]
  fill_in "user_email", :with => @adduser[:email]
  fill_in "user_password", :with => @adduser[:password]
  fill_in "user_password_confirmation", :with => @adduser[:password_confirmation] 
  click_button "登録する"
  find_user  
end

def user_edit
  visit '/users/index'
  click_link "編集"
  fill_in "user_name", :with => "newname"
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password]
  click_button "更新する"
end

### GIVEN ###
前提(/^ログインしていない$/) do
  visit '/users/sign_out'
end

前提(/^ログインしている$/) do
  create_user
  sign_in
end

前提(/^存在するユーザ$/) do
  create_user
end

前提(/^存在しないユーザ$/) do
  create_visitor
  delete_user
end

前提(/^追加ユーザが存在する状態でログインしている$/) do

  create_visitor
  @user = FactoryGirl.create(:user, @visitor)
  adduser
  @user = FactoryGirl.create(:user, @adduser)  

  sign_in  
end

### WHEN ###
もし(/^有効な資格でログインした$/) do
  create_visitor
  sign_in
end

もし(/^ログアウトする$/) do
  visit '/users/sign_out'
end

もし(/^正しいユーザ情報を追加登録した$/) do
  adduser
  user_add
end

もし(/^間違ったメールアドレスで登録した$/) do
  adduser  
  @adduser = @adduser.merge(:email => "notanemail")
  user_add
end

もし(/^パスワード未入力で登録した$/) do
  adduser
  @adduser = @adduser.merge(:password => "")
  user_add
end

もし(/^パスワード\(再入力\)未入力で登録した$/) do
  adduser    
  @adduser = @adduser.merge(:password_confirmation => "")
  user_add
end

もし(/^パスワードとパスワード\(再入力\)の内容が違う$/) do
  adduser
  @adduser = @adduser.merge(:password_confirmation => "changeme123")
  user_add
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
  user_edit
end

もし(/^登録情報を削除した$/) do
  visit '/users/index'
  click_link "削除"
end

もし(/^他のユーザの登録情報を編集した$/) do
  visit '/users/2/edit'
  fill_in "user_name", :with => "newname"
  fill_in "user_password", :with => @adduser[:password]
  fill_in "user_password_confirmation", :with => @adduser[:password]
  click_button "更新する"
end

もし(/^ユーザ一覧を表示する$/) do
  visit '/'
end

### THEN ###
ならば(/^ログインできる$/) do
  page.should have_content "ログアウト"
  page.should_not have_content "ログイン"
end

かつ(/^ログインできない$/) do
  page.should have_content "ログイン"
  page.should_not have_content "ログアウト"
end

ならば(/^ログインメッセージが表示される$/) do
  page.should have_content "ログインしました。"
end

ならば(/^登録完了メッセージが表示される$/) do
  page.should have_content "ユーザ Add User を作成しました。"
end

ならば(/^メールアドレス間違いのエラーメッセージが表示される$/) do
  page.should have_content "メールアドレスは不正な値です。"
end

ならば(/^パスワード未入力のエラーメッセージが表示される$/) do
  page.should have_content "パスワードを入力してください。"
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
  page.should have_content "ユーザ newname を更新しました。"
end

ならば(/^自分の名前を確認できる$/) do
  create_user
  page.should have_content @user[:name]
end

ならば(/^ログアウトして再ログインを要求するメッセージ表示される$/) do
  page.should have_content "ログインしてください。"
end

