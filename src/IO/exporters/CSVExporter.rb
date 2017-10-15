require 'csv'
require_relative '../../checks/Check.rb'

class CSVExporter

    def initialize results
        @results = results
    end

    def render
        output = CSV.generate do |csv|
            csv << ["URL", "Type", "Description"]
            @results.all.each do |url, results|
                results.each do |result|
                    type = result[:type] == Check::ERROR ? 'Error' : 'Warning'
                    csv << [url, type, result[:message]]
                end
            end
        end
        puts output
    end
end
