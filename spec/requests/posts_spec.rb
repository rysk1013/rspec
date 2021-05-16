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

  describe 'GET #new' do
    it 'newアクションにリクエストすると正常にレスポンスが返ってくる' do
      user = FactoryBot.create(:user)
      sign_in user
      get new_post_path
      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do
    it 'createアクションにリクエストすると正常にレスポンスが返ってくる' do
      user = FactoryBot.create(:user)
      sign_in user
      post posts_path, params: {post: FactoryBot.attributes_for(:post)}
      expect(response.status).to eq 302
    end
  end

  describe 'GET #edit' do
    it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
      user = FactoryBot.create(:user)
      sign_in user
      get edit_post_path(@post)
      expect(response.status).to eq 200
    end
  end

  describe 'PUT #update' do
    it 'updateアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @post.user
      patch post_path(@post), params: {post: FactoryBot.attributes_for(:post)}
      expect(response.status).to eq 302
    end

    describe 'DELETE #destroy' do
      it 'destoryアクションにリクエストすると正常にレスポンスが返ってくる' do
        sign_in @post.user
        delete post_path(@post)
        expect(response.status).to eq 302
      end
    end
  end
end
