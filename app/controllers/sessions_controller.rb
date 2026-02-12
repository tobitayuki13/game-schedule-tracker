class SessionsController < ApplicationController
  layout "auth", only: [:new]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to routines_path, status: :see_other
    else
      flash.now[:alert] = "メールアドレスかパスワードが間違っています"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "ログアウトしました"
  end
end
