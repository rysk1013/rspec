require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = FactoryBot.build(:post)
  end

  describe '新規投稿' do
    context '新規投稿できるとき' do
      it 'text, imageが存在すれば投稿できる' do
        expect(@post).to be_valid
      end

      it 'testが存在すれば投稿できる' do
        @post.image = ''
        expect(@post).to be_valid
      end
    end

    context '新規投稿できないとき' do
      it 'textが空では投稿できない' do
        @post.text = ''
        @post.valid?
        expect(@post.errors.full_messages).to include("Text can't be blank")
      end

      it 'textが140文字以上では投稿できない' do
        @post.text = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        @post.valid?
        expect(@post.errors.full_messages).to include("Text is too long (maximum is 140 characters)")
      end
    end
  end
end
