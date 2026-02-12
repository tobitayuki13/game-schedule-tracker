require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  it "GET /terms returns http success" do
    get "/terms"
    expect(response).to have_http_status(:ok)
  end

  it "GET /privacy returns http success" do
    get "/privacy"
    expect(response).to have_http_status(:ok)
  end
end
