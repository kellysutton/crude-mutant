# frozen_string_literal: true

module CrudeMutant
  class Result
    def initialize(file_path, run_results)
      @file_path = file_path
      @run_results = run_results
    end

    def successful_runs_even_with_mutations
      @run_results.
        select{ |rr| rr.success? }.
        reject{ |rr| rr.line_contents.strip.size == 0 }
    end
  end
end
