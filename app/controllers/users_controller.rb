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
      msg = t "create", name: @user.name
      redirect_to @user, notice: msg
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      msg = t "update", name: @user.name      
      redirect_to @user, notice: msg
    else
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    begin
      @user.destroy
      msg = t "destroy", name: @user.name      
      flash[:notice] = msg
    rescue Exception => e
      flash[:notice] = e.message
    end
    @user.destroy

    redirect_to users_url
  end  

end
