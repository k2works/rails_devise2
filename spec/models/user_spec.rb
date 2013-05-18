# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
  end

  it "正しい値ならインスタンスを作る" do
    User.create!(@attr)
  end

  it "メールアドレスが未入力ならエラーを返す" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "正しいメールアドレスならば受け入れる" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "間違ったメールアドレスならばエラーを返す" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "重複するメールアドレスならばエラーを返す" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "大文字・小文字意外に違いのないメールアドレスならばエラーを返す" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "パスワード" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "項目が存在する" do
      @user.should respond_to(:password)
    end

    it "確認の項目が存在する" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "パスワードチェック" do

    it "入力されているかチェックする" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "確認が一致しているかチェックする" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "短すぎないかチェックする" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe "パスワード暗号化" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "項目が存在する" do
      @user.should respond_to(:encrypted_password)
    end

    it "必ず入力されている" do
      @user.encrypted_password.should_not be_blank
    end

  end

end
