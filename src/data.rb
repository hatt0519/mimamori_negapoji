require 'mysql2-cs-bind'

class DB

  def initialize(host, username, password, dbname)
    @connection = Mysql2::Client.new(:host => host, :username => username, :password => password, :database => dbname)
  end

  def get_users
    result = @connection.query('SELECT username FROM users WHERE `group` = 1')
    result.each do |row| end
  end

  def get_today_event(user)
    result = @connection.xquery('SELECT today_event.date, today_event.good, today_event.bad, today_event.reference, today_feeling.feeling FROM today_event INNER JOIN today_feeling ON today_event.processing_date = today_feeling.processing_date WHERE today_event.status = 0 AND today_feeling.status = 0 AND today_event.user_id = ? ORDER BY today_event.date ', user)
    result.each do |row| end
  end

  def get_current_status(user)
    result = @connection.xquery('SELECT user_id, date, feeling, comment AS current_status FROM `current_status` WHERE user_id = ? ', user)
    result.each do |row| end
  end

end
