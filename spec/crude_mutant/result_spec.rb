# frozen_string_literal: true

RSpec.describe CrudeMutant::Result do
  subject { described_class.new(file_path, run_results) }

  let(:file_path) { double }
  let(:run_results) { [] }

  describe '#successful_runs_even_with_mutations' do
    subject { super().successful_runs_even_with_mutations }
    it { is_expected.to eq([]) }

    context 'there were mutations that passed' do
      let(:run_results) do
        [
          successful_run,
          failed_run
        ]
      end
      let(:successful_run) do
        instance_double(
          CrudeMutant::RunResult,
          success?: true,
          line_contents: 'yep'
        )
      end
      let(:failed_run) do
        instance_double(
          CrudeMutant::RunResult,
          success?: false,
          line_contents: 'yep'
        )
      end

      it { is_expected.to eq([successful_run]) }
    end

    context 'there were mutations that past but their lines were blank' do
      let(:run_results) do
        [
          blank_successful,
          nonblank_successful
        ]
      end

      let(:blank_successful) do
        instance_double(
          CrudeMutant::RunResult,
          success?: true,
          line_contents: "        \n"
        )
      end
      let(:nonblank_successful) do
        instance_double(
          CrudeMutant::RunResult,
          success?: true,
          line_contents: "def method(name)"
        )
      end

      it { is_expected.to eq([nonblank_successful]) }
    end
  end
end
