require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    @post = FactoryBot.create(:post)
    @user = FactoryBot.create(:user)
    @like = FactoryBot.build(:like, post_id: @post.id, user_id: @user.id)
  end

  describe 'いいね機能' do
    context 'いいねできるとき' do
      it 'post_idとuser_idが存在すればいいねできる' do
        expect(@like).to be_valid
      end
    end

    context 'いいねできないとき' do
      it 'post_idが空ではいいねできない' do
        @like.post_id = ''
        @like.valid?
        expect(@like.errors.full_messages).to include("Post must exist")
      end

      it 'user_idが空ではいいねできない' do
        @like.user_id = ''
        @like.valid?
        expect(@like.errors.full_messages).to include("User must exist")
      end
    end
  end
end
