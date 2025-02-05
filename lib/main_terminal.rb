class MainTerminal < ApplicationTerminal
  VERSION = '0.0.1'.freeze

  desc "login", "Log in to your account"
  def login
    print "Email: "
    email = gets.chomp
    user = User.find_by_email(email)

    print "Password: "
    password = getpass

    if user&.valid_password?(password) && user.otp_required_for_login?
      print "2FA (OTP): "
      otp = gets.chomp

      verifier = Rails.application.message_verifier(:otp_session)
      token = verifier.generate(user.id)

      # look up the user again as an extra security check
      otp_user_id = verifier.verify(token)
      otp_user = User.find(otp_user_id)

      if otp_user.validate_and_consume_otp!(otp)
        self.current_user = user
        puts "Successfully logged in as #{current_user.email}."
      else
        puts "OTP incorrect, please try again."
      end
    elsif user&.valid_password?(password)
      self.current_user = user
      puts "Successfully logged in as #{current_user.email}."
    else
      puts "Email or Password incorrect, please try again."
    end
  end

  desc "whoami", "Displays current user information."
  def whoami
    if current_user
      puts "Logged in as #{current_user.email}."
    else
      puts "Not logged in. Run `#{self.class.basename} login` to login."
    end
  end

  desc "version", "Displays current CLI version."
  def version
    puts VERSION
  end

  desc "logout", "Log out of your account"
  def logout
    session.reset
    puts "Successfully logged out."
  end

  desc "plugins", "Interact with your custom plugins"
  subcommand "plugins", PluginTerminal

  desc "go", "Interact with your TRMNL account + native plugins"
  subcommand "go", GoTerminal
end
