require "rails_helper"

RSpec.describe Api::V1::ArticlesController, type: :controller do

  def valid_params
    return {
      title: "Gagan",
      body: "Text"
    }
  end

  def invalid_params
    return {
      title: "",
      body: "Text"
    }
  end

  context 'POST #create' do
    let!(:article) { FactoryBot.create :article }
    before { post(:create, params: { article: valid_params }) }
    it 'create a new article' do
      expect(response.status).to eq (200)
    end
  end

  context "SHOW #method" do
    let(:article) { FactoryBot.create :article }
    before { get(:show, params: { id: article.to_param }) }
    it "display one article" do
      expect(response.status).to eq (200)
    end
  end

  context "PUT #method" do
    let(:article) { FactoryBot.create :article }
    before { patch(:update, params: { article: valid_params, id: article.to_param }) }
    it "edit one article" do
      expect(response.status).to eq (200)
    end
  end

  context "Delete #method" do
    let(:article) { FactoryBot.create :article }
    it "it will delete a article" do
      expect {
        delete :destroy, params: { id: article.to_param } }.to change(Article, :count).by(0)
    end
  end

end