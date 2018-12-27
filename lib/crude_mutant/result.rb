# frozen_string_literal: true

module CrudeMutant
  class Result
    def initialize(file_path, run_results)
      @file_path = file_path
      @run_results = run_results
    end
  end
end
