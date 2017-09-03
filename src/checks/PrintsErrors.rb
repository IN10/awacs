require_relative 'Check.rb'

# Check that the page does not contain certain words like "exception" or "warning"
# that often indicate server-side errors.
class PrintsErrors < Check

    def check page
        results = []

        if page.include? 'warning'
            $d.debug "found 'warning' on page"
            results << {type: Check::WARNING, message: "Page contains 'warning'"}
        end

        if page.include? 'error'
            $d.debug "found 'error' on page"
            results << {type: Check::WARNING, message: "Page contains 'error'"}
        end

        if page.include? 'Exception'
            $d.debug "found 'Exception' on page"
            results << {type: Check::ERROR, message: "Page contains 'Exception'"}
        end

        results
    end
end
