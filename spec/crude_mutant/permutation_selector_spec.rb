# frozen_string_literal: true

RSpec.describe CrudeMutant::PermutationSelector do
  describe '#select' do
    subject do
      described_class.select(
        number_of_permutations: number_of_permutations,
        number_of_sections: number_of_sections,
        section_number: section_number,
      )
    end

    let(:number_of_permutations) { 10 }
    let(:number_of_sections) { 10 }
    let(:section_number) { 0 }

    it { is_expected.to eq([0]) }

    context 'section_number is -1' do
      let(:section_number) { -1 }

      it do
        expect {
          subject
        }.to raise_error(ArgumentError, 'section_number must be 0 or greater')
      end
    end

    context 'section_number is 1' do
      let(:section_number) { 1 }

      it { is_expected.to eq([1]) }
    end

    context 'section_number is 9' do
      let(:section_number) { 9 }

      it { is_expected.to eq([9]) }
    end

    context 'section_number is 10' do
      let(:section_number) { 10 }

      it do
        expect {
          subject
        }.to raise_error(ArgumentError, 'section_number must be less than number_of_sections - 1')
      end
    end

    context 'number_of_sections is 1' do
      let(:number_of_sections) { 1 }
    end

    context 'number_of_sections is 0' do
      let(:number_of_sections) { 0 }

      it do
        expect {
          subject
        }.to raise_error(ArgumentError)
      end
    end

    context 'number_of_sections is more than number_of_permutations' do
      let(:number_of_sections) { number_of_permutations + 1 }

      it do
        expect {
          subject
        }.to raise_error(ArgumentError, 'number_of_sections must less than number_of_permutations')
      end
    end
  end
end