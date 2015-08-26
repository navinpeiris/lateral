RSpec.describe Lateral::User do
  describe '::initialize' do
    subject { Lateral::User.new(response_body_from('user.success')) }

    its(:id) { is_expected.to eql 1 }
    its(:created_at) { is_expected.to eql DateTime.parse('2015-03-03T13:49:51.640Z') }
    its(:updated_at) { is_expected.to eql DateTime.parse('2015-03-03T13:49:52.640Z') }
  end

  describe '::all' do
    subject(:all) { Lateral::User.all }

    context 'when successful' do
      before { load_mock_request 'users.success' }

      it { is_expected.to be_a Array }
      its(:first) { is_expected.to be_a Lateral::User }
    end

    context 'when error' do
      before { load_mock_request 'users.error.invalid-credentials' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::get' do
    subject { Lateral::User.get 1 }

    context 'when successful' do
      before { load_mock_request 'user.success' }

      it { is_expected.to be_a Lateral::User }
    end

    context 'when error' do
      before { load_mock_request 'user.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::create' do
    subject { Lateral::User.create }

    context 'when successful' do
      before { load_mock_request 'user-create.success' }

      it { is_expected.to be_a Lateral::User }
    end

    context 'when error' do
      before { load_mock_request 'user-create.error.invalid-credentials' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::delete' do
    subject { Lateral::User.delete 1 }

    context 'when successful' do
      before { load_mock_request 'user-delete.success' }

      it { is_expected.to be_a Lateral::User }
    end

    context 'when error' do
      before { load_mock_request 'user-delete.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::recommendations' do
    subject { Lateral::User.recommendations 1 }

    context 'when successful' do
      before { load_mock_request 'user-recommendations.success' }

      it { is_expected.to be_an Array }
      its(:first) { is_expected.to be_a Lateral::Similar }
    end

    context 'when error' do
      before { load_mock_request 'user-recommendations.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::preferences' do
    subject { Lateral::User.preferences 1 }

    context 'when successful' do
      before { load_mock_request 'user-preferences.success' }

      it { is_expected.to be_a Array }
      its(:first) { is_expected.to be_a Lateral::Preference }
    end

    context 'when error' do
      before { load_mock_request 'user-preferences.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::preference' do
    subject { Lateral::User.preference 1, 2 }

    context 'when successful' do
      before { load_mock_request 'user-preference.success' }

      it { is_expected.to be_a Lateral::Preference }
    end

    context 'when error' do
      before { load_mock_request 'user-preference.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::create_preference' do
    subject { Lateral::User.create_preference 1, 2 }

    context 'when successful' do
      before { load_mock_request 'user-preference-create.success' }

      it { is_expected.to be_a Lateral::Preference }
    end

    context 'when error' do
      before { load_mock_request 'user-preference-create.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::delete_preference' do
    subject { Lateral::User.delete_preference 1, 2 }

    context 'when successful' do
      before { load_mock_request 'user-preference-delete.success' }

      it { is_expected.to be_a Lateral::Preference }
    end

    context 'when error' do
      before { load_mock_request 'user-preference-delete.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end
end
