# frozen_string_literal: true

module CrudeMutant
  class ResultPrinter
    class << self
      def print(result)
        clear_string = ' ' * 80
        $stdout.print clear_string
        $stdout.print "\r"
        $stdout.print "Finished.\n"
        $stdout.print "There are #{result.successful_runs_even_with_mutations.size} problematic lines:\n"

        result.successful_runs_even_with_mutations.each do |run_result|
          $stdout.print "#{run_result.line_number}:  #{red(run_result.line_contents)}\n"
        end
        $stdout.flush
      end

      private

      def red(str)
        colorize(str, 31)
      end

      def green(str)
        colorize(str, 32)
      end

      def colorize(str, color_code)
        "\e[#{color_code}m#{str}\e[0m"
      end
    end
  end
end
