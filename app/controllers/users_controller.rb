class UsersController < ApplicationController

  skip_after_filter :cache_response

  # GET /users
  # GET /users.xml
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

      if @user.save
        #redirect_to(@user, :notice => 'User was successfully created.') 
        redirect_to :action => "confirm", :id => @user.id
      else
        render :action => "new" 
      end
  end

  def confirm
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.js do
        render :json => @user
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

      if @user.update_attributes(params[:user])
        redirect_to(@user, :notice => 'User was successfully updated.') 
      else
        render :action => "edit" 
      end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

      redirect_to(users_url) 
  end
end
