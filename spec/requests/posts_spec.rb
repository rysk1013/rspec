require 'rails_helper'

RSpec.describe "PostsController", type: :request do
  before do
    @post = FactoryBot.create(:post)
  end

  describe "GET #index" do
    it "indexアクションにリクエストすると正常にレスポンスが帰ってくる" do
      get root_path
      binding.pry
    end

    it 'indexアクションにリクエストするとレスポンスに投稿済みのテキストが存在する' do
      
    end

    it 'indexアクションにリクエストするとレスポンスに投稿済みの画像が存在する' do
      
    end
  end
end
