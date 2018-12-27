# frozen_string_literal: true

module CrudeMutant
  class Result
    def initialize(file_path, run_results)
      @file_path = file_path
      @run_results = run_results
    end

    def successful_runs_even_with_mutations
      @run_results.select{ |rr| rr.success? }
    end

    def number_of_successful_runs_even_with_mutations
      successful_runs_even_with_mutations.size
    end
  end
end
