shot_id test_shot
# 这是一个注释
actor show chara1 normal 0 100 200 1.0
"npc" "Hello, world!" voice_001
choice "Option 1" tag1 "Option 2" tag2
branch tag1
	"npc" "You chose option 1"
branch tag2
	"npc" "You chose option 2"
jump next_shot