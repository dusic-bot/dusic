# frozen_string_literal: true

require 'open-uri'

class RemoteFileDownloaderService
  OPEN_TIMEOUT = 10.seconds
  READ_TIMEOUT = 10.seconds

  class << self
    def call(url)
      result = URI.parse(url).open(open_timeout: OPEN_TIMEOUT, read_timeout: READ_TIMEOUT)

      return result if result.blank?

      # NOTE: Since OpenURI can return StringIO for small files, we need to convert it
      result.is_a?(Tempfile) ? result : string_io_to_tempfile(result)
    end

    def string_io_to_tempfile(string_io)
      file = Tempfile.new(mode: File::RDWR | File::BINARY)
      string_io.rewind
      file.write(string_io.read)
      file.rewind

      file
    end
  end
end
