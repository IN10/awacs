require_relative 'Check.rb'

class PrintsErrors < Check

    def check page
        results = []

        if page.include? 'warning'
            results << {type: Check::WARNING, message: "Page contains 'warning'"}
        end

        ['error', 'Exception'].each do |oracle|
            if page.include? oracle
                results << {type: Check::ERROR, message: "Page contains an error keyword"}
            end
        end

        results
    end
end
