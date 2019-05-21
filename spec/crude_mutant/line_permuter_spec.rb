# frozen_string_literal: true

RSpec.describe CrudeMutant::LinePermuter do
  describe '#number_of_permutations' do
    subject { described_class.new(File.read('./spec/fixtures/simple_ruby.rb')).number_of_permutations }

    it { is_expected.to eq(4) }
  end

  describe '#take' do
    subject { described_class.new(File.read('./spec/fixtures/simple_ruby.rb')).take(permutation_number) }

    let(:permutation_number) { 0 }

    it { is_expected.to eq("  # This line is unnecessary\n  a + b + 1\nend") }

    context 'another permutation_number' do
      let(:permutation_number) { 1 }
      it { is_expected.to eq("def my_method(a, b)\n  a + b + 1\nend") }
    end

    context 'permutation_number is -1' do
      let(:permutation_number) { -1 }

      it do
        expect {
          subject
        }.to raise_error(ArgumentError, 'permutation_number must be 0 or more')
      end
    end

    context 'permutation_number is one less than the total number_of_permutations' do
      let(:permutation_number) { 3 }
      it { is_expected.to eq("def my_method(a, b)\n  # This line is unnecessary\n  a + b + 1") }
    end

    context 'permutation_number is the total number_of_permutations' do
      let(:permutation_number) { 4 }

      it do
        expect {
          subject
        }.to raise_error(ArgumentError, 'permutation_number must be less than number_of_permutations - 1')
      end
    end
  end
end