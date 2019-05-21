# frozen_string_literal: true

module CrudeMutant
  class LinePermuter
    def initialize(file_contents)
      @file_contents = file_contents
    end

    def number_of_permutations
      @number_of_permutations ||= @file_contents.split("\n").size
    end

    def take(permutation_number)
      if permutation_number < 0
        raise ArgumentError, 'permutation_number must be 0 or more'
      end

      if permutation_number > number_of_permutations - 1
        raise ArgumentError, 'permutation_number must be less than number_of_permutations - 1'
      end

      (contents_as_array.slice(0, permutation_number) +
        contents_as_array.slice(permutation_number + 1, number_of_permutations)).join("\n")
    end

    private

    def contents_as_array
      @contents_as_array ||= @file_contents.split("\n")
    end
  end
end
