require 'nokogiri'
require 'open-uri'
require 'addressable'
require_relative 'Check.rb'
require_relative 'URLTester.rb'

# Check that all <script> with a src-attribute
# return a valid response code.
class BrokenStylesheets < Check

    def initialize arguments
        super arguments
        @tester = URLTester.new arguments.username, arguments.password
    end

    def check page
        html = Nokogiri::HTML page
        results = []

        urls = html.xpath('//link[@rel="stylesheet"]').map { |l| l.attr :href }

        urls.reject{|u| !u.nil? }.each do |url|
            $d.debug "testing for broken stylesheet: got <link> without href attribute"
            results << {type: Check::ERROR, message: "Broken stylesheet: tag has no href attribute"}
        end
        urls.reject! {|u| u.nil?}
        urls.map! { |u| Addressable::URI.join(@arguments.scope, u).normalize }

        urls.each do |uri|
            status = @tester.status? uri
            $d.debug "testing for broken stylesheet: #{uri} -> #{status}"

            if ['read_timeout', 'socket_error'].include? status
                results << {type: Check::ERROR, message: "Broken stylesheet: #{uri} (connection error)"}
            elsif status == 'unknown'
                results << {type: Check::ERROR, message: "Broken stylesheet: #{uri} (unknown error)"}
            elsif status.to_i >= 400
                results << {type: Check::ERROR, message: "Broken stylesheet: #{uri} (HTTP #{status})"}
            end
        end
        results
    end
end
