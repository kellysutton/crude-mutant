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

      [0]
    end
  end
end
