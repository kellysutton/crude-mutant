# frozen_string_literal: true

require "benchmark"

require "crude_mutant/executor"
require "crude_mutant/file_loader"
require "crude_mutant/file_writer"
require "crude_mutant/progress"
require "crude_mutant/result"
require "crude_mutant/result_printer"
require "crude_mutant/run_result"
require "crude_mutant/terminal_calculator"
require "crude_mutant/version"

module CrudeMutant
  class Error < StandardError; end
  class NeutralCaseError < StandardError; end

  class << self
    def start(file_path, test_command, section: 1, total_sections: 1, &block)
      start_time = Time.now.to_f
      file = FileLoader.load(file_path)
      num_lines_in_file = file.lines_in_file
      section_size = (num_lines_in_file.to_f / total_sections).ceil
      starting_line_number = (section - 1) * section_size - 1
      stopping_line_number = starting_line_number + section_size

      initial_success = Executor.call(test_command)

      if !initial_success
        raise NeutralCaseError, 'Initial test run did not succeed'
      end

      begin
        line_number = starting_line_number
        test_runs = file.contents_as_array.reduce([]) do |acc, contents|
          line_number += 1

          if (starting_line_number..stopping_line_number).cover?(line_number) && contents.strip.size != 0
            result = [perform_run(
              file,
              test_command,
              line_number
            )]
          else
            result = [NullRunResult.new(line_number)]
          end

          if block_given?
            block.call(
              Progress.new(
                num_lines_in_file,
                acc + result
              )
            )
          end

          acc + result
        end
      ensure
        FileWriter.write(file_path, file.contents_as_array)
      end

      stop_time = Time.now.to_f
      total_time = stop_time - start_time
      ResultPrinter.print(
        Result.new(file_path, test_runs, total_time)
      )
    end

    private

    def perform_run(file_loader, test_command, line_number)
      success = false
      bench = Benchmark.measure do
        FileWriter.write(file_loader.file_path, file_loader.without_line(line_number))

        success = Executor.call(test_command)
      end

      RunResult.new(
        file_loader.file_path,
        line_number,
        success,
        file_loader.contents_as_array[line_number],
        bench
      )
    end
  end
end
