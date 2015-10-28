class Avatar < ActiveRecord::Base
  # Image sizes
  IMG_SIZE = "240x300>"
  THUMB_SIZE = "50x64>"

  require 'fileutils'
  # Image directories

  URL_STUB = "avatars"
  DIRECTORY = File.join("images", "avatars")

  def self.columns
    @columns ||= [];
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
                                                            sql_type.to_s, null)
  end

  def initialize(user, image = nil)
    @user = user
    @image = image
    FileUtils::mkdir_p DIRECTORY unless File.directory?(DIRECTORY)
  end

  def exists?
    File.exists? (File.join(DIRECTORY, filename))
  end

  alias exists? exists?

  def url
    "#{URL_STUB}/#{filename}"
  end

  def thumbnail_url
    "#{URL_STUB}/#{thumbnail_name}"
  end

  def save
    successful_conversion?
  end

  # Remove the avatar from the filesystem.
  def delete
    [filename, thumbnail_name].each do |name|
      image = "#{DIRECTORY}/#{name}"
      File.delete(image) if File.exists?(image)
    end
  end

  private

  # Return the filename of the main avatar
  def filename
    "#{@user.screen_name}.jpg"
  end

  # Return the filename of the avatar thumbnail
  def thumbnail_name
    "#{@user.screen_name}_thumbnail.jpg"
  end

  #TODO : Clean this up if running on windows
  def convert
    #if ENV["OS"] = /Windows/'
      # Set this to point to the right Windows directory for ImageMagick.

    #  "C:\\Program Files\\ImageMagick-6.3.1-Q16\\convert"
    #else
      #"/usr/bin/
      "convert"
    #end
  end

  # Try to resize image file and convert to PNG.
  # We use ImageMagick's convert command to ensure sensible image sizes.
  def successful_conversion?
    # Prepare the filenames for the conversion.
    source = File.join("tmp", "#{@user.screen_name}_full_size")
    source = File.expand_path(source)
    full_size = File.join(DIRECTORY, filename)
    full_size = File.expand_path(full_size)
    thumbnail = File.join(DIRECTORY, thumbnail_name)
    # Ensure that small and large images both work by writing to a normal file.
    # (Small files show up as StringIO, larger ones as Tempfiles.)
    File.open(source, "wb") { |f| f.write(@image.read) }
    # Convert the files.
    conv = "#{convert} '#{source}' -resize '#{IMG_SIZE}' '#{full_size}'"
    img = system("#{convert} '#{source}' -resize '#{IMG_SIZE}' '#{full_size}'")
    thumb = system("#{convert} '#{source}' -resize '#{THUMB_SIZE}' '#{thumbnail}'")
    File.delete(source) if File.exists?(source)
    # Both conversions must succeed unless it's an error
    unless img and thumb
      errors[:base] << "File upload failed. Try a different image?"
      return false
    end
    return true
  end

end