require 'rails_helper'

RSpec.describe "新規投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post_text = Faker::Lorem.sentence
  end

  context '新規投稿できるとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      #サインインする
      sign_in(@user)
      #新規投稿画面へ移動
      visit new_post_path
      #投稿内容を入力
      image_path = Rails.root.join('public/images/test_image.png')
      attach_file('post[image]', image_path)
      fill_in '投稿', with: @post_text
      #投稿ボタンを押す送信した値がDBに保存されていることを確認
      expect{
        find('input[name="commit"]').click
      }.to change{Post.count}.by(1)
      #投稿一覧画面に遷移していることを確認
      expect(current_path).to eq root_path
      #送信した値がブラウザに表示されていることを確認
      expect(page).to have_selector("img[src$='test_image.png']")
      expect(page).to have_content(@post_text)
    end
  end

  context '新規投稿できないとき' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      #新規投稿画面へ移動
      visit new_post_path
      #ログイン画面へ遷移する
      expect(current_path).to eq new_user_session_path
    end
  end
end
