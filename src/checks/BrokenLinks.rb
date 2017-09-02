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
class BrokenLinks < Check

    def initialize arguments
        super arguments
        @slow = true
        @tester = URLTester.new
    end

    def check page
        html = Nokogiri::HTML page

        urls = html.xpath('//a[@href]').map { |a| a.attr :href }
        urls.reject! { |u| u.start_with?('tel:') || u.start_with?('mailto:') || u.start_with?('#') }
        urls.map! { |u| Addressable::URI.join(@arguments.scope, u).normalize }

        results = []
        urls.each do |uri|
            status = @tester.status? uri
            $d.debug "testing for broken link: #{uri} -> #{status}"
            if status == 'read_timeout'
                results << {type: Check::WARNING, message: "Broken link: #{uri} (connection timeout)"}
            elsif status == 'socket_error'
                results << {type: Check::WARNING, message: "Broken link: #{uri} (connection error)"}
            elsif status == 'unknown'
                results << {type: Check::WARNING, message: "Broken link: #{uri} (unknown error)"}
            elsif status.to_i >= 400
                results << {type: Check::WARNING, message: "Broken link: #{uri} (HTTP #{status})"}
            end
        end
        results
    end
end
