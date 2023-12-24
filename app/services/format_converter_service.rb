# frozen_string_literal: true

class FormatConverterService
  FORMATS = %i[mp3 m3u8url m3u8 dca].freeze

  class << self
    def call(io, initial_format, format, *, **)
      return if io.nil? || FORMATS.exclude?(initial_format) || FORMATS.exclude?(format)

      return io if initial_format == format

      method_name = :"#{initial_format}_to_#{format}"

      send(method_name, io, *, **)
    rescue NameError => e
      Rails.logger.debug { "Failed conversion #{initial_format} -> #{format}: No converter(#{e})" }
      nil
    end

    protected

    def m3u8url_to_dca(io, *, **)
      tmp = m3u8url_to_mp3(io, *, **)
      mp3_to_dca(tmp, *, **)
    end

    def m3u8url_to_mp3(io, *_args, **_opts)
      url = io.read
      null_input = File.open(File::NULL, File::RDONLY | File::BINARY)
      external_converter(
        null_input,
        "ffmpeg  -loglevel 0 -i '#{url}' -vn -map_metadata -1 -c:v copy -c:a copy -f mp3 pipe:1",
        name: 'ffmpeg: m3u8url->mp3'
      )
    end

    def mp3_to_dca(io, *_args, volume: 1.0, sample_rate: 48000, channels: 2, **_opts)
      external_converter(
        io,
        "mp3_to_dca --quiet -i pipe:0 -o pipe:1 -v #{volume} -r #{sample_rate} -c #{channels}",
        name: 'mp3_to_dca'
      )
    end

    private

    def external_converter(input, command, name: 'unknown')
      # NOTE: IO.pipe can't handle data larger than 65536 bytes, use Tempfile instead
      output = Tempfile.new(mode: File::RDWR | File::BINARY)

      start_time = Time.current
      Process.wait spawn(command, in: input, out: output)
      conversion_duration = Time.current - start_time

      Rails.logger.debug { "Finished converting in #{conversion_duration}s (#{name})" }
      output.rewind
      output
    end
  end
end
