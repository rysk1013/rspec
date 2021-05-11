require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
    #トップページに移動
    visit root_path
    #トップページに新規登録ボタンがあることを確認
    expect(page).to have_content('新規登録')
    #新規登録ページへ移動
    visit new_user_registration_path
    #ユーザー情報を入力
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    fill_in 'Password confirmation', with: @user.password_confirmation
    fill_in 'Nickname', with: @user.nickname
    fill_in 'Last name', with: @user.last_name
    fill_in 'First name', with: @user.first_name
    fill_in 'Last name kana', with: @user.last_name_kana
    fill_in 'First name kana', with: @user.first_name_kana
    select '1990', from: 'user_birthday_1i'
    select '1', from: 'user_birthday_2i'
    select '1', from: 'user_birthday_3i'
    check 'Accepted'
    #サインアップボタンを多過とユーザーモデルのカウントが1つ上がることを確認
    expect {
      find('input[name="commit"]').click
    }.to change{User.count}.by(1)
    #トップページへ遷移したことを確認
    expect(current_path).to eq(root_path)
    #ログインアウトボタンが表示されていることを確認
    expect(page).to have_content('ログアウト')
    #新規登録ボタン、ログインボタンが表示されていないことを確認
    expect(page).to have_no_content('新規登録')
    expect(page).to have_no_content('ログイン')
    end
  end

  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページに戻ってくる' do
      #トップページに移動する
      visit root_path
      #トップページに新規登録ボタンがあることを確認
      expect(page).to have_content('新規登録')
      #新規登録ページへ移動
      visit new_user_registration_path
      #ユーザー情報を入力
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      fill_in 'Nickname', with: ''
      fill_in 'Last name', with: ''
      fill_in 'First name', with: ''
      fill_in 'Last name kana', with: ''
      fill_in 'First name kana', with: ''
      uncheck 'Accepted'
      #サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認
      expect {
        find('input[name="commit"]').click
      }.to change{User.count}.by(0)
      #新規登録ページへ戻されることを確認
      expect(current_path).to eq user_registration_path
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインできるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      #トップページに移動
      visit root_path
      #トップページにログインボタンがあることを確認
      expect(page).to have_content('ログイン')
      #ログインページへ遷移する
      visit new_user_session_path
      #正しい情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      #ログインボタンを押す
      find('input[name="commit"]').click
      #トップページへ遷移することを確認
      expect(current_path).to eq(root_path)
      #ログアウトボタンがあることを確認
      expect(page).to have_content('ログアウト')
      #新規登録ボタン、ログインボタンが表示されていないことを確認
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ログイン出来ないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      #トップページに移動
      visit root_path
      #トップページにログインボタンがあることを確認
      expect(page).to have_content('ログイン')
      #ログインページへ遷移する
      visit new_user_session_path
      #ユーザー情報を入力
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      #ログインボタンを押す
      find('input[name="commit"]').click
      #ログインページへ戻されることを確認
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
