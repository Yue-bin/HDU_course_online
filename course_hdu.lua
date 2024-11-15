local socket = require("socket")
local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("cjson")

local course_hdu = {}

function course_hdu.get_play_info(courseid, playtype, cookie)
    local url = string.format(
        "https://course.hdu.edu.cn/jy-application-vod-he-hdu/v1/course_vod_videoinfos?courseId=%d&playType=%d", courseid,
        playtype)
    local response_body = {}
    local body, code, headers, status = http.request {
        url = url,
        method = "GET",
        headers = {
            ["content-type"] = "application/json",
            ["user-agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
            ["cookie"] = cookie,
        },
        sink = ltn12.sink.table(response_body),
    }
    local list = nil
    if response_body ~= {} then
        list = {}
        response_body = json.decode(response_body[1])
        if response_body and response_body.data and response_body.data.courseDeviceViewDtoList then
            for _, v in pairs(response_body.data.courseDeviceViewDtoList) do
                local tmp = {}
                tmp.deviceid = v.chanGbidMain
                tmp.playurl = v.chanNameMainPlayUrl
                tmp.token = v.mainTokenStr
                table.insert(list, tmp)
            end
        end
    end
    return list, code, headers, status
end

return course_hdu
