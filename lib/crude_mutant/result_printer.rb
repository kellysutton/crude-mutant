# frozen_string_literal: true

module CrudeMutant
  class ResultPrinter
    class << self
      def print(result, stream = $stdout)
        clear_string = ' ' * 80
        stream.print clear_string
        stream.print "\r"

        number_of_line_digits = Math.log10(result.successful_runs_even_with_mutations.size).to_i + 1
        result.run_results.each do |run_result|
          stream.print "#{run_result.line_number.to_s.rjust(number_of_line_digits, ' ')}: "

          if run_result.success?
            stream.print "#{red(run_result.line_contents)}\n"
          else
            stream.print "#{green(run_result.line_contents)}\n"
          end
        end

        stream.print "Finished mutating #{result.file_path}. ^^^ Results above ^^^\n"
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
