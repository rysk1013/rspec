require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できるとき' do
      it 'email,半角英数字混合のpassword, password_confirmation, last_name, first_name, last_name_kana, first_name_kana, birthday, acceptedが存在すれば登録できること' do
        expect(@user).to be_valid
      end
    end

    context '新規登録できないとき' do
      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end

      it 'emailは@が含まれないと登録できない' do
        @user.email = 'email'
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end

      it '重複したemailが存在する場合は登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Email has already been taken")
      end

      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      it 'passwordが存在してもpassword_confirmationが空では登録できない' do
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      it 'passwordとpassword_confirmationが一致しなかったら登録できない' do
        @user.password = '123abc'
        @user.password_confirmation = 'abc123'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      it 'passwordが5文字以下では登録できない' do
        @user.password = '123ab'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end

      it 'passwordが半角英語だけでは登録できない' do
        @user.password = 'abcdef'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end

      it 'passwordが数字だけでは登録できない' do
        @user.password = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end

      it 'passwordが全角では登録できない' do
        @user.password = '１２３ａｂｃ'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end

      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end

      it 'last_nameが空では登録できない' do
        @user.last_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank")
      end

      it 'last_nameが漢字・ひらがな・カタカナ以外では登録できない' do
        @user.last_name = 'abc'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name is invalid")
      end

      it 'first_nameが空では登録できない' do
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name can't be blank")
      end

      it 'first_nameが漢字・ひらがな・カタカナ以外では登録できない' do
        @user.first_name = 'abc'
        @user.valid?
        expect(@user.errors.full_messages).to include("First name is invalid")
      end

      it 'last_name_kanaが空では登録できない' do
        @user.last_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana can't be blank")
      end

      it 'last_name_kanaがカタカナ以外では登録できない' do
        @user.last_name_kana = 'あああ'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana is invalid")
      end

      it 'first_name_kanaが空では登録できない' do
        @user.first_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana can't be blank")
      end

      it 'first_name_kanaがカタカナ以外では登録できない' do
        @user.first_name_kana = 'あああ'
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana is invalid")
      end

      it 'birthdayが空では登録できない' do
        @user.birthday = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Birthday can't be blank")
      end

      it 'acceptedが空では登録できない' do
        @user.accepted = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Accepted can't be blank")
      end

      it 'acceptedがfalseでは登録できない' do
        @user.accepted = 'false'
        @user.valid?
        expect(@user.errors.full_messages).to include("Accepted must be accepted")
      end
    end
  end
end