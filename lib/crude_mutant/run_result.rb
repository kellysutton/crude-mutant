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
  end
end
