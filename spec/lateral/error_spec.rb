RSpec.describe Lateral::Error do
  describe '::from_response' do
    let(:response) { double :response, code: 500, body: response_body }

    subject { Lateral::Error.from_response response }

    context 'when the response contains a json response body' do
      let(:response_body) { { message: 'something went wrong' }.to_json }

      its(:code) { is_expected.to eql 500 }
      its(:message) { is_expected.to eql 'something went wrong' }
    end

    context 'when the response does not contain a json response body' do
      let(:response_body) { 'something went wrong' }

      its(:code) { is_expected.to eql 500 }
      its(:message) { is_expected.to eql 'something went wrong' }
    end
  end
end
