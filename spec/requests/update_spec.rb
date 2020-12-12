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
  let(:content_type) { 'application/json' }
  let(:mime_type) { 'text/html' }
  let(:headers) { { accept: mime_type } }
  let(:params) { {} }

  before(:each) do
    patch user_path(user), { user: params }, headers; 
  end

  subject { response }

  context 'エラーケース' do
    let(:params) { super().merge(email: other_user.email, first_name: other_user.first_name) }
    context 'ユーザのemailを別ユーザのものに更新しようとした場合' do
      it { is_expected.to have_http_status(:success) } # error, but status is ok
      it { is_expected.to render_template(:edit) }
      it { expect(subject.content_type).to eq mime_type }
      it 'いずれの属性も更新されていないこと' do
        expect(reloaded_user.email).not_to eq other_user.email
        expect(reloaded_user.first_name).not_to eq other_user.first_name
      end
    end
  end

  # --- 成功ケース

  shared_examples :update_success do
    context 'emailを更新する場合' do
      let(:email) { 'new@example.com' }
      let(:params) { super().merge(email: email) }
      it_behaves_like :success
      it { expect(reloaded_user.email).to eq email }
    end

    context 'first_nameを更新する場合' do
      let(:first_name) { 'JIRO' }
      let(:params) { super().merge(first_name: first_name) }
      it_behaves_like :success
      it { expect(reloaded_user.first_name).to eq first_name }
    end

    context 'memberを更新する場合' do
      let(:member) { !user.member }
      let(:params) { super().merge(member: member) }
      it_behaves_like :success
      it { expect(reloaded_user.member).to eq member }
    end
  end

  context 'responseがhtmlの場合' do
    shared_examples :success do
      it { is_expected.to have_http_status(:found) }
      it { expect(subject.content_type).to eq mime_type }
    end

    it_behaves_like :update_success
  end

  context 'responseがjsonの場合' do
    shared_examples :success do
      it { is_expected.to have_http_status(:ok) } # jsonの場合は200
      it { expect(subject.content_type).to eq mime_type }
    end

    let(:mime_type) { 'application/json' }
    it_behaves_like :update_success
  end
end
