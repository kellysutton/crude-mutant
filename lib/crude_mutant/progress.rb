# frozen_string_literal: true

module CrudeMutant
  class Progress
    attr_reader :run_results, :total_runs_to_perform

    def initialize(total_runs_to_perform, run_results)
      @total_runs_to_perform = total_runs_to_perform
      @run_results = run_results
    end

    def avg_time
      @run_results.map(&:time_taken).reduce(:+) / @run_results.size
    end
  end
end
