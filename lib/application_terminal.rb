# Learn how to use Thor at http://whatisthor.com.
class ApplicationTerminal < Thor
  include Terminalwire::Thor

  def self.basename = "trmnl"

  protected

  def authenticate_user!
    return true if current_user

    shell.say "Must be logged in to do this."
    false
  end

  # saving at class level allows subcommands to access current_user
  def current_user=(user)
    session["user_id"] = user.id
  end

  def current_user
    @current_user ||= User.find_by_id(session["user_id"])
  end
end
