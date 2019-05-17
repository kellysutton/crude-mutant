RSpec.describe CrudeMutant do
  describe 'integration tests' do
    subject { described_class.start("README.md", "which ls", &block) }
    let(:block) { Proc.new {} }
    let(:file_path) { "README.md" }

    it 'does not modify the file under test' do
      expect {
        subject
      }.not_to change{ File.read("README.md") }
    end

    context 'the program is quit early' do
      it 'does not modify the file under test' do

        expect(described_class::Executor).to receive(:call).and_raise(StandardError)
        expect {
          expect {
            subject
          }.to raise_error(StandardError)
        }.not_to change{ File.read("README.md") }
      end
    end
  end

  it "has a version number" do
    expect(CrudeMutant::VERSION).not_to be nil
  end

  describe '.start' do
    subject { described_class.start(file_path, test_command) }

    let(:file_path) { double }
    let(:test_command) { double }
    let(:file_loader) { instance_double(described_class::FileLoader, file_path: file_path) }
    let(:lines_in_file) { 3 }
    let(:file_contents) { ["hi", "hello", "howdy"] }

    context 'stubbed execution' do
      before do
        allow(described_class::FileLoader).to receive(:load).
          with(file_path).and_return(file_loader)

        allow(file_loader).to receive(:lines_in_file).and_return(lines_in_file)
        allow(file_loader).to receive(:contents_as_array).and_return(file_contents)
        allow(file_loader).to receive(:without_line).with(0).and_return(["hello", "howdy"])
        allow(file_loader).to receive(:without_line).with(1).and_return(["hi", "howdy"])
        allow(file_loader).to receive(:without_line).with(2).and_return(["hi", "hello"])
        allow(described_class::Executor).to receive(:call).and_return(true)
        allow(described_class::FileWriter).to receive(:write)
        allow(described_class::ResultPrinter).to receive(:call)
      end

      it 'does not error' do
        subject
      end

      it 'calls Executor with the test command' do
        subject
        expect(described_class::Executor).to have_received(:call).
          with(test_command).
          exactly(4).times
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
          exactly(4).times
      end

      it 'sends the results to ResultPrinter' do
        subject
        expect(described_class::ResultPrinter).to have_received(:call).
          with(an_instance_of(described_class::Result))
      end

      context 'no lines in the file' do
        let(:file_contents) { ["   \n"] }

        it 'does not execute anything' do
          subject
          expect(described_class::Executor).to have_received(:call).once
        end
      end

      context 'json printing' do
        subject { described_class.start(file_path, test_command, result_printer: :json) }

        before do
          allow(described_class::JsonResultPrinter).to receive(:call)
        end

        it do
          subject
          expect(described_class::JsonResultPrinter).to have_received(:call).
            with(an_instance_of(described_class::Result))
        end
      end

      context 'section and total_section is provided' do
        subject { described_class.start(file_path, test_command, section: section, total_sections: total_sections) }
        let(:section) { 1 }
        let(:total_sections) { 3 }

        it 'only executes the first line' do
          subject
          expect(described_class::FileWriter).to have_received(:write).
            with(file_path, ["hello", "howdy"]).
            ordered

          expect(described_class::Executor).to have_received(:call).
            with(test_command).
            exactly(2).times
        end

        context 'another section' do
          let(:section) { 2 }

          it 'only executes the second section' do
            subject
            expect(described_class::FileWriter).to have_received(:write).
              with(file_path, ["hi", "howdy"]).
              ordered

            expect(described_class::Executor).to have_received(:call).
              with(test_command).
              exactly(2).times
          end
        end
      end

      context 'a block is provided' do
        subject { described_class.start(file_path, test_command, &block) }

        let(:block) { Proc.new{} }

        before { allow(block).to receive(:call) }

        it 'calls the block with a Progress' do
          subject
          expect(block).to have_received(:call).
            with(an_instance_of(described_class::Progress)).
            exactly(3).times
        end
      end

      context 'neutral case error' do
        before { allow(described_class::Executor).to receive(:call).with(test_command).and_return(false) }

        it do
          expect {
            subject
          }.to raise_error(described_class::NeutralCaseError)
        end
      end
    end

    context 'a large example' do
      subject { described_class.start(file_path, test_command, section: section, total_sections: total_sections) }
      let(:file_contents) { ('A'..'Z').to_a }
      let(:total_sections) { 6 }
      let(:section) { 3 }

      let(:file_loader) { CrudeMutant::FileLoader.new(file_path, file_contents) }

      before do
        allow(described_class::Executor).to receive(:call).and_return(true)
        allow(described_class::FileWriter).to receive(:write)
        allow(described_class::ResultPrinter).to receive(:call)
        allow(CrudeMutant::FileLoader).to receive(:load).with(file_path).and_return(file_loader)
      end

      it 'executes the expected section (3 of 6)' do
        subject
        expect(described_class::FileWriter).to have_received(:write).
          with(file_path, file_contents - ['K']).
          ordered

        expect(described_class::FileWriter).to have_received(:write).
          with(file_path, file_contents - ['L']).
          ordered

        expect(described_class::FileWriter).to have_received(:write).
          with(file_path, file_contents - ['M']).
          ordered

        expect(described_class::FileWriter).to have_received(:write).
          with(file_path, file_contents - ['N']).
          ordered

        expect(described_class::FileWriter).to have_received(:write).
          with(file_path, file_contents - ['O']).
          ordered

        expect(described_class::FileWriter).to have_received(:write).
          with(file_path, file_contents).
          ordered

        expect(described_class::Executor).to have_received(:call).
          with(test_command).
          exactly(6).times
      end
    end
  end
end
