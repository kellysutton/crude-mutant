# frozen_string_literal: true

module CrudeMutant
  class Progress
    attr_reader :run_results, :total_runs_to_perform

    def initialize(total_runs_to_perform, run_results)
      @total_runs_to_perform = total_runs_to_perform
      @run_results = run_results
    end

    def avg_time
      return 0.0 if @run_results.size == 0

      @run_results.map(&:time_taken).reduce(0, :+) / @run_results.size
    end
  end
end
