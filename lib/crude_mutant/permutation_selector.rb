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

      section_size = (number_of_permutations.to_f / number_of_sections).ceil
      starting_number = section_number * section_size

      buckets = Array.new(number_of_sections, 0)

      current_bucket = 0
      i = 0

      while i < number_of_permutations do
        buckets[current_bucket] += 1
        i += 1
        current_bucket = i % number_of_sections
      end

      start = buckets.slice(0, section_number).reduce(:+) || 0
      stop = start + buckets[section_number]

      buckets[section_number].times.map do |i|
        i + start
      end
    end
  end
end
