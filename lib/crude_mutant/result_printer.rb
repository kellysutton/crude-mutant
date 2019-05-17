# frozen_string_literal: true

require "crude_mutant/terminal_calculator"

module CrudeMutant
  class ResultPrinter
    class << self
      def call(result, stream = $stdout)
        term_width = CrudeMutant::TerminalCalculator.new.calculate_length
        clear_string = ' ' * term_width
        stream.print clear_string
        stream.print "\r"

        number_of_line_digits = result.run_results.size > 0 ?
          Math.log10(result.run_results.size).to_i + 1 :
          0

        result.run_results.each do |run_result|
          line = "#{run_result.line_number.to_s.rjust(number_of_line_digits, ' ')}: "

          if run_result.success?
            line += "#{red(run_result.line_contents.slice(0, term_width - line.size))}"
          else
            line += "#{green(run_result.line_contents.slice(0, term_width - line.size))}"
          end

          line += "\n" if !line.include?("\n")
          stream.print "#{line}"
        end

        stream.print "\n"
        stream.print "Finished mutating #{result.file_path} in #{result.total_time.round(2)} seconds. ^^^ Results above ^^^\n"
        stream.print "Performed #{result.run_results.size} line mutations in total.\n"
        stream.print "There are #{red(result.successful_runs_even_with_mutations.size)} #{red('problematic lines')}:\n"

        stream.flush
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
