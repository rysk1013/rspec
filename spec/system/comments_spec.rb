require 'rails_helper'

RSpec.describe "コメント", type: :system do
  describe 'コメント投稿' do
    before do
      @post = FactoryBot.create(:post)
      @user = FactoryBot.create(:user)
      @comment = FactoryBot.build(:comment, post_id: @post.id, user_id: @user.id)
    end

    context 'コメント投稿できるとき' do
      it 'ログインユーザー・投稿が存在すればコメント投稿できる' do
        #サインイン
        sign_in(@user)
        #投稿が存在するか確認
        expect(page).to have_content(@post.text)
        #showボタンをクリックする
        find('.post-show').find_link('show', href: post_path(@post)).click
        #投稿詳細ページに遷移しているか確認
        expect(current_path).to eq post_path(@post)
        #コメント投稿フォームが存在するか確認
        expect(page).to have_content('コメント')
        expect(page).to have_selector 'textarea.textarea-default'
        #コメント投稿フォームに記入する
        fill_in 'コメント', with: @comment.text
        #送信ボタンをクリックすると送信した値がDBに保存されていることを確認
        expect{
          find('input[name="commit"]').click
        }.to change{Comment.count}.by(1)
        #投稿詳細ページに遷移しているか確認
        expect(current_path).to eq post_path(@post)
        #ブラウザに投稿した内容が表示されていくことを確認
        expect(page).to have_content(@comment.text)
      end
    end

    context 'コメント投稿できないとき' do
      it 'ログインしていないとコメント投稿できない' do
        #投稿一覧ページへ移動
        visit root_path
        #投稿が存在するか確認
        expect(page).to have_content(@post.text)
        #showボタンをクリックする
        find('.post-show').find_link('show', href: post_path(@post)).click
        #投稿詳細ページに遷移しているか確認
        expect(current_path).to eq post_path(@post)
        #コメント投稿フォームが存在するか確認する
        expect(page).to have_content('コメント')
        expect(page).to have_selector 'textarea.textarea-default'
        #コメント投稿フォームに記入する
        fill_in 'コメント', with: @comment.text
        #送信ボタンをクリックする
        find('input[name="commit"]').click
        #ログインページに遷移しているか確認
        expect(current_path).to eq new_user_session_path
      end

      it 'コメントが空では投稿できない' do
        #サインイン
        sign_in(@user)
        #投稿が存在するか確認
        expect(page).to have_content(@post.text)
        #showボタンをクリックする
        find('.post-show').find_link('show', href: post_path(@post)).click
        #投稿詳細ページに遷移しているか確認
        expect(current_path).to eq post_path(@post)
        #コメント投稿フォームが存在するか確認
        expect(page).to have_content('コメント')
        expect(page).to have_selector 'textarea.textarea-default'
        #コメント投稿フォームに記入する
        fill_in 'コメント', with: ''
        #送信ボタンをクリックしてもDBの値が変わらないことを確認
        expect{
          find('input[name="commit"]').click
        }.to change{Comment.count}.by(0)
        #投稿詳細ページに遷移しているか確認
        expect(current_path).to eq post_path(@post)
      end
    end
  end

  describe 'コメント削除' do
    before do
      @post = FactoryBot.create(:post)
      @comment = FactoryBot.create(:comment, post_id: @post.id, user_id: @post.user.id)
    end

    context 'コメント削除できるとき' do
      it '投稿のuser_idとログインユーザーが一致すれば削除できる' do
        #サインイン
        sign_in(@post.user)
        #投稿が存在するか確認
        expect(page).to have_content(@post.text)
        #showボタンをクリック
        find('.post-show').find_link('show', href: post_path(@post)).click
        #投稿詳細へ遷移しているか確認
        expect(current_path).to eq post_path(@post)
        #コメントが存在しているか確認
        expect(page).to have_content(@comment.text)
        #deleteボタンを押すとDBが-1減ることを確認
        expect {
          find('.delete-comment').find_link('delete', href: post_comment_path(@post.id, @comment.id)).click
        }.to change{Comment.count}.by (-1)
        #投稿詳細ページに遷移しているか確認
        expect(current_path).to eq post_path(@post)
        #コメントが存在していないか確認
        expect(page).to have_no_content(@comment.text)
      end
    end

    context 'コメント削除できないとき' do
      it '投稿のuser_idとログインユーザーが一致しないと削除できない' do
        #投稿を別のユーザーを作成
        user = FactoryBot.create(:user)
        #作成したユーザーでサインイン
        sign_in(user)
        #投稿が存在するか確認
        expect(page).to have_content(@post.text)
        #showボタンをクリック
        find('.post-show').find_link('show', href: post_path(@post)).click
        #投稿詳細ページへ遷移しているか確認
        expect(current_path).to eq post_path(@post)
        #コメント存在しているか確認
        expect(page).to have_content(@comment.text)
        #削除ボタンが存在していないことを確認
        expect(page).to have_no_link('delete')
      end
    end
  end
end