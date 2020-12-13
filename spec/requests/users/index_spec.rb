require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }
  let(:user_attrs) { user.attributes.with_indifferent_access }
  let(:headers) { { accept: mime_type } }
  let(:parsed_response) { response.body }

  subject { get users_path, {}, headers }
  before(:each) { subject }

  shared_examples :success do
    it do
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq mime_type
    end
  end

  let(:mime_type) { 'text/html' }

  describe 'GET /users' do
    it_behaves_like :success
    it { expect(response).to render_template(:index) }

    it 'responseの内容がテストデータuserであること' do
      user_attrs.except(:created_at, :updated_at).each do |_, v|
        expect(parsed_response).to include(v.to_s)
      end
    end
  end
end
