require 'singleton'

class Dictionary

  include Singleton

  def initialize
    @pn_table = self.create_pn_table
    @pn_wago_verbs_and_adjectives = self.create_pn_wago_verbs_and_adjectives
    @pn_wago_nouns = self.create_pn_wago_nouns
  end

  def create_pn_table
    kanji, kana, hinshi, point = Array.new, Array.new, Array.new, Array.new
    File.open('../dic/pn_ja.dic', 'r:utf-8') do |f|
      while line = f.gets
        content = line.split(':')
        kanji.push(content[0])
        kana.push(content[1])
        hinshi.push(content[2])
        point.push(content[3].chomp)
      end
    end
    {kanji: kanji, kana: kana, hinshi: hinshi, point: point}
  end

  def create_pn_wago_verbs_and_adjectives
    point, word = Array.new, Array.new
    File.open('../dic/wago.121808.pn', 'r:utf-8') do |f|
      while line = f.gets
        content = line.split(',')
        point.push(content[0])
        word.push(content[2].chomp)
      end
    end
    {word: word, point: point}
  end

  def create_pn_wago_nouns
    point, word = Array.new, Array.new
    File.open('../dic/pn.csv.m3.120408.trim', 'r:utf-8') do |f|
      while line = f.gets
        content = line.split(',')
        word.push(content[0])
        point.push(content[1])
      end
    end
    @pn_wago_nouns = {word: word, point: point}
  end

  attr_reader :pn_table
  attr_reader :pn_wago_verbs_and_adjectives
  attr_reader :pn_wago_nouns

end
