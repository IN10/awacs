require_relative 'checks/Check.rb'

# Parse the wget log file for HTTP errors
class LogAnalyzer

    def initialize logFile, results
        @file = logFile
        @results = results
    end

    def analyze
        log = File.open(@file, "r").read
        regex = /https?:\/\/(.*):\n.* ERROR ([0-9]{3}): (.*).\n/
        log.scan(regex).each do |error|
            page = @results.addPage(error[0])
            page << {type: Check::ERROR, message: "HTTP error: #{error[1]} #{error[2]}"}
        end
    end
end
