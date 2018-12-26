# frozen_string_literal: true

require 'tempfile'

RSpec.describe CrudeMutant::FileWriter do
  around do |example|
    Tempfile.open('testfile') do |tempfile|
      @tempfile = tempfile
      example.run
    end
  end

  let(:file_path) { @tempfile.path }

  describe '.write' do
    subject { described_class.write(file_path, contents_as_array) }

    let(:contents_as_array) { ["whassup\n", "sup\n"] }

    it 'writes the file contents to the file_path' do
      subject
      expect(File.read(file_path)).to eq("whassup\nsup\n")
    end
  end
end
