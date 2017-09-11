require_relative 'Check.rb'

# Check that the page does not contain certain words like "exception" or "warning"
# that often indicate server-side errors.
class PrintsErrors < Check

    def check page
        contents = page.downcase
        results = []

        if contents.include? 'warning'
            $d.debug "found 'warning' on page"
            results << {type: Check::WARNING, message: "Page contains 'warning'"}
        end

        if contents.include? 'error'
            $d.debug "found 'error' on page"
            results << {type: Check::WARNING, message: "Page contains 'error'"}
        end

        if contents.include? 'exception'
            $d.debug "found 'exception' on page"
            results << {type: Check::ERROR, message: "Page contains 'exception'"}
        end

        results
    end
end
