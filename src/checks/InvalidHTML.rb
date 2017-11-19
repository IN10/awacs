# Check the HTML for parsing errors
class InvalidHTML < Check

    def check page
        errors = Nokogiri::HTML5(page).errors.count
        if errors > 0
            return [{type: Check::WARNING, message: "#{errors} HTML errors"}]
        else
            return []
        end
    end
end
