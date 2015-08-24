RSpec.describe Lateral do
  describe '::delete_all_data' do
    before { load_mock_request 'delete-all-data.success' }
    subject { Lateral.delete_all_data }

    it { is_expected.to be nil }
  end
end
