# frozen_string_literal: true

module CrudeMutant
  class Progress
    attr_reader :run_result, :total_runs_to_perform

    def initialize(total_runs_to_perform, run_result)
      @total_runs_to_perform = total_runs_to_perform
      @run_result = run_result
    end
  end
end
