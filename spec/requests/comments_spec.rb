require 'rails_helper'

RSpec.describe "Comments", type: :request do
  before do
    @post = FactoryBot.create(:post)
    @user = FactoryBot.create(:user)
    @comment = FactoryBot.build(:comment, post_id: @post.id, user_id: @user.id)
    @commented = FactoryBot.create(:comment, post_id:@post.id, user_id:@user.id)
    sign_in @user
  end

  describe 'POST #create' do
    it "createアクションにリクエストすると正常にレスポンスが返ってくる" do
      post post_comments_path(@post.id), params: {comment: FactoryBot.attributes_for(:comment)}
      expect(response.status).to eq 302
    end
  end

  describe 'DELETE #destroy' do
    it 'destroyアクションにリクエストすると正常にレスポンスが返ってくる' do
      delete post_comment_path(@post.id, @commented.id)
      expect(response.status).to eq 302
    end
  end
end
