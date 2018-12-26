# frozen_string_literal: true

module CrudeMutant
  class FileLoader
    def self.load(file_path)
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

    end

    def without_line(line_number)

    end
  end
end