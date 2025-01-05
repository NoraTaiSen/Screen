-- EmojiLib.lua
local EmojiLib = {}

-- Mảng chứa emoji theo tên
EmojiLib.emojiList = {
    ["smile"] = "😊",
    ["heart"] = "❤️",
    ["star"] = "⭐",
    ["moon"] = "🌙",
    ["sun"] = "☀️",
    ["fire"] = "🔥",
    ["check"] = "✅",
    ["cross"] = "❌",
    ["heart_eyes"] = "😍",
    ["laugh"] = "😂",
    ["thumb_up"] = "👍",
    ["thumb_down"] = "👎",
    ["clap"] = "👏",
    ["eyes"] = "👀",
    ["cat_face"] = "🐱",
    ["dog_face"] = "🐶",
    ["rocket"] = "🚀",
    ["bicycle"] = "🚲",
    ["car"] = "🚗"
}

-- Hàm lấy emoji theo tên
function EmojiLib:getEmoji(name)
    return self.emojiList[name] or "❓"  -- Trả về emoji mặc định nếu tên không hợp lệ
end

-- Hàm chuyển đổi một chuỗi văn bản thành các emoji có thể đọc được
function EmojiLib:convertToEmoji(text)
    for name, emoji in pairs(self.emojiList) do
        text = text:gsub(name, emoji)
    end
    return text
end

-- Trả về tất cả các emoji có sẵn trong thư viện
function EmojiLib:getAllEmojis()
    return self.emojiList
end

return EmojiLib
