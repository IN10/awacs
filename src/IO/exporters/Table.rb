require 'pastel'
require 'tty-table'
require_relative '../../checks/Check.rb'

# Format results into a pretty table
class Table

    def initialize results
        @results = results
    end

    def render
        data = tableData
        return 'No pages' if data.count == 0
        table = TTY::Table.new ['Path', 'Results'], data
        puts "Results\n" + table.render(:ascii, multiline: true)
    end

    private

    def tableData
        data = []
        @results.all.each do |url, results|
            data << [url, formatResults(results)]
        end
        data.sort! { |a,b| a[0] <=> b[0] }
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
