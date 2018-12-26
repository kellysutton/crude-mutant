RSpec.describe CrudeMutant do
  it "has a version number" do
    expect(CrudeMutant::VERSION).not_to be nil
  end

  describe '.start' do
    subject { described_class.start(file_path, test_command) }
    let(:file_path) { double }
    let(:test_command) { double }
    let(:file_loader) { instance_double(described_class::FileLoader) }
    let(:lines_in_file) { 3 }
    let(:file_contents) { ["hi", "hello", "howdy"] }

    before do
      allow(described_class::FileLoader).to receive(:load).
        with(file_path).and_return(file_loader)

      allow(file_loader).to receive(:lines_in_file).and_return(lines_in_file)
      allow(file_loader).to receive(:contents_as_array).and_return(file_contents)
      allow(file_loader).to receive(:without_line).with(0).and_return(["hello", "howdy"])
      allow(file_loader).to receive(:without_line).with(1).and_return(["hi", "howdy"])
      allow(file_loader).to receive(:without_line).with(2).and_return(["hi", "hello"])
      allow(described_class::Executor).to receive(:call)
      allow(described_class::FileWriter).to receive(:write)

    end

    it 'does not error' do
      subject
    end

    it 'calls Executor with the test command' do
      subject
      expect(described_class::Executor).to have_received(:call).
        with(test_command).
        exactly(3).times
    end

    it 'uses FileWriter to overwrite the given file, then calls the executor' do
      subject
      expect(described_class::FileWriter).to have_received(:write).
        with(file_path, ["hello", "howdy"]).
        ordered

      expect(described_class::FileWriter).to have_received(:write).
        with(file_path, ["hi", "howdy"]).
        ordered

      expect(described_class::FileWriter).to have_received(:write).
        with(file_path, ["hi", "hello"]).
        ordered

      expect(described_class::Executor).to have_received(:call).
        with(test_command).
        exactly(3).times
    end

    context 'no lines in the file' do
      let(:lines_in_file) { 0 }

      it 'does not execute anything' do
        subject
        expect(described_class::Executor).not_to have_received(:call)
      end
    end
  end
end
