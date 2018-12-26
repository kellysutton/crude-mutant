# frozen_string_literal: true

module CrudeMutant
  class FileLoader
    class LoadError < StandardError; end

    def self.load(file_path)
      if !File.exist?(file_path)
        raise LoadError
      end

      new(File.readlines(file_path))
    end

    def initialize(contents_as_array)
      @contents_as_array = contents_as_array
    end
    private_class_method :new

    def lines_in_file
      @contents_as_array.size
    end

    def contents_as_array
      @contents_as_array
    end

    def without_line(line_number)
      contents_as_array.slice(0, line_number) +
        contents_as_array.slice(line_number + 1, lines_in_file)
    end
  end
end