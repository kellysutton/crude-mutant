require_relative "crude_mutant/version"
require_relative "crude_mutant/executor"
require_relative "crude_mutant/file_loader"
require_relative "crude_mutant/file_writer"

module CrudeMutant
  class Error < StandardError; end
  class RunResult
    attr_reader :file_path, :line_number, :success

    def initialize(file_path, line_number, success)
      @file_path = file_path
      @line_number = line_number
      @success = success
    end
  end

  class Progress
    def initialize(total_runs_to_perform, run_result)
      @total_runs_to_perform = total_runs_to_perform
      @run_result = run_result
    end
  end

  def self.start(file_path, test_command, &block)
    file = FileLoader.load(file_path)
    num_lines_in_file = file.lines_in_file

    success_map = {}
    begin
      success_map = file.lines_in_file.times.map do |line_number|
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

    success_map
  end
end
