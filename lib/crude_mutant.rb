# frozen_string_literal: true

require "benchmark"

require "crude_mutant/executor"
require "crude_mutant/json_result_printer"
require "crude_mutant/line_permuter"
require "crude_mutant/permutation_selector"
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
    def start(file_path, test_command, section: 0, total_sections: 1, result_printer: :standard, &block)
      printer_klass = result_printer == :json ? JsonResultPrinter : ResultPrinter

      start_time = Time.now.to_f
      original_file_contents = File.read(file_path)
      permuter = LinePermuter.new(original_file_contents)

      permutations_to_run = PermutationSelector.select(
        number_of_permutations: permuter.number_of_permutations,
        number_of_sections: total_sections,
        section_number: section,
      )

      initial_success = Executor.call(test_command)

      if !initial_success
        raise NeutralCaseError, 'Initial test run did not succeed'
      end

      begin
        test_runs = permutations_to_run.reduce([]) do |acc, permutation|
          success, bench = perform_run(
            file_path: file_path,
            file_contents: permuter.take(permutation),
            command: test_command,
          )

          result = [RunResult.new(
            file_path,
            permutation,
            success,
            permuter.line(permutation),
            bench,
          )]

          if block_given?
            block.call(
              Progress.new(
                permutations_to_run.size,
                acc + result
              )
            )
          end

          acc + result
        end
      ensure
        File.write(file_path, original_file_contents)
      end

      stop_time = Time.now.to_f
      total_time = stop_time - start_time
      printer_klass.call(
        Result.new(file_path, test_runs, total_time)
      )
    end

    private

    def perform_run(file_path:, file_contents:, command:)
      success = false
      bench = Benchmark.measure do
        File.write(file_path, file_contents)

        success = Executor.call(command)
      end

      [success, bench]
    end
  end
end
