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
  let(:headers) { { accept: mime_type } }
  let(:params) { {} }

  before(:each) { subject }
  subject { patch user_path(user), { user: params }, headers; response }

  # html, json共通の失敗ケース
  shared_examples :update_failure do
    it 'いずれの属性も更新されていないこと' do
      expect(reloaded_user.email).not_to eq other_user.email
      expect(reloaded_user.first_name).not_to eq other_user.first_name
    end
  end

  let(:mime_type) { 'text/html' }

  shared_examples :success do
    it { is_expected.to have_http_status(:found) }
    it { expect(subject.content_type).to eq mime_type }
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
      it { is_expected.to have_http_status(:success) } # error, but status is ok
      it { is_expected.to render_template(:edit) }
      it_behaves_like :update_failure
    end
  end
end
