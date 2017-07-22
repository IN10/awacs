require 'pastel'
require_relative 'checks/Check.rb'

class Formatter

    def initialize results, errorsOnly
        @results = results
        @errorsOnly = errorsOnly
    end

    def tableData
        data = []
        @results.all.each do |url, results|
            entries = results.flatten(1)
            next if @errorsOnly && entries.count == 0
            data << [url, formatResults(entries)]
        end
        data
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

