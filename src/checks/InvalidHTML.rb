# Check the HTML for parsing errors
class InvalidHTML < Check

    def check page
        errors = Nokogiri::HTML(page).errors.count
        return [{type: Check::WARNING, message: "#{errors} HTML errors"}] if errors > 0
    end
end
