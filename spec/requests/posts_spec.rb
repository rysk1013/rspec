require 'rails_helper'

RSpec.describe "PostsController", type: :request do
  before do
    @post = FactoryBot.create(:post)
  end

  describe "GET #index" do
    it "indexアクションにリクエストすると正常にレスポンスが返ってくる" do
      get root_path
      expect(response.status).to eq 200
    end

    it 'indexアクションにリクエストするとレスポンスに投稿済みのテキストが存在する' do
      get root_path
      expect(response.body).to include(@post.text)
    end

    it 'indexアクションにリクエストするとレスポンスに投稿済みの画像が存在する' do
      get root_path
      expect(response.body).to include("test_image.png")
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get post_path(@post)
      expect(response.status).to eq 200
    end

    it 'showアクションにリクエストをするとレスポンスに投稿済みのテキストが存在する' do
      get root_path
      expect(response.body).to include(@post.text)
    end

    it 'showアクションにリクエストをするとレスポンスに投稿済みの画像が存在する' do
      get root_path
      expect(response.body).to include("test_image.png")
    end
  end
end
