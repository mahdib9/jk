do

local function callback(extra, success, result)
	local receiver = extra.receiver
	local username = extra.username
	if success == 1 then
		print("Success!")
	else
		send_large_msg(resuser, "Sorry, i can't invite @"..username)
	end
end

local function resuser(extra, success, result)
  local receiver = extra.receiver
  local username = extra.username
  if success == 1 then
    local user = "user#id"..result.id
    if string.find(receiver, 'channel#id') then
      channel_invite_user(receiver, user, callback, {receiver=receiver, username=username})
    else
      chat_add_user(receiver, user, callback, {receiver=receiver, username=username})
    end
  else
  	send_large_msg(receiver, "User not found!")
  end
end

local function get_msg_callback(extra, success, result)
  if success ~= 1 then return end
  local get_cmd = extra.get_cmd
  local receiver = extra.receiver
  local user_id = result.from.peer_id
  local chat_id = result.to.id
  if result.from.username then
    username = '@'..result.from.username
  else
    username = string.gsub(result.from.print_name, '_', ' ')
  end
  if get_cmd == 'invite' then
    if user_id == our_id then
      return nil
    end
    local user = "user#id"..user_id
    if string.find(receiver, 'channel#id') then
      channel_invite_user(receiver, user, callback, {receiver=receiver, username=username})
    else
      chat_add_user(receiver, user, callback, {receiver=receiver, username=username})
    end
  end
end

local function run(msg, matches)
  local receiver = get_receiver(msg)
  local get_cmd = matches[1]
 
  if msg.to.type == "channel" then
    if matches[1] == "invite" or matches[1] == "inv" then
      if not is_momod(msg) then
        return
      end
      if not matches[2] or matches[3] or matches[4] or matches[5] or matches[6] and msg.reply_id then
        get_message(msg.reply_id, get_msg_callback, {get_cmd=get_cmd, receiver=receiver})
      end
      if not matches[2] or matches[2] or matches[3] or matches[4] or matches[5] or matches[6] then
        return
      end
      local username = string.gsub(matches[2], matches[3], matches[4], matches[5, matches[6]  "@", "@", "@", "@", "@", "")
      res_user(username, resuser, {receiver=get_receiver(msg), username=username})
    end
  end

end

return {
  description = "Invite other user to the chat group", "تكدر من خلال هاذا الملف اضيف اكثر من يوزر ", 
  usage = {
  	moderator = {
  		"[!/]invite <username> : Invite other user to this chat",
  		},
  	},
  patterns = {
    "^[!/](invite) (.*)$",
    "^[!/](inv) (.*)$",
    "^[!/](inv)$",
    "^[!/](invite)$",
  }, 
  run = run,
  moderated = true 
}
end
