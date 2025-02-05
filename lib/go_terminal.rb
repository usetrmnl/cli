class GoTerminal < ApplicationTerminal
  desc "list", "view all available 'go' actions"
  def list
    shell.say "shopping_list\nINSERT MORE"
  end

  desc "shopping_list ITEM", "add ITEM to your Shopping List plugin"
  def shopping_list(*item)
    return unless authenticate_user!

    item = item.join(' ')
    plugin = Plugin.find_by_keyname(__callee__)
    plugin_setting = current_user.plugin_settings.find_by_plugin_id(plugin.id)

    if plugin_setting && item.present?
      plugin_setting.service.add_item(item)
      shell.say "added to Shopping List (#{plugin_setting.name}): #{item}"
    elsif plugin_setting
      shell.say "No item added, please include as argument to `#{__callee__}`"
    else
      shell.say "Shopping List plugin connection not found in your account."
    end
  end
end
