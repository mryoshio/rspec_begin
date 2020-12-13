require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }
  let(:reloaded_user) { user.reload }
  let!(:other_user) {
    create(
      :user,
      email: 'taro.yamada@examplelcom',
      first_name: 'Hanako', last_name: 'Yamada',
      gender: 'female', member: true
    )
  }
  let(:mime_type) { 'application/json' }
  let(:headers) { { accept: mime_type } }
  let(:params) { {} }
  let(:parsed_response) { JSON.parse(response.body).with_indifferent_access }

  subject { patch user_path(user), { user: params }, headers; response }
  before(:each) { subject }

  shared_examples :success do
    it do
      expect(response).to have_http_status(:ok)
      expect(subject.content_type).to eq mime_type
    end
  end

  context 'emailを更新する場合' do
    let(:email) { 'new@example.com' }
    let(:params) { super().merge(email: email) }
    it { expect(reloaded_user.email).to eq email }
    it_behaves_like :success
  end

  context 'first_nameを更新する場合' do
    let(:first_name) { 'JIRO' }
    let(:params) { super().merge(first_name: first_name) }
    it { expect(reloaded_user.first_name).to eq first_name }
    it_behaves_like :success
  end

  context 'memberを更新する場合' do
    let(:member) { !user.member }
    let(:params) { super().merge(member: member) }
    it { expect(reloaded_user.member).to eq member }
    it_behaves_like :success
  end

  context 'failure' do
    let(:params) { super().merge(email: other_user.email, first_name: other_user.first_name) }
    context 'ユーザのemailを別ユーザのものに更新しようとした場合' do
      it do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response[:email][0]).to eq 'has already been taken'
      end

      it 'いずれの属性も更新されていないこと' do
        expect(reloaded_user.email).not_to eq other_user.email
        expect(reloaded_user.first_name).not_to eq other_user.first_name
      end
    end
  end
end
