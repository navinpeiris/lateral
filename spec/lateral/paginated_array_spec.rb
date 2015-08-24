RSpec.describe Lateral::PaginatedArray do
  def new_instance(elements: [], current_page: 1, per_page: 2, total: 4, &block)
    page_getter = block ? block : ->() {}

    Lateral::PaginatedArray.new elements,
                                current_page: current_page,
                                per_page:     per_page,
                                total:        total,
                                &page_getter
  end

  describe '#total_pages' do
    context 'when the total is exactly divisible by the number of elements per page' do
      subject { new_instance per_page: 2, total: 4 }

      it 'returns the correct number of pages' do
        expect(subject.total_pages).to eql 2
      end
    end

    context 'when the total is not exactly divisible by the number of elements per page' do
      subject { new_instance per_page: 2, total: 5 }

      it 'returns the correct number of pages' do
        expect(subject.total_pages).to eql 3
      end
    end
  end

  describe '#next?' do
    subject { new_instance(current_page: current_page, per_page: 2, total: 4).next? }

    context 'when the current page is less than the total pages' do
      let(:current_page) { 1 }

      it { is_expected.to be true }
    end

    context 'when the current page is equal to the total pages' do
      let(:current_page) { 2 }

      it { is_expected.to be false }
    end

    context 'when the current page is greater than the total pages' do
      let(:current_page) { 3 }

      it { is_expected.to be false }
    end
  end

  describe '#next' do
    let(:page_getter) { double :page_getter, get: nil }

    subject do
      new_instance(current_page: 3) do |page_number|
        page_getter.get(page_number)
      end
    end

    it 'calls the page getter with the next page number' do
      subject.next

      expect(page_getter).to have_received(:get).with(4)
    end
  end

  describe '#page' do
    let(:page_getter) { double :page_getter, get: nil }

    subject do
      new_instance(current_page: 3) do |page_number|
        page_getter.get(page_number)
      end
    end

    it 'calls the page getter with the next page number' do
      subject.page(55)

      expect(page_getter).to have_received(:get).with(55)
    end
  end
end
