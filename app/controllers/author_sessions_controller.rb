class AuthorSessionsController < ApplicationController
  def new
  end

  def create
    if login(params[:email], params[:password])
      redirect_back_or_to(articles_url, notice: 'Logged in Successfully!')
    else
      flash.now.alert = 'Login Failed!'
      render action: :new
    end
  end

  def destroy
    logout
    redirect_to(:authors, notice: 'Logged Out!')
  end
end
