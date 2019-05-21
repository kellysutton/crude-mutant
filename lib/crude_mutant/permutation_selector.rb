# frozen_string_literal: true

module CrudeMutant
  class PermutationSelector
    def self.select(number_of_permutations:, number_of_sections:, section_number:)
      if section_number < 0
        raise ArgumentError, 'section_number must be 0 or greater'
      end

      if section_number >= number_of_sections
        raise ArgumentError, 'section_number must be less than number_of_sections - 1'
      end

      if number_of_sections <= 0
        raise ArgumentError, 'number_of_sections must be greater than 0'
      end

      if number_of_sections > number_of_permutations
        raise ArgumentError, 'number_of_sections must less than number_of_permutations'
      end

      [section_number]
    end
  end
end
