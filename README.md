## CURRENCY EXCHANGE 

## Setup and Run Instructions

To set up and run the solution, follow these steps:

1. Ensure Ruby is installed on your system. The code has been tested with Ruby 2.7.0, but it should work with newer versions as well.
2. Place the `currency_exchange.rb` file and the `data` directory containing the `eurofxref-hist-90d.json` file in the same directory.
3. Run the program from the terminal with the command `ruby currency_exchange.rb`.
4. Follow the interactive prompts in the terminal to enter the date and currency codes you wish to exchange.

##  Design Decisions

1. Data Source Abstraction
The code is designed with a `DataSource` abstraction that allows for different data sources to be plugged into the system. The current implementation uses a `JSONDataSource` class that reads exchange rates from a JSON file.

2. Currency Exchange Calculation
The `CurrencyExchange` class is responsible for calculating exchange rates. It is designed to work with any data source that conforms to the interface defined by the `DataSource` abstraction.

3. Extensibility for Future Data Sources
The system is designed to be easily extended to support other data formats or sources, such as XML, CSV, or even live APIs. New data source classes can be created by inheriting from `DataSource` and implementing the `load_data` method.

4. Interactive Terminal Interface
The user interacts with the system through an interactive terminal interface, which guides them through the process of retrieving exchange rates. It is designed to be user-friendly and to handle invalid input gracefully.

5. Error Handling
The code includes robust error handling to guide users back to the correct input path if they enter data that is out of range or otherwise invalid. The goal is to provide a seamless experience that does not punish users for mistakes.
