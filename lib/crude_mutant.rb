require_relative "crude_mutant/version"
require_relative "crude_mutant/executor"
require_relative "crude_mutant/file_loader"
require_relative "crude_mutant/file_writer"

module CrudeMutant
  class Error < StandardError; end

  def self.start(file_path, test_command)
    file = FileLoader.load(file_path)

    success_map = file.lines_in_file.times.map do |line_number|
      FileWriter.write(file_path, file.without_line(line_number))
      [line_number, Executor.call(test_command)]
    end.to_h
  end
end
