-- 我是示例

local course_hdu = require("course_hdu")

local cookie = course_hdu.login("username", "password")
local list1 = course_hdu.get_play_info(660674, 2, cookie)
print(table.concat(list1, "\n"))
