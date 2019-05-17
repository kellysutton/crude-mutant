# frozen_string_literal: true

require "json"

module CrudeMutant
  class JsonResultPrinter
    class << self
      def call(result, stream = $stdout)
        stream.print(
          JSON.dump({
            result.file_path => {
              passed_lines: result.run_results.select(&:success?).map(&:line_number),
              failed_lines: result.run_results.select(&:reject?).map(&:line_number),
            }
          }),
        )
      end
    end
  end
end
