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
  end
end