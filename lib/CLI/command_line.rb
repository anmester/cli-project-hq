# frozen_string_literal: true

class CLI
  def welcome
    system 'clear'
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    puts ' '
    puts '――――――――――――――――――――――---―――――――――――――――――――---------'
    puts pastel.bold('Welcome to HQ! Please log in or create a username.')
    prompt = TTY::Prompt.new
    prompt.select('') do |menu|
      menu.choice 'Login', -> { login }
      menu.choice 'Create a username', -> { create_username }
      menu.choice 'Exit', -> { exit }
    end
    end

  def login
    system 'clear'
    puts ''
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    puts pastel.bold('Welcome back! Please enter your username.')
    puts ''
    name = gets.chomp
    if User.exists?(username: name)
      @user = User.find_by(username: name)
      puts ''
      system 'clear'
      main_menu
    else
      system 'clear'
      puts ''
      puts pastel.bold("We're sorry, we can't find that username.")
      puts ''
      failed_login
    end
  end

  def failed_login
    puts ''
    puts 'Please try entering it again.'
    puts ''
    answer = gets.chomp
    if answer = User.exists?(username: answer)
      puts ''
      puts 'Login success!'
      puts ''
      main_menu
    elsif
        try_again
    end
  end

  def try_again
    prompt = TTY::Prompt.new
    prompt.select('Would you like to try again or create a new username?') do |menu|
      menu.choice 'Try again', -> { failed_login }
      menu.choice 'Create username', -> { create_username }
    end
  end

  def create_username
    system 'clear'
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    puts ''
    puts pastel.bold('                    CREATE USER')
    puts '――――――――――――――――――――――――――――――――――――――――――---------'
    puts "Please type in the username you'd like to create."
    puts ''
    new_name = gets.chomp
    @user = User.create(username: new_name)
    puts ''
    puts "Welcome, #{new_name}!"
    puts ''
    main_menu
  end

  def main_menu
    system 'clear'
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    puts pastel.bold('          Main Menu')
    puts '―――――――――――――――――――――――――――-'
    prompt = TTY::Prompt.new
    prompt.select('Please select a menu option.') do |menu|
      menu.choice 'Search for companies', -> { get_location }
      menu.choice 'See your favorites', -> { see_favorites }
      menu.choice 'Exit HQ', -> { exit }
    end
  end

  def get_location
    puts ''
    system 'clear'
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    puts pastel.bold("Please enter the city you'd like to work in") + ' (example: Palo Alto).'
    puts ''
    city = gets.chomp
    puts ' '
    if Company.exists?(location: city)
      city_match = Company.where location: city
      company_names = city_match.map(&:name)
      company_names.each do |company|
        puts company
      end
      puts ''
      puts "There are #{company_names.count} companies that have offices in #{city}!"
      puts ''
      save_company
    else
      puts ''
      puts "We're sorry, there are no jobs in #{city}. Please try again."
      puts ''
      get_location
    end
  end

  def save_company
    puts ''
    puts "Please enter the name of the company you'd like to save. Otherwise, type exit to return to the menu."
    puts ''
    response = gets.chomp
    if response == 'exit'
      main_menu
    elsif Company.exists?(name: response)
      company_match = Company.where name: response
      company_matches = company_match.find(&:id)
      @user.favorites << Favorite.create(user: @user, company: company_matches)
      puts ''
      puts "Thanks! #{response} has been saved to your favorites."
      puts ''
      save_company
    else
      puts ''
      puts "We're sorry, there are no companies that match the name #{response}. Please try again."
      puts ''
      save_company
    end
  end

  def see_favorites
    system 'clear'
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    puts pastel.bold 'Your Saved Companies'
    puts '-------------------------'
    fav_companies = @user.favorites.map(&:company_id)
    company_matches = Company.where id: fav_companies
    if company_matches.count == 0
      # puts ''
      puts 'You have no favorites yet! Add some by searching for some companies.'
      puts ''
      prompt.select(' ') do |menu|
        menu.choice 'Return to Main Menu', -> { main_menu }
      end
    else
      # prompt = TTY::Prompt.new
      # pastel = Pastel.new
      # puts pastel.bold('These are your matches:')
      company_matches.map do |company|
        puts company.name
      end
      favorite_options
    end
  end

  def favorite_options
    puts ' '
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    puts pastel.bold('What would you like to do next?')
    prompt = TTY::Prompt.new
    prompt.select(' ') do |menu|
      menu.choice 'Search for more companies', -> { get_location }
      menu.choice 'Return to main menu', -> { main_menu }
    end
  end
end # end of class method
