module Lateral
  RSpec.describe TextMatcher do
    let(:document) do
      {
        'text'        => 'lorem ipsum dolor',
        'created_at'  => '2014-11-19 23:15:44.545462',
        'meta'        => { 'date' => '2014-11-18', 'type' => 'news' },
        'document_id' => 'my_doc_id'
      }
    end
    let(:document_body) { document.to_json }

    let(:error_response_body) { { 'message' => 'lateral-error-message' }.to_json }

    let(:api_key) { 'lateral-api-key' }
    let(:matcher) { TextMatcher.new(api_key) }

    let(:request_method) { nil }
    let(:request_body) { '' }
    let(:request_endpoint) { nil }

    let(:response_code) { 500 }
    let(:response_body) { nil }

    before do
      stub_request(request_method, "https://recommender-api.lateral.io#{request_endpoint}?subscription-key=#{api_key}")
        .with(body: request_body)
        .to_return(status: response_code, body: response_body, headers: { 'Content-Type' => 'application/json' })
    end

    shared_examples_for 'returns document' do
      it 'returns the document' do
        document = subject

        expect(document).to be_a Document
        expect(document.id).to eql 'my_doc_id'
        expect(document.created_at).to eql '2014-11-19 23:15:44.545462'
        expect(document.text).to eql 'lorem ipsum dolor'
        expect(document.meta).to eql 'date' => '2014-11-18', 'type' => 'news'
      end
    end

    shared_examples_for 'returns recommendations' do
      it 'returns the recommendations' do
        result = subject

        expect(result).to be_an Array
        expect(result.length).to eql 2
        expect(result.first.document_id).to eql 'doc_id_2'
        expect(result.first.distance).to eql 0.000248
      end
    end

    shared_examples_for 'returns nil' do
      it { is_expected.to be nil }
    end

    shared_examples_for 'raises error' do
      it 'raises an error' do
        expect { subject }.to raise_error Lateral::LateralError
      end
    end

    shared_context 'successful document response' do
      let(:response_code) { 200 }
      let(:response_body) { document_body }
    end

    shared_context 'successful recommendations response' do
      let(:response_code) { 200 }
      let(:response_body) do
        [
          {
            'distance' => 0.000248, 'document_id' => 'doc_id_2' },
          { 'distance' => 0.000419, 'document_id' => 'doc_id_1' }
        ].to_json
      end
    end

    shared_context 'error response' do
      let(:response_code) { 406 }
      let(:response_body) { error_response_body }
    end

    describe 'adding a record' do
      let(:args) { { document_id: 'document-id', text: 'text' } }

      let(:request_method) { :post }
      let(:request_endpoint) { '/add/' }
      let(:request_body) { 'document_id=document-id&text=text' }

      describe 'add' do
        subject { matcher.add(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'returns nil'
        end
      end

      describe 'add!' do
        subject { matcher.add!(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'raises error'
        end
      end
    end

    describe 'deleting a record' do
      let(:args) { { document_id: 'document-id' } }

      let(:request_method) { :post }
      let(:request_endpoint) { '/delete/' }
      let(:request_body) { 'document_id=document-id' }

      describe 'delete' do
        subject { matcher.delete(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'returns nil'
        end
      end

      describe 'delete!' do
        subject { matcher.delete!(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'raises error'
        end
      end
    end

    describe 'deleting all records' do
      let(:request_method) { :post }
      let(:request_endpoint) { '/delete-all/' }
      let(:request_body) { nil }

      describe 'delete_all' do
        subject { matcher.delete_all }

        context 'when request is successful' do
          let(:response_code) { 200 }
          let(:response_body) { '' }

          include_examples 'returns nil'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'returns nil'
        end
      end

      describe 'delete_all!' do
        subject { matcher.delete_all! }

        context 'when request is successful' do
          let(:response_code) { 200 }
          let(:response_body) { '' }

          include_examples 'returns nil'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'raises error'
        end
      end
    end

    describe 'fetching a record' do
      let(:args) { { document_id: 'document-id' } }

      let(:request_method) { :get }
      let(:request_endpoint) { '/fetch/' }
      let(:request_body) { 'document_id=document-id' }

      describe 'fetch' do
        subject { matcher.fetch(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'returns nil'
        end
      end

      describe 'fetch!' do
        subject { matcher.fetch!(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'raises error'
        end
      end
    end

    describe 'listing all records' do
      let(:request_method) { :get }
      let(:request_endpoint) { '/list/' }
      let(:request_body) { nil }

      describe 'list' do
        subject { matcher.list }

        context 'when request is successful' do
          let(:response_code) { 200 }
          let(:response_body) { %w(doc-id-1 doc-id-2 doc-id-3).to_json }

          it 'returns the list of ids returned' do
            expect(subject).to eql %w(doc-id-1 doc-id-2 doc-id-3)
          end
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'returns nil'
        end
      end

      describe 'list!' do
        subject { matcher.list! }

        context 'when request is successful' do
          let(:response_code) { 200 }
          let(:response_body) { %w(doc-id-1 doc-id-2 doc-id-3).to_json }

          it 'returns the list of ids returned' do
            expect(subject).to eql %w(doc-id-1 doc-id-2 doc-id-3)
          end
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'raises error'
        end
      end
    end

    describe 'recommending by id' do
      let(:args) { { document_id: 'document-id', results: 20 } }

      let(:request_method) { :post }
      let(:request_endpoint) { '/recommend-by-id/' }
      let(:request_body) { 'document_id=document-id&results=20' }

      describe 'recommend_by_id' do
        subject { matcher.recommend_by_id(args) }

        context 'when request is successful' do
          include_context 'successful recommendations response'

          include_examples 'returns recommendations'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'returns nil'
        end
      end

      describe 'recommend_by_id!' do
        subject { matcher.recommend_by_id!(args) }

        context 'when request is successful' do
          include_context 'successful recommendations response'

          include_examples 'returns recommendations'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'raises error'
        end
      end
    end

    describe 'recommending by text' do
      let(:args) { { text: 'document-text', results: 20 } }

      let(:request_method) { :post }
      let(:request_endpoint) { '/recommend-by-text/' }
      let(:request_body) { 'text=document-text&results=20' }

      describe 'recommend_by_id' do
        subject { matcher.recommend_by_text(args) }

        context 'when request is successful' do
          include_context 'successful recommendations response'

          include_examples 'returns recommendations'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'returns nil'
        end
      end

      describe 'recommend_by_id!' do
        subject { matcher.recommend_by_text!(args) }

        context 'when request is successful' do
          include_context 'successful recommendations response'

          include_examples 'returns recommendations'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'raises error'
        end
      end
    end

    describe 'update meta' do
      let(:args) { { document_id: 'document-id', meta: 'meta-tags' } }

      let(:request_method) { :post }
      let(:request_endpoint) { '/update-meta/' }
      let(:request_body) { 'document_id=document-id&meta=meta-tags' }

      describe 'update_meta' do
        subject { matcher.update_meta(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'returns nil'
        end
      end

      describe 'update_meta!' do
        subject { matcher.update_meta!(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'raises error'
        end
      end
    end

    describe 'update text' do
      let(:args) { { document_id: 'document-id', text: 'text-tags' } }

      let(:request_method) { :post }
      let(:request_endpoint) { '/update-text/' }
      let(:request_body) { 'document_id=document-id&text=text-tags' }

      describe 'update_text' do
        subject { matcher.update_text(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'returns nil'
        end
      end

      describe 'update_text!' do
        subject { matcher.update_text!(args) }

        context 'when request is successful' do
          include_context 'successful document response'

          include_examples 'returns document'
        end

        context 'when request fails' do
          include_context 'error response'

          include_examples 'raises error'
        end
      end
    end
  end
end
