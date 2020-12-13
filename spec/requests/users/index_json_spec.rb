require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }
  let(:user_attrs) { user.attributes.with_indifferent_access }
  let(:headers) { { accept: mime_type } }
  let(:parsed_response) { JSON.parse(response.body) }

  subject { get users_path, {}, headers }
  before(:each) { subject }

  shared_examples :success do
    it { expect(response).to have_http_status(:ok) }
    it { expect(response.content_type).to eq mime_type }
  end

  let(:mime_type) { 'application/json' }

  describe 'GET /users' do
    it_behaves_like :success
    it do
      expect(parsed_response).to be_one
      expect(parsed_response[0].keys).to include(*user.attributes.keys)
    end

    it 'responseの内容がテストデータuserであること' do
      user_attrs.except(:created_at, :updated_at).each do |k, v|
        expect(parsed_response[0][k]).to eq v
      end
    end
  end
end
