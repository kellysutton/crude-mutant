# frozen_string_literal: true

require "crude_mutant/executor"
require "crude_mutant/file_loader"
require "crude_mutant/file_writer"
require "crude_mutant/progress"
require "crude_mutant/result"
require "crude_mutant/run_result"
require "crude_mutant/version"

module CrudeMutant
  class Error < StandardError; end

  def self.start(file_path, test_command, &block)
    file = FileLoader.load(file_path)
    num_lines_in_file = file.lines_in_file

    test_runs = []
    begin
      test_runs = file.lines_in_file.times.map do |line_number|
        FileWriter.write(file_path, file.without_line(line_number))
        success = Executor.call(test_command)
        result = Progress.new(
          num_lines_in_file,
          RunResult.new(file_path, line_number, success)
        )
        block.call(result)
        result
      end
    ensure
      FileWriter.write(file_path, file.contents_as_array)
    end

    Result.new(file_path, test_runs)
  end
end
