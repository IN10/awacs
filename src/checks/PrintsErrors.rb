require_relative 'Check.rb'

# Check that the page does not contain certain words like "exception" or "warning"
# that often indicate server-side errors.
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
