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

    context 'section_number is 1'
    context 'section_number is 9'
    context 'section_number is 10' do
      let(:section_number) { 10 }

      it do
        expect {
          subject
        }.to raise_error(ArgumentError, 'section_number must be less than number_of_sections - 1')
      end
    end
  end
end