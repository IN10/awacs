require 'net/http'

# Call a URL to verify its status code
# includes caching
class URLTester

    def initialize username = nil, password = nil
        @cache = {}
        @username = username
        @password = password
    end

    # Get a cached or fresh response status
    def status? uri
        fetchStatus(uri) unless @cache.include? uri
        @cache[uri]
    end

    private

    # Fetch a URI and store the result in the cache
    def fetchStatus uri
        begin
            response = request(uri)
            @cache[uri] = response.code
        rescue OpenURI::HTTPError => error
            @cache[uri] = error.io.status[0]
        rescue Net::ReadTimeout
            @cache[uri] = 'read_timeout'
        rescue SocketError
            @cache[uri] = 'socket_error'
        rescue
            @cache[uri] = 'unknown'
        end
    end

    # GET a URI, handling redirection, HTTPS, etc.
    def request(uri)
        Net::HTTP.start(uri.host, uri.port) do |http|
            http.read_timeout = 3 # Use a low timeout for speedy testing

            # Do the request
            request  = Net::HTTP::Get.new uri
            request.basic_auth @username, @password if @username || @password
            response = http.request(request)

            # Follow a single redirect if needed
            if response.is_a? Net::HTTPRedirection
                redirect = response['location']

                request  = Net::HTTP::Get.new redirect
                request.basic_auth @username, @password if @username || @password
                response = http.request(request)
            end

            return response
        end
    end
end
