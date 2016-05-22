
require 'csv'

class File_maker

  attr_reader :data
  attr_reader :username
  attr_reader :item
  attr_reader :path
  attr_accessor :target

  def initialize(data, username, item, path)
    @data = data
    @username = username
    @item = item
    @path = path
  end

  def create_blank(extension)
    @target = @path+@username+'_'+@item+'_'+extension
    File.open(@target, 'w').close() if File.exists?(@target)
  end

  def csv
    self.create_blank(__method__.to_s)
    CSV.open(@target, 'w') do |csv|
      @data.each do |d| csv << d end
    end
  end


end
