class PluginTerminal < ApplicationTerminal
  desc "list", "view all my plugins"
  map ls: 'list' # alias 'ls'
  option :all, { type: :boolean, default: false } # plugins ls --all
  option :sorted, { type: :boolean, default: false } # plugins ls --all --sorted
  def list
    return unless authenticate_user!

    if options[:all]
      puts "==NATIVE=="
      plugins = Plugin.publicly_available(current_user.id)
      plugins = plugins.most_popular if options[:sorted]
      plugins.each { |p| shell.say safe_attrs(p) }
    end

    if current_user.plugins.exists?
      puts "==MINE=="
      current_user.plugins.each { |p| shell.say safe_attrs(p) }
    end

    if current_user.plugin_settings.where(plugin_id: 37).exists?
      puts "==PRIVATE=="
      current_user.plugin_settings.where(plugin_id: 37).alphabetical.each { |ps| shell.say safe_attrs(ps) }
    end
  end

  desc "show NAME", "get more details about a plugin by name"
  def show(*name)
    return unless authenticate_user!

    name = name.join(' ').downcase
    plugin = current_user.plugins.find_by("lower(name) = ?", name) || current_user.plugin_settings.find_by("lower(name) = ?", name)

    if plugin
      shell.say "plugin attributes: #{plugin.attributes}"
    else
      shell.say "plugin with name '#{name}' not found in your account."
    end
  end

  private

  def safe_attrs(obj)
    if obj.is_a?(Plugin)
      "#{obj.name} | Connections: #{obj.plugin_settings.count}\n"
    elsif obj.is_a?(PluginSetting)
      "#{obj.name} | ID: #{obj.id}"
    end
  end
end
