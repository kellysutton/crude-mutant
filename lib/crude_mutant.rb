require "crude_mutant/version"
require "crude_mutant/executor"
require "crude_mutant/file_loader"

module CrudeMutant
  class Error < StandardError; end

  def self.start(file_path, test_command)
    file = FileLoader.load(file_path)
    file.lines_in_file.times.each do |line_number|
      Executor.call(test_command)
    end
  end
end
