chapter_id chapter01
chapter_name 咖啡馆的早晨
chapter_lang zh-CN
chapter_author Kona
chapter_desc 示例剧本，用于展示Konado剧本编辑器的功能

# 场景设置
background 咖啡厅背景 fade
# play bgm cafe_jazz
# 角色入场
actor show kona 正常1 at 0 30 scale 0.6 mirror

actor show daisy 正常 at 460 11 scale 0.6 mirror

# 对话开始
"可娜" "早安，Daisy！今天天气真好呢~"
"黛西" "早安Kona！你看起来心情不错啊。"
"可娜" "当然啦！刚尝了店长的新品咖啡..."
actor change kona 享受1
"可娜" "这杯冰美式简直太棒了！你要试试吗？"
# 选项分支
choice "好啊，给我来一杯" coffee_choice "不用了，我喝水就好" water_choice
tag coffee_choice
    "可娜" "马上就好！店长特制的咖啡豆..."
    "黛西" "哇，这个香气！"
    "可娜" "喝完一定会觉得神清气爽的！"
tag water_choice
    "可娜" "诶？真的不再考虑下吗？"
    actor change kona 正常2
    "黛西" "最近咖啡因摄入太多了，需要休息下"
    "可娜" "嗯嗯，理解理解。那就喝杯水吧！"
# 场景过渡
actor move kona 50 30
# 结束场景
"可娜" "时间过得真快，又到午休时间了"
actor exit daisy
"可娜" "明天见啦Daisy！"
end