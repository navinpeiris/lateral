RSpec.describe Lateral::Document do
  describe '::initialize' do
    subject { Lateral::Document.new(response_body_from('document.success')) }

    its(:id) { is_expected.to eql 1 }
    its(:text) { is_expected.to eql 'maximus feugiat tincidunt' }
    its(:meta) { is_expected.to eql title: 'Excepteur sint occaecat' }
    its(:created_at) { is_expected.to eql DateTime.parse('2015-03-03T13:49:51.640Z') }
    its(:updated_at) { is_expected.to eql DateTime.parse('2015-03-03T13:49:52.640Z') }
  end

  describe '::all' do
    subject(:all) { Lateral::Document.all }

    context 'when successful' do
      before { load_mock_request 'documents.success' }

      it { is_expected.to be_a Array }
      its(:first) { is_expected.to be_a Lateral::Document }
    end

    context 'when error' do
      before { load_mock_request 'documents.error.invalid-credentials' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::get' do
    subject { Lateral::Document.get(1) }

    context 'when successful' do
      before { load_mock_request 'document.success' }

      it { is_expected.to be_a Lateral::Document }
    end

    context 'when error' do
      before { load_mock_request 'document.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::create' do
    subject { Lateral::Document.create 'Fat black cat', title: 'Lorem Ipsum' }

    context 'when successful' do
      before { load_mock_request 'document-create.success' }

      it { is_expected.to be_a Lateral::Document }
    end

    context 'when error' do
      before { load_mock_request 'document-create.error.less-than-4-words' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::update' do
    subject { Lateral::Document.update 1, 'Fat black cat', title: 'Lorem Ipsum' }

    context 'when successful' do
      before { load_mock_request 'document-update.success' }

      it { is_expected.to be_a Lateral::Document }
    end

    context 'when error' do
      before { load_mock_request 'document-update.error.less-than-4-words' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::delete' do
    subject { Lateral::Document.delete 1 }

    context 'when successful' do
      before { load_mock_request 'document-delete.success' }

      it { is_expected.to be_a Lateral::Document }
    end

    context 'when error' do
      before { load_mock_request 'document-delete.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::preferences' do
    subject { Lateral::Document.preferences 1 }

    context 'when successful' do
      before { load_mock_request 'document-preferences.success' }

      it { is_expected.to be_a Lateral::PaginatedArray }
      its(:first) { is_expected.to be_a Lateral::Preference }
    end

    context 'when error' do
      before { load_mock_request 'document-preferences.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::similar' do
    subject { Lateral::Document.similar 1 }

    context 'when successful' do
      before { load_mock_request 'document-similar.success' }

      it { is_expected.to be_an Array }
      its(:first) { is_expected.to be_a Lateral::Similar }
    end

    context 'when error' do
      before { load_mock_request 'document-similar.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end

  describe '::similar_to_text' do
    subject { Lateral::Document.similar_to_text 'Fat black cat' }

    context 'when successful' do
      before { load_mock_request 'documents-similar-to-text.success' }

      it { is_expected.to be_an Array }
      its(:first) { is_expected.to be_a Lateral::Similar }
    end

    context 'when error' do
      before { load_mock_request 'documents-similar-to-text.error.not-found' }

      it 'raises an error' do
        expect { subject }.to raise_error Lateral::Error
      end
    end
  end
end
