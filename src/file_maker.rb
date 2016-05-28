
require 'csv'

class File_maker

  def initialize(data, username, item, path)
    @data = data
    @username = username
    @item = item
    @path = path
  end

  def create_user_dir
    @target_dir = @path+@username
    Dir::mkdir(@target_dir) if !File.exists?(@target_dir)
  end

  def create_blank(extension)
    self.create_user_dir
    @target_file = @target_dir+'/'+@item+'.'+extension
    File.open(@target_file, 'w').close() if !File.exists?(@target_file)
  end

  def csv
    self.create_blank(__method__.to_s)
    CSV.open(@target_file, 'w') do |csv|
      @data.each do |d| csv << d end
    end
  end


end
