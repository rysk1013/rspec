require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @post = FactoryBot.create(:post)
    @user = FactoryBot.create(:user)
    @comment = FactoryBot.build(:comment, post_id: @post.id, user_id: @user.id)
  end

  describe 'コメント機能' do
    context 'コメントできるとき' do
      it 'text, post_id, user_idが存在すればコメント投稿できる' do
        expect(@comment).to be_valid
      end
    end

    context 'コメントできないとき' do
      it 'textが空ではコメント投稿できない' do
        @comment.text = ''
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Text can't be blank")
      end

      it 'post_idが空ではコメント投稿できない' do
        @comment.post_id = ''
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Post must exist")
      end

      it 'user_idが空ではコメント投稿できない' do
        @comment.user_id = ''
        @comment.valid?
        expect(@comment.errors.full_messages).to include("User must exist")
      end
    end
  end
end
