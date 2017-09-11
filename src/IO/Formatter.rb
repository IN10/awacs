require 'pastel'
require 'tty-table'
require_relative '../checks/Check.rb'

# Format results into a pretty table
class Formatter

    def initialize results, showErrors, showWarnings
        @results = results
        @showErrors = showErrors
        @showWarnings = showWarnings
    end

    def render
        data = tableData

        if data.count > 0
            table = TTY::Table.new ['Path', 'Results'], data
            return "Results\n" + table.render(:ascii, multiline: true)
        else
            if @showErrors && @showWarnings
                return "No pages contained errors and/or warnings"
            elsif @showErrors
                return "No pages contained errors"
            elsif @showWarnings
                return "No pages contained warnings"
            else
                return "No pages in website"
            end
        end
    end

    private

    def tableData
        data = []
        @results.all.each do |url, results|
            entries = results.flatten(1)
            next if shouldSkip?(entries)
            data << [url, formatResults(entries)]
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

    # Determine whether we should skip printing this result, based on flags passed
    def shouldSkip? entries
        return false if @showErrors && @showWarnings && !entries.empty?
        return true if @showErrors && entries.reject{ |r| r[:type] != Check::ERROR }.empty?
        return true if @showWarnings && entries.reject{ |r| r[:type] != Check::WARNING }.empty?
        false
    end
end

