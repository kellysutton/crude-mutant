# frozen_string_literal: true

module CrudeMutant
  class Executor
    def self.call(test_command)
      `#{test_command}`
      $?.success?
    end
  end
end
