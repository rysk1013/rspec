require 'rails_helper'

RSpec.describe "いいね", type: :system do
  describe 'いいね作成' do
    before do
      @post = FactoryBot.create(:post)
      @user = FactoryBot.create(:user)
    end
  
    context 'いいねできるとき' do
      it 'ログインユーザーと投稿が存在すればいいねできる' do
        #サインインする
        sign_in(@user)
        #投稿が存在しているか確認
        expect(page).to have_content(@post.text)
        expect(page).to have_content('add like')
        #いいねボタンを押すと送信した値がDBに保存されていることを確認
        expect{
          find('.likes').find_link('add like', href: post_likes_path(@post.id)).click
        }.to change{Like.count}.by(1)
        #一覧ページに遷移しているか確認
        expect(current_path).to eq root_path
        #ブラウザに'remove like'が表示されていることを確認
        expect(page).to have_link('remove like')
        #ブラウザに'add like'が表示されていないことを確認
        expect(page).to have_no_link('add like')
      end
    end
  
    context 'いいねできないとき' do
      it 'ログインしていないといいねできない' do
        #投稿一覧ページへ移動
        visit root_path
        #投稿が存在しているか確認
        expect(page).to have_content(@post.text)
        #いいねボタンを押してもDBに保存されない
        find('.likes').find_link('add like', href: post_likes_path(@post.id)).click
        #ログインページに遷移しているか確認
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe 'いいね削除' do
    before do
      @post = FactoryBot.create(:post)
      @user = FactoryBot.create(:user)
      @liked = FactoryBot.create(:like, post_id: @post.id, user_id: @user.id)
    end

    context 'いいね削除できるとき' do
      it 'いいねのuser_idがcurrent_user.idと一致する投稿はいいねを削除できる' do
        #サインインする
        sign_in(@user)
        #投稿があるか確認する
        expect(page).to have_content(@post.text)
        #投稿に'remove like'が存在するか確認
        expect(page).to have_link('remove like')
        #'remove like'ボタンを押すとDBが1減ることを確認
        expect {
          find('.likes').find_link('remove like', href: post_like_path(@post.id, @liked.id)).click
        }.to change{Like.count}.by(-1)
        #投稿一覧ページに遷移したか確認
        expect(current_path).to eq root_path
        #投稿に'add like'が表示されているか確認
        expect(page).to have_link('add like')
        #ブラウザに'add like'が表示されていないことを確認
        expect(page).to have_no_link('remove like')
      end
    end
  end
end
