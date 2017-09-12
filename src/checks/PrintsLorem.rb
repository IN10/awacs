require_relative 'Check.rb'

# Check that the page does not contain dummy content like "lorem ipsum"
class PrintsLorem < Check

    def check page
        contents = page.downcase :ascii
        if contents.include?('lorem') || contents.include?('ipsum')
            $d.debug "found 'lorem' or 'ipsum' on page"
            return [{type: Check::ERROR, message: "Page contains dummy content"}]
        else
            return []
        end
    end
end
