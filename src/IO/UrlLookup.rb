# Results are stored in a flat folder on disk. This class uses the wget.log file
# to look up the original URL for each file to display in the results.
class UrlLookup

    def initialize log
        @log = log
    end

    def original_url_for path
        filename = File.basename(path)
        test = Regexp.new(/URL:(.*) \[.*\] -> "#{Regexp.quote(filename)}"/).match(@log)
        return test ? test[1] : nil
    end
end
