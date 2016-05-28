require 'singleton'

class Dictionary

  include Singleton

  def initialize
    File.open('../pn_ja.dic', 'r:utf-8') do |f|
      @kanji, @kana, @hinshi, @point = Array.new, Array.new, Array.new, Array.new
      while line = f.gets
        content = line.split(':')
        @kanji.push(content[0])
        @kana.push(content[1])
        @hinshi.push(content[2])
        @point.push(content[3].chomp)
      end
    end
    @dictionary = {kanji: @kanji, kana: @kana, hinshi: @hinshi, point: @point}
  end

  attr_reader :dictionary

end
