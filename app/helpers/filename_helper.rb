module FilenameHelper
  def timestamp_filename(file)
    base = File.basename(file, '.*').parameterize('_')
    date = Date.current.strftime('%Y%m%d')
    ext  = File.extname(file)
    "#{base}_#{date}#{ext}"
  end
end
