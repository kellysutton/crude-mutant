require "crude_mutant/version"
require "crude_mutant/executor"
require "crude_mutant/file_loader"
require "crude_mutant/file_writer"

module CrudeMutant
  class Error < StandardError; end

  def self.start(file_path, test_command)
    file = FileLoader.load(file_path)
    file.lines_in_file.times.each do |line_number|
      FileWriter.write(file_path, file.without_line(line_number))
      Executor.call(test_command)
    end
  end
end
