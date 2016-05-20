require './negapoji.rb'
require './file_maker.rb'

path = './file/source/'
files = Dir::entries(path)
files.slice!(0,2)

files.each do |file|
  username = file.split('_')[2].split('.')[0]

  negapoji_good = Negapoji.new('good', path+file)
  negapoji_bad = Negapoji.new('bad', path+file)
  negapoji_reference = Negapoji.new('reference', path+file)
=begin
  good_sentence = negapoji_good.analysis_sentence
  bad_sentence = negapoji_bad.analysis_sentence
  reference_sentence = negapoji_reference.analysis_sentence

  file_maker_good = File_maker.new(good_sentence, username, 'good', './file/ninchi/')
  file_maker_bad = File_maker.new(bad_sentence, username, 'bad', './file/ninchi/')
  file_maker_reference = File_maker.new(reference_sentence, username, 'reference', './file/ninchi/')

  file_maker_good.csv
  file_maker_bad.csv
  file_maker_reference.csv
=end
  p negapoji_good.create_word_point_list('日本人力士の優勝でかなり元気をもらった')
  break
end
