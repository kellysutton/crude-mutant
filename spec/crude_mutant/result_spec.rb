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
      let(:successful_run) { instance_double(CrudeMutant::RunResult, success?: true) }
      let(:failed_run) { instance_double(CrudeMutant::RunResult, success?: false) }

      it { is_expected.to eq([successful_run]) }
    end
  end
end