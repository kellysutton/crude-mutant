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

  describe '#contents_as_array' do
    subject { described_class.load(file_path).contents_as_array }

    it { is_expected.to eq([]) }

    context 'file has 3 lines' do
      before do
        @tempfile.write("hi\n")
        @tempfile.write("hello\n")
        @tempfile.write("howdy\n")
        @tempfile.flush
      end

      it do
        is_expected.to eq([
          "hi\n",
          "hello\n",
          "howdy\n"
        ])
      end
    end
  end

  describe '#without_line' do
    subject { described_class.load(file_path).without_line(line_number) }

    before do
      @tempfile.write("hi\n")
      @tempfile.write("hello\n")
      @tempfile.write("howdy\n")
      @tempfile.flush
    end

    context 'line_number is 0' do
      let(:line_number) { 0 }

      it do
        is_expected.to eq([
          "hello\n",
          "howdy\n"
        ])
      end
    end

    context 'line_number is 0' do
      let(:line_number) { 1 }

      it do
        is_expected.to eq([
          "hi\n",
          "howdy\n"
        ])
      end
    end

    context 'line_number is 0' do
      let(:line_number) { 2 }

      it do
        is_expected.to eq([
          "hi\n",
          "hello\n"
        ])
      end
    end
  end
end
