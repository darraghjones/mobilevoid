class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:mobile], params[:password])
    if user.nil?
      # Create an error message and re-render the signin form.
      flash[:error] = "Invalid email/password combination."
      redirect_to :action => :new
    else
      # Sign the user in and redirect to the user's show page.
      flash[:success] = "Welcome back"
      sign_in(user)
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end

