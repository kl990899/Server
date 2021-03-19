require 'rails_helper'

RSpec.describe "Resumes", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/resumes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/resumes/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/resumes/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/resumes/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
