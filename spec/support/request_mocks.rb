module RequestMocks
  def load_mock_request(fixture_name)
    fixture = load_fixture fixture_name

    request  = fixture[:request]
    response = fixture[:response]

    response_body = (response[:body].nil? ? nil : response[:body].to_json)

    stub_request(request[:method].downcase.to_sym, "https://api-v4.lateral.io#{request[:path]}")
      .with(headers: { 'Content-Type' => 'application/json', 'Subscription-Key' => 'dummy-api-key' })
      .to_return(status: response[:status], body: response_body, headers: response[:headers])
  end

  def response_body_from(fixture_name)
    load_fixture(fixture_name)[:response][:body]
  end

  def load_fixture(fixture_name)
    file_path = File.join(File.dirname(__FILE__), '..', 'fixtures', "#{fixture_name}.json")
    JSON.parse(File.read(file_path), symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include RequestMocks
end
