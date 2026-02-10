require "rails_helper"

RSpec.describe "Auth", type: :request do
  let(:signup_path) { "/signup" }
  let(:login_path)  { "/login" }
  let(:logout_path) { "/logout" }

  describe "Sign up" do
    it "正常に登録できる（user: {...}）" do
      expect {
        post signup_path, params: {
          user: {
            username: "taro",
            email: "taro@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(User, :count).by(1), -> { "status=#{response.status}, body_snippet=#{response.body&.slice(0, 300)}" }

      expect(response).to have_http_status(:redirect).or have_http_status(:success)
    end

    it "不正な値だと登録できない" do
      expect {
        post signup_path, params: {
          user: {
            username: "",
            email: "",
            password: "password",
            password_confirmation: "mismatch"
          }
        }
      }.not_to change(User, :count)

      expect(response).not_to have_http_status(:redirect)
    end
  end

  describe "Login / Logout" do
    let!(:user) do
      User.create!(
        username: "taro",
        email: "taro@example.com",
        password: "password",
        password_confirmation: "password"
      )
    end

    it "正しい情報でログインできる" do
      post login_path, params: { email: user.email, password: "password" }

      expect(response).to have_http_status(:redirect).or have_http_status(:success)
      expect(session[:user_id]).to eq(user.id)
    end
  end
end
