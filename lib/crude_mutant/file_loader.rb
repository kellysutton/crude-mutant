# frozen_string_literal: true

module CrudeMutant
  class FileLoader
    class LoadError < StandardError; end

    def self.load(file_path)
      if !file_path.is_a?(String) || !File.exist?(file_path)
        raise LoadError, "Could not load file: #{file_path}"
      end

      new(file_path, File.readlines(file_path))
    end

    attr_reader :file_path

    def initialize(file_path, contents_as_array)
      @file_path = file_path
      @contents_as_array = contents_as_array
    end

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