require './negapoji_mimamori.rb'
require './file_maker.rb'
require './mimamo_type.rb'
require './negapoji.rb'
require './data.rb'

INPUTS_NINCHI_PATH = '../files/inputs/ninchi/'
OUTPUTS_NINCHI_PATH = '../files/outputs/ninchi/'
INPUTS_DEPRESSION_PATH = '../files/inputs/depression/'
OUTPUTS_DEPRESSION_PATH = '../files/outputs/depression/'
OUTPUTS_VIEW_PATH = '../files/outputs/view/'

DICTIONARY = './pn_ja.dic'

mimamori_type = ARGV[0]

case mimamori_type
  when Mimamo_type::NINCHI
    input = INPUTS_NINCHI_PATH
    output = OUTPUTS_NINCHI_PATH
  when Mimamo_type::DEPRESSION
    input = INPUTS_DEPRESSION_PATH
    output = OUTPUTS_DEPRESSION_PATH
  when Mimamo_type::VIEW
    input = INPUTS_DEPRESSION_PATH
    output = OUTPUTS_VIEW_PATH
  else
    p 'error:not supported with the arg'
    exit 0
end

db=DB.new('', '', '', '')
users = db.get_users
users.each do |user|
  data_today_event = db.get_today_event(user['username'])
  data_current_status = db.get_current_status(user['username'])
  @file_maker_today_event = File_maker.new(data_today_event, user['username'], 'today_event', '../files/inputs/depression/')
  @file_maker_current_status = File_maker.new(data_current_status, user['username'], 'current_status', '../files/inputs/depression/')
  @file_maker_today_event.json
  @file_maker_current_status.json
end


files = Dir::entries(input)
files.delete_if{|f| f == '.' || f == '..' || f == '.DS_Store'}
files.each do |username|
  negapoji_good = Negapoji_mimamori.new('good', input+username+'/today_event.json')
  negapoji_bad = Negapoji_mimamori.new('bad', input+username+'/today_event.json')
  negapoji_reference = Negapoji_mimamori.new('reference', input+username+'/today_event.json')
  negapoji_current_status = Negapoji_mimamori.new('current_status', input+username+'/current_status.json')

  good_sentence = negapoji_good.create_correspondence_table(mimamori_type)
  bad_sentence = negapoji_bad.create_correspondence_table(mimamori_type)
  reference_sentence = negapoji_reference.create_correspondence_table(mimamori_type)
  current_status_sentence = negapoji_current_status.create_correspondence_table(mimamori_type)

  file_maker_good = File_maker.new(good_sentence, username, 'good', output)
  file_maker_bad = File_maker.new(bad_sentence, username, 'bad', output)
  file_maker_reference = File_maker.new(reference_sentence, username, 'reference', output)
  file_maker_current_status = File_maker.new(current_status_sentence, username, 'current_status', output)

  file_maker_good.csv
  file_maker_bad.csv
  file_maker_reference.csv
  file_maker_current_status.csv

end
