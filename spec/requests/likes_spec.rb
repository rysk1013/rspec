require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  before do
    @post = FactoryBot.create(:post)
    @user = FactoryBot.create(:user)
    @like = FactoryBot.build(:like, post_id: @post.id, user_id: @user.id)
    @liked = FactoryBot.create(:like, post_id: @post.id, user_id: @user.id)
  end

  describe 'POST #create' do
    it 'createアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      post post_likes_path(@post.id)
      expect(response.status).to eq 302
    end
  end

  describe 'POST #destroy' do
    it 'destroyアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      delete post_like_path(@post.id, @liked.id)
      expect(response.status).to eq 302
    end
  end
end
