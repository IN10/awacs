require 'pastel'
require 'tty-table'
require_relative 'checks/Check.rb'

# Format results into a pretty table
class Formatter

    def initialize results, errorsOnly
        @results = results
        @errorsOnly = errorsOnly
    end

    def render
        data = tableData

        if data.count > 0
            table = TTY::Table.new ['Path', 'Results'], data
            return "Results\n" + table.render(:ascii, multiline: true)
        else
            return "No pages contained errors and/or warnings"
        end
    end

    private

    def tableData
        data = []
        @results.all.each do |url, results|
            entries = results.flatten(1)
            next if @errorsOnly && entries.count == 0
            data << [url, formatResults(entries)]
        end
        data
    end

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

