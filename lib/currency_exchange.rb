require 'json'
require 'date'

# Abstract data source class
class DataSource
  attr_reader :data

  def initialize(file_path)
    @file_path = file_path
    @data = {}
  end

  def load_data
    raise NotImplementedError, "This #{self.class} cannot respond to:"
  end
end

# Concrete implementation for a JSON data source
class JSONDataSource < DataSource
  def load_data
    file = File.read(@file_path)
    @data = JSON.parse(file)
  end
end

# Currency exchange rate calculator
class CurrencyExchange
  attr_reader :data_source

  def initialize(data_source)
    @data_source = data_source
    @data_source.load_data
  end

  def rate(date, from_currency, to_currency, base_currency = 'EUR')
    rates_for_date = @data_source.data[date.strftime('%Y-%m-%d')]

    raise "No rate for date: #{date}" if rates_for_date.nil?
    raise "Currency not found: #{from_currency}" unless rates_for_date.key?(from_currency)
    raise "Currency not found: #{to_currency}" unless rates_for_date.key?(to_currency)

    from_rate = from_currency == base_currency ? 1 : rates_for_date[from_currency]
    to_rate = to_currency == base_currency ? 1 : rates_for_date[to_currency]

    (to_rate.to_f / from_rate.to_f).round(4)
  end
end

# Interactive rate check for the terminal
def interactive_rate_check(currency_exchange)
  puts "Welcome to the Currency Exchange rate checker."

  available_dates = currency_exchange.data_source.data.keys.sort
  available_currencies = currency_exchange.data_source.data.values.map(&:keys).flatten.uniq.sort

  puts "Available date range for exchange rates: #{available_dates.first} to #{available_dates.last}"
  puts "Available currencies: #{available_currencies.join(', ')}"

  loop do
    date = get_valid_date(available_dates)
    from_currency = get_valid_currency(available_currencies, "Enter the currency code you are exchanging from:")
    to_currency = get_valid_currency(available_currencies, "Enter the currency code you are exchanging to:")

    rate = currency_exchange.rate(date, from_currency, to_currency)
    puts "Exchange rate on #{date.strftime('%Y-%m-%d')} from #{from_currency} to #{to_currency} is: #{rate}"

    puts "Would you like to check another rate? (yes/no)"
    answer = gets.chomp.downcase
    break unless answer.start_with?('y')
  end
end

def get_valid_date(available_dates)
  loop do
    puts "Enter the date for the exchange rate (format YYYY-MM-DD):"
    date_input = gets.chomp
    begin
      date = Date.strptime(date_input, '%Y-%m-%d')
      raise unless available_dates.include?(date_input)
      return date
    rescue
      puts "Invalid date or no data for date. Please enter a valid date."
    end
  end
end

def get_valid_currency(available_currencies, message)
  loop do
    puts message
    currency = gets.chomp.upcase
    if available_currencies.include?(currency)
      return currency
    else
      puts "Currency not available. Please choose from the available currencies: #{available_currencies.join(', ')}"
    end
  end
end

# Example usage
data_source = JSONDataSource.new('data/eurofxref-hist-90d.json')
currency_exchange = CurrencyExchange.new(data_source)
interactive_rate_check(currency_exchange)