require 'nokogiri'
require 'open-uri'
require 'addressable'
require_relative 'Check.rb'
require_relative 'URLTester.rb'

# Check that all <script> with a src-attribute
# return a valid response code.
class BrokenScripts < Check

    def initialize arguments
        super arguments
        @tester = URLTester.new
    end

    def check page
        html = Nokogiri::HTML page
        results = []

        urls = html.xpath('//script[@src]').map { |l| l.attr :src }
        urls.map! { |u| Addressable::URI.join(@arguments.scope, u).normalize }

        urls.each do |uri|
            status = @tester.status? uri
            $d.debug "testing for broken script: #{uri} -> #{status}"

            if ['read_timeout', 'socket_error'].include? status
                results << {type: Check::ERROR, message: "Broken script: #{uri} (connection error)"}
            elsif status == 'unknown'
                results << {type: Check::ERROR, message: "Broken script: #{uri} (unknown error)"}
            elsif status.to_i >= 400
                results << {type: Check::ERROR, message: "Broken script: #{uri} (HTTP #{status})"}
            end
        end
        results
    end
end
