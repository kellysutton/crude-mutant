# frozen_string_literal: true

RSpec.describe CrudeMutant::Progress do
  describe '#avg_time' do
    subject { described_class.new(total_runs_to_perform, run_results).avg_time }
    let(:total_runs_to_perform) { double }
    let(:run_results) do
      [
        instance_double(CrudeMutant::RunResult, time_taken: 2.0),
        instance_double(CrudeMutant::RunResult, time_taken: 3.0)
      ]
    end

    it { is_expected.to eq(2.5) }

    context 'there are no results' do
      let(:run_results) { [] }

      it { is_expected.to eq(0) }
    end
  end
end
