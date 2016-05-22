require './negapoji_mimamori.rb'
require './file_maker.rb'
require './mimamo_type.rb'

INPUTS_NINCHI_PATH = './files/inputs/ninchi/'
OUTPUTS_NINCHI_PATH = './files/outputs/ninchi/'
INPUTS_DEPRESSION_PATH = './files/inputs/depression/'
OUTPUTS_DEPRESSION_PATH = './files/outputs/depression/'

DICTIONARY = './pn_ja.dic'

mimamori_type =  ARGV[0]

case mimamori_type
  when Mimamo_type::NINCHI
    input = INPUTS_NINCHI_PATH
    output = OUTPUTS_NINCHI_PATH
  when Mimamo_type::DEPRESSION
    input = INPUTS_DEPRESSION_PATH
    output = OUTPUTS_DEPRESSION_PATH
  else
    p 'error:not supported with the arg'
    exit 0
end

files = Dir::entries(input)
files.delete_if{|f| f == '.' || f == '..' || f == '.DS_Store'}

files.each do |file|
  username = file.split('_')[2].split('.')[0]

  negapoji_good = Negapoji_mimamori.new('good', input+file)
  negapoji_bad = Negapoji_mimamori.new('bad', input+file)
  negapoji_reference = Negapoji_mimamori.new('reference', input+file)

  good_sentence = negapoji_good.create_correspondence_table(mimamori_type)
  bad_sentence = negapoji_bad.create_correspondence_table(mimamori_type)
  reference_sentence = negapoji_reference.create_correspondence_table(mimamori_type)

  file_maker_good = File_maker.new(good_sentence, username, 'good', output)
  file_maker_bad = File_maker.new(bad_sentence, username, 'bad', output)
  file_maker_reference = File_maker.new(reference_sentence, username, 'reference', output)

  file_maker_good.csv
  file_maker_bad.csv
  file_maker_reference.csv

end
