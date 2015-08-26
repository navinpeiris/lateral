RSpec.describe Lateral::API do
  let(:api) { Lateral::API.new(Lateral::Document) }

  describe '#get' do
    subject { api.get '/documents/1' }

    context 'when the request is successful' do
      before { load_mock_request 'document.success' }

      it { is_expected.to be_a Lateral::Document }
    end

    context 'when the request is not successful' do
      before { load_mock_request 'document.error.not-found' }

      it 'raises an exception' do
        expect { subject }.to raise_error Lateral::Error, "Couldn't find Document"
      end
    end
  end

  describe '#get_paginated' do
    context 'with default pagination values' do
      subject { api.get_paginated '/documents' }

      context 'when the request is successful' do
        before { load_mock_request 'documents.success' }

        it { is_expected.to be_a_kind_of Lateral::PaginatedArray }
        its(:first) { is_expected.to be_a Lateral::Document }

        its(:next?) { is_expected.to be true }
        its(:current_page) { is_expected.to eql 1 }
        its(:per_page) { is_expected.to eql 25 }
        its(:total) { is_expected.to eql 100_000 }
        its(:total_pages) { is_expected.to eql 4_000 }
      end

      context 'when the request is not successful' do
        before { load_mock_request 'documents.error.invalid-credentials' }

        it 'raises an exception' do
          expect { subject }.to raise_error Lateral::Error, 'Invalid authentication credentials'
        end
      end
    end

    context 'with specified pagination values' do
      before { load_mock_request 'documents.success.page10-per50' }

      subject { api.get_paginated '/documents', page: 10, per_page: 50 }

      it { is_expected.to be_a_kind_of Lateral::PaginatedArray }
      its(:first) { is_expected.to be_a Lateral::Document }

      its(:current_page) { is_expected.to eql 10 }
      its(:per_page) { is_expected.to eql 50 }
    end
  end

  describe '#post' do
    subject { api.post '/documents', data: { text: 'Fat black cat', meta: "{ \"title\": \"Lorem Ipsum\" }" } }

    context 'when the request is successful' do
      before { load_mock_request 'document-create.success' }

      it { is_expected.to be_a Lateral::Document }
    end

    context 'when the request is not successful' do
      before { load_mock_request 'document-create.error.less-than-4-words' }

      it 'raises an exception' do
        expect { subject }.to raise_error Lateral::Error, 'less than 4 words recognized'
      end
    end
  end
end
