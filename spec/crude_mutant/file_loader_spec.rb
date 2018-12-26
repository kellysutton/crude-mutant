# frozen_string_literal: true

require 'tempfile'

RSpec.describe CrudeMutant::FileLoader do
  around do |example|
    Tempfile.open('testfile') do |tempfile|
      @tempfile = tempfile
      example.run
    end
  end

  let(:file_path) { @tempfile.path }

  describe '.load' do
    subject { described_class.load(file_path) }

    it { is_expected.to be_a(described_class) }
  end

  describe '#lines_in_file' do
    subject { described_class.load(file_path).lines_in_file }

    it { is_expected.to eq(0) }

    context 'file has 3 lines' do
      before do
        @tempfile.write("hi\n")
        @tempfile.write("hello\n")
        @tempfile.write("howdy\n")
        @tempfile.flush
      end

      it { is_expected.to eq(3) }
    end
  end
end
