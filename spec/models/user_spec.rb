require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  subject { user }

  # 次の3つは同じことをテストしている
  it { expect(subject).to be_a(described_class) }
  it { is_expected.to be_a(described_class) }
  it { is_expected.to be_a(User) }

  # 書き方aと書き方bは同じことをテストしている
  context '_validation' do
    context 'uniquness on :email' do
      let(:new_user) { build(:user, email: user.email) }

      context '書き方a' do
        it do
          expect(new_user.valid?).to eq false
          expect(new_user.errors.messages).to be_one
          expect(new_user.errors.messages[:email]).to include('has already been taken')
        end
      end

      context '書き方b' do
        subject { new_user }
        before(:each) { new_user.valid? }
        it { expect(subject.valid?).to eq false }
        it { expect(subject.errors.messages).to be_one }
        it { expect(subject.errors.messages[:email]).to include('has already been taken') }
      end
    end
  end
end
