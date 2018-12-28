# frozen_string_literal: true

module CrudeMutant
  class Result
    attr_reader :file_path, :run_results, :total_time

    def initialize(file_path, run_results, total_time)
      @file_path = file_path
      @run_results = run_results
      @total_time = total_time
    end

    def successful_runs_even_with_mutations
      @run_results.
        select{ |rr| rr.success? }.
        reject{ |rr| rr.line_contents.strip.size == 0 }
    end
  end
end
