require 'pastel'
require './checks/Check.rb'

class Formatter

    def format rows
        rows.map do |row|
            [row[0], formatResults(row[1])]
        end
    end

    private

    def formatResults results
        return Pastel.new.green('No problems found') if results.count == 0

        results.map do |result|
            if result[:type] == Check::WARNING
                Pastel.new.yellow(result[:message])
            elsif result[:type] == Check::ERROR
                Pastel.new.red(result[:message])
            elsif result[:type] == Check::SUCCESS
                Pastel.new.green(result[:message])
            end
        end.join("\n")
    end
end

