# frozen_string_literal: true

module CrudeMutant
  class RunResult
    attr_reader :file_path, :line_number, :success, :line_contents

    def initialize(file_path, line_number, success, line_contents, benchmark)
      @file_path = file_path
      @line_number = line_number
      @success = success
      @line_contents = line_contents
      @benchmark = benchmark
    end

    def success?
      success
    end

    def time_taken
      @benchmark.real
    end
  end

  class NullRunResult
    attr_reader :line_number

    def initialize(line_number)
      @line_number = line_number
    end

    def success?
      false
    end

    def time_taken
      0.0
    end

    def line_contents
      ''
    end
  end
end
