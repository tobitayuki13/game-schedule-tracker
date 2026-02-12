require "rails_helper"

RSpec.describe "Auth", type: :request do
  describe "Sign up" do
    it "正常に登録できてオートログインされる" do
      expect {
        post "/signup", params: {
          user: {
            email: "taro@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(User, :count).by(1)

      expect(response).to be_redirect
      expect(session[:user_id]).to eq(User.last.id)
    end

    it "不正な値だと登録できない" do
      expect {
        post "/signup", params: {
          user: {
            email: "",
            password: "password",
            password_confirmation: "mismatch"
          }
        }
      }.not_to change(User, :count)

      expect(response).not_to be_redirect
      expect(session[:user_id]).to be_nil
    end
  end

  describe "Login / Logout" do
    let!(:user) do
      User.create!(
        email: "taro@example.com",
        password: "password",
        password_confirmation: "password"
      )
    end

    it "正しい情報でログインできる" do
      post "/login", params: { email: user.email, password: "password" }

      expect(response).to be_redirect
      expect(session[:user_id]).to eq(user.id)
    end

    it "ログアウトできる" do
      post "/login", params: { email: user.email, password: "password" }
      expect(session[:user_id]).to eq(user.id)

      delete "/logout"

      expect(response).to be_redirect
      expect(session[:user_id]).to be_nil
    end
  end
end
