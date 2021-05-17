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
      #投稿ボタンを押すと送信した値がDBに保存されていることを確認
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

RSpec.describe '投稿編集', type: :system do
  before do 
    @post = FactoryBot.create(:post)
  end

  context '投稿編集できるとき' do
    it 'ログインユーザーと投稿のuser_idが一致すれば編集・更新できる' do
      #サインインする
      sign_in(@post.user)
      #編集ページヘのリンクを確認
      expect(
        find('.post-lists').find('span').hover
      ).to have_link '編集', href: edit_post_path(@post)
      #投稿編集画面へ移動
      visit edit_post_path(@post)
      #投稿内容を変更する
      edit_text = @post.text + 'aaa'
      fill_in '投稿', with: edit_text
      #投稿ボタンを押す
      find('input[name="commit"]').click
      #投稿一覧ページに遷移していることを確認
      expect(current_path).to eq root_path
      #編集した値が表示されてことを確認
      expect(page).to have_content(edit_text)
    end
  end

  context '投稿編集できないとき' do
    it 'テキストが空では更新できない' do
      #サインインする
      sign_in(@post.user)
      #編集ページヘのリンクを確認
      expect(
        find('.post-lists').find('span').hover
      ).to have_link '編集', href: edit_post_path(@post)
      #投稿編集画面へ移動
      visit edit_post_path(@post)
      #投稿内容を変更する
      edit_text = @post.text = ''
      fill_in '投稿', with: edit_text
      #投稿ボタンを押す
      find('input[name="commit"]').click
      #投稿編集ページにままであることを確認
      expect(current_path).to eq post_path(@post)
      #投稿フォームには変更前の内容が表示されている
      expect(page).to have_content(@post.text)
    end

    it 'ログインユーザーと投稿のuser_idが一致しないと▼が表示されない' do
      #投稿と別のユーザー作成
      another_user = FactoryBot.create(:user)
      #作成したユーザーでログイン
      sign_in(another_user)
      #投稿にリンクを表示するマークがないことを確認
      expect(page).to have_no_content('▼')
    end

    it 'ログインしていないと▼が表示されない' do
      #トップページに移動
      visit root_path
      #投稿にリンクが無いことを確認する
      expect(page).to have_no_content('▼')
    end
  end
end

RSpec.describe '投稿削除', type: :system do
  before do
    @post = FactoryBot.create(:post)
  end

  context '投稿削除できるとき' do
    it 'ログインユーザーと投稿のuser_idが一致すれば削除できる' do
      #サインインする
      sign_in(@post.user)
      #削除ボタンの確認
      expect(
        find('.post-lists').find('span').hover
      ).to have_link '削除', href: post_path(@post)
      #投稿を削除するリンクを押すとDBが1減ることを確認
      expect {
        find('.post-lists').find('span').hover.find_link('削除', href: post_path(@post)).click
      }.to change{Post.count}.by(-1)
      #投稿一覧ページに遷移しているか確認
      expect(current_path).to eq root_path
      #削除した投稿の内容が表示されていないか確認
      expect(page).to have_no_content("#{@post.text}")
    end
  end

  context '投稿削除できないとき' do
    it 'ログインユーザーと投稿のuser_idが一致しないと▼が表示されない' do
      #投稿と別のユーザーの作成
      another_user = FactoryBot.create(:user)
      #作成したユーザーでログイン
      sign_in(another_user)
      #投稿にリンクを表示するマークがないことを確認
      expect(page).to have_no_content('▼')
    end

    it 'ログインしていないと▼が表示されない' do
      #トップページに移動
      visit root_path
      #投稿にリンクが無いことを確認する
      expect(page).to have_no_content('▼')
    end
  end
end