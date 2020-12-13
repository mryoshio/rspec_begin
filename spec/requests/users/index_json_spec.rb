require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }
  let(:user_attrs) { user.attributes.with_indifferent_access }
  let(:headers) { { accept: mime_type } }

  before(:each) do
    get users_path, {}, headers
  end

  shared_examples :success do
    it { expect(response).to have_http_status(:ok) }
    it { expect(response.content_type).to eq mime_type }
  end

  context 'responseがhtmlの場合' do
    let(:mime_type) { 'text/html' }
    subject { response.body }

    describe 'GET /users' do
      it_behaves_like :success
      it { expect(response).to render_template(:index) }
      it 'responseの内容がテストデータuserであること' do
        user_attrs.except(:created_at, :updated_at).each do |_, v|
          expect(subject).to include(v.to_s)
        end
      end
    end
  end

  context 'responseがjsonの場合' do
    let(:mime_type) { 'application/json' }
    subject { JSON.parse(response.body) }

    describe 'GET /users' do
      it_behaves_like :success
      it { expect(subject).to be_one }
      it { expect(subject[0].keys).to include(*user.attributes.keys) }
      it 'responseの内容がテストデータuserであること' do
        user_attrs.except(:created_at, :updated_at).each do |k, v|
          expect(subject[0][k]).to eq v
        end
      end
    end
  end
end
