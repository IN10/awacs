require 'nokogiri'
require 'open-uri'
require 'addressable'
require_relative 'Check.rb'
require_relative 'URLTester.rb'

# Check for broken links in all downloaded pages
#
# These are *NOT* the request failures in LogAnalyzer, which only reports failures
# for pages it actually downloads, i.e. that are in scope. This checks all <a>
# tags on a page regardless of where they lead.
class BrokenImages < Check

    def initialize arguments
        super arguments
        @slow = true
        @tester = URLTester.new
    end

    def check page
        html = Nokogiri::HTML page

        urls = html.xpath('//img[@src]').map { |a| a.attr :src }
        urls.map! { |u| Addressable::URI.join(@arguments.scope, u).normalize }

        results = []
        urls.each do |uri|
            status = @tester.status? uri
            $d.debug "testing for broken image: #{uri} -> #{status}"
            if status == 'read_timeout'
                results << {type: Check::WARNING, message: "Broken image: #{uri} (connection timeout)"}
            elsif status == 'socket_error'
                results << {type: Check::WARNING, message: "Broken image: #{uri} (connection error)"}
            elsif status == 'unknown'
                results << {type: Check::WARNING, message: "Broken image: #{uri} (unknown error)"}
            elsif status.to_i >= 400
                results << {type: Check::WARNING, message: "Broken image: #{uri} (HTTP #{status})"}
            end
        end
        results
    end
end
