# frozen_string_literal: true

module CrudeMutant
  class FileWriter
    def self.write(file_path, contents_as_array)
      File.open(file_path, 'w') do |f|
        contents_as_array.each do |line|
          f.write(line)
        end
      end
    end
  end
end