# frozen_string_literal: true

module CrudeMutant
  class RunResult
    attr_reader :file_path, :line_number, :success

    def initialize(file_path, line_number, success)
      @file_path = file_path
      @line_number = line_number
      @success = success
    end
  end
end
