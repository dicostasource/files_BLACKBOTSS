local function BGBBB_Black(data)
local msg = data.message_
local function bnnasend(chat_id, reply_to_message_id, disable_notification, text, disable_web_page_preview, parse_mode)
local TextParseMode = {ID = "TextParseModeMarkdown"}
tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_to_message_id,
disable_notification_ = disable_notification,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID = "InputMessageText",
text_ = text,
disable_web_page_preview_ = disable_web_page_preview,
clear_draft_ = 0,
entities_ = {},
parse_mode_ = TextParseMode,
},
}, dl_cb, nil)
end
function bnnaGet(user_id, cb)
tdcli_function ({
ID = "GetUser",
user_id_ = user_id
}, cb, nil)
end
function bnnchangeChatMemberStatus(chat_id, user_id, status)
tdcli_function ({
ID = "ChangeChatMemberStatus",
chat_id_ = chat_id,
user_id_ = user_id,
status_ = {
ID = "ChatMemberStatus" .. status
},
}, dl_cb, nil)
end
function bnnadelete_msg(chatid,mid)
tdcli_function ({
ID="DeleteMessages",
chat_id_=chatid,
message_ids_=mid
},
dl_cb, nil)
end
local msg = data.message_
text = msg.content_.text_
if text then 
if (text:match("(الغاء حظر اسم) (.*)") and Owner(msg)) then 
e = {string.match(text, "^(الغاء حظر اسم) (.*)$")}
bnnasend(msg.chat_id_, msg.id_, 1, "🔘┇ تم الغاء حظر {"..e[2].."}", 1, 'html')
database:srem("Black:block:name:"..bot_id..msg.chat_id_,e[2])
return "Black"
end
if (text:match("(حظر اسم) (.*)") and Owner(msg)) then 
e = {string.match(text, "^(حظر اسم) (.*)$")}
bnnasend(msg.chat_id_, msg.id_, 1, "☑️┇ تم حظر {"..e[2].."}", 1, 'html')
database:sadd("Black:block:name:"..bot_id..msg.chat_id_,e[2])
end
if ((text == "مسح الاسماء المحظوره" or text == "حذف الاسماء المحظوره" or text == "مسح قائمه الاسماء المحظوره") and Owner(msg)) then 
database:del("Black:block:name:"..bot_id..msg.chat_id_)
bnnasend(msg.chat_id_, msg.id_, 1, "🗳┇تم المسح بنجاح", 1, 'html')
end
if ((text == "الاسماء المحظوره" or text == "قائمه الاسماء المحظوره") and Owner(msg)) then 
names_Black = database:smembers("Black:block:name:"..bot_id..msg.chat_id_)
if (names_Black and names_Black[1] and #names_Black ~= 0) then 
text_Black = "⚠┇قائمة الاسماء الممنوعه ،\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ \n"
for i=1,#names_Black do 
text_Black = text_Black.."*|"..i.."|*~⪼("..names_Black[i]..")\n"
end
bnnasend(msg.chat_id_, msg.id_, 1, text_Black, 1, 'html')
else
bnnasend(msg.chat_id_, msg.id_, 1, "🗳┇لا يوجد اسماء محظوره", 1, 'html')
end
end
if (text == "تفعيل طرد الاسم" and Owner(msg)) then 
bnnasend(msg.chat_id_, msg.id_, 1, "☑️┇تم التفعيل سيتم طرد العضو الذي يضع الاسماء المحظوره", 1, 'html')
database:set("Black:block:name:stats:"..bot_id..msg.chat_id_,"Black_block")
end
if (text == "تفعيل كتم الاسم" and Owner(msg)) then 
bnnasend(msg.chat_id_, msg.id_, 1, "☑️┇تم التفعيل سيتم كتم العضو الذي يضع الاسماء المحظوره", 1, 'html')
database:del("Black:block:name:stats:"..bot_id..msg.chat_id_)
end
if not Owner(msg) then
function BGBBB_name(t1,t2)
if t2.id_ then 
name_Black = ((t2.first_name_ or "") .. (t2.last_name_ or ""))
if name_Black then 
names_Black = database:smembers("Black:block:name:"..bot_id..msg.chat_id_) or ""
if names_Black and names_Black[1] then 
for i=1,#names_Black do 
if name_Black:match("(.*)("..names_Black[i]..")(.*)") then 
if not database:del("Black:block:name:stats:"..bot_id..msg.chat_id_) then 
bnnadelete_msg(msg.chat_id_,{[0] = msg.id_})
else 
bnnchangeChatMemberStatus(msg.chat_id_, msg.sender_user_id_, "Kicked")
end
end
end
end
end
end
end
bnnaGet(msg.sender_user_id_, BGBBB_name)
end
end
end
return {
	BGBBB_Black = BGBBB_Black,
}
