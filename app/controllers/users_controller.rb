# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: 'ユーザ#{@user.name}を作成しました。'
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'ユーザ#{@user.name}を更新しました。'
    else
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    begin
      @user.destroy
      flash[:notice] = "ユーザ#{@user.name}を削除しました。"
    rescue Exception => e
      flash[:notice] = e.message
    end
    @user.destroy

    redirect_to users_url
  end  

end
