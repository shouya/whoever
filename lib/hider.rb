

class Hider
  attr_reader :table

  class << self
    def random_screen_name(length)
      chars = 'abcdefghijklmnopqrstuvwxyz1234567890'
      password = ''
      length.times { password << chars[rand(chars.length)] }
      password
    end
  end

  def initialize
    @table = {}
  end

  def query_real_value(table, fake_value)
    @table[table] = {:r2f => {}, :f2r => {}} unless @table.key? table
    if table == :screen_name
      puts "QUERYING FROM DB: #{@table[:screen_name].inspect}"
    end
    if @table[table][:f2r].key? fake_value
      return @table[table][:f2r][fake_value]
    else
      return fake_value # First query, just ignore it.
    end
  end
  def query_fake_value(table, real_value)
    @table[table] = { :r2f => {}, :f2r => {} } unless @table.key? table
    if @table[table][:r2f].key? real_value
      return @table[table][:r2f][real_value]
    end

    fake_value = nil

    case table
    when :screen_name
      begin
        fake_value = self.class.random_screen_name(real_value.length)
      end while @table[:screen_name][:f2r].keys.include? fake_value
    when :nick_name
      fake_value = $config['nick_names'].sample
    when :client
      fake_value = $config['clients'].sample
    when :biography
      fake_value = $config['biographies'].sample
    end

    @table[table][:f2r][fake_value] = real_value
    @table[table][:r2f][real_value] = fake_value

    if table == :screen_name
      puts "STORED -> DB: #{@table[:screen_name].inspect}"
    end

    return fake_value
  end
end
