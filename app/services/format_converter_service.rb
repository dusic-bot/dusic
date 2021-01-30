# frozen_string_literal: true

class FormatConverterService
  FORMATS = %i[m3u8 mp3 dca s16le].freeze

  class << self
    def call(io, initial_format, format, *args, **opts)
      return io if initial_format == format

      return nil if FORMATS.exclude?(initial_format) || FORMATS.exclude?(format)

      method_name = "#{initial_format}_to_#{format}".to_sym

      return nil unless respond_to?(method_name)

      send(method_name, io, *args, **opts).read
    end

    private

    def external_converter(input, command, name: 'unknown')
      # NOTE: IO.pipe can't handle data larger than 65536 bytes, use Tempfile instead
      output = Tempfile.new(mode: File::RDWR | File::BINARY)

      start_time = Time.current
      Process.wait spawn(command, in: input, out: output)
      conversion_duration = Time.current - start_time

      Rails.logger.debug "Finished converting in #{conversion_duration}s (#{name})"
      output.rewind
      output
    end
  end
end
